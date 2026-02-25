#!/bin/bash

# Menu: Docker Management
# Description: Export all project files and Docker volumes for VPS migration.

vps_export() {
    echo ""
    echo "=============================================="
    echo "  VPS Migration Export"
    echo "=============================================="
    echo ""

    # --- Discover docker-compose projects in home directory ---
    echo "Scanning for Docker Compose projects in $HOME ..."
    COMPOSE_DIRS=()
    while IFS= read -r compose_file; do
        COMPOSE_DIRS+=("$(dirname "$compose_file")")
    done < <(find "$HOME" -maxdepth 2 -name "docker-compose.yml" -not -path "*/.git/*")

    if [ ${#COMPOSE_DIRS[@]} -eq 0 ]; then
        echo "  No Docker Compose projects found in $HOME."
    else
        echo "  Found ${#COMPOSE_DIRS[@]} project(s):"
        for dir in "${COMPOSE_DIRS[@]}"; do
            echo "    - $dir"
        done
    fi

    # --- Discover Docker named volumes ---
    echo ""
    echo "Scanning for Docker named volumes..."
    VOLUMES=$(docker volume ls --format "{{.Name}}" --filter driver=local)

    if [ -z "$VOLUMES" ]; then
        echo "  No Docker named volumes found."
    else
        VOL_COUNT=$(echo "$VOLUMES" | wc -l)
        echo "  Found $VOL_COUNT volume(s):"
        echo "$VOLUMES" | while read -r vol; do
            echo "    - $vol"
        done
    fi

    echo ""
    echo "This script will export:"
    echo "  - All project folders listed above"
    echo "  - Key dotfiles (.env, .ssh, .bashrc, .profile, .config/gh)"
    echo "  - All Docker named volumes listed above"
    echo ""
    read -rp "Continue? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi

    echo ""
    read -rp "Stop all containers before exporting? (recommended for clean DB snapshots) [y/N]: " stop_containers

    if [[ "$stop_containers" =~ ^[Yy]$ ]]; then
        echo ""
        echo "Stopping all running containers..."
        for dir in "${COMPOSE_DIRS[@]}"; do
            echo "  Stopping: $dir"
            docker compose -f "$dir/docker-compose.yml" down 2>/dev/null
        done
        echo "Done."
    fi

    # --- Setup output directory ---
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    EXPORT_DIR="$HOME/vps-migration"
    STAGE_DIR="$EXPORT_DIR/stage-$TIMESTAMP"
    mkdir -p "$STAGE_DIR"

    echo ""
    echo "----------------------------------------------"
    echo "  Step 1: Exporting project files"
    echo "----------------------------------------------"

    FILES_ARCHIVE="$STAGE_DIR/vps-files-$TIMESTAMP.tar.gz"

    # Build tar include list from discovered compose dirs (relative to $HOME)
    INCLUDE_DIRS=()
    for dir in "${COMPOSE_DIRS[@]}"; do
        REL=$(realpath --relative-to="$HOME" "$dir")
        INCLUDE_DIRS+=("$REL")
    done

    # Add dotfiles if they exist
    DOTFILES=(.env .ssh .bashrc .profile)
    for df in "${DOTFILES[@]}"; do
        [ -e "$HOME/$df" ] && INCLUDE_DIRS+=("$df")
    done
    [ -d "$HOME/.config/gh" ] && INCLUDE_DIRS+=(".config/gh")

    echo "  Archiving files..."
    tar czf "$FILES_ARCHIVE" \
        --ignore-failed-read \
        -C "$HOME" \
        "${INCLUDE_DIRS[@]}" \
        2>/dev/null

    if [ -f "$FILES_ARCHIVE" ]; then
        echo "  ✔ Files archived: $(du -sh "$FILES_ARCHIVE" | cut -f1)"
    else
        echo "  ✘ File archive failed."
    fi

    echo ""
    echo "----------------------------------------------"
    echo "  Step 2: Exporting Docker named volumes"
    echo "----------------------------------------------"

    VOLUMES_DIR="$STAGE_DIR/volumes"
    mkdir -p "$VOLUMES_DIR"

    if [ -z "$VOLUMES" ]; then
        echo "  No volumes to export. Skipping."
    else
        echo "$VOLUMES" | while read -r vol; do
            echo "  Exporting: $vol ..."
            docker run --rm \
                -v "$vol":/data \
                -v "$VOLUMES_DIR":/backup \
                alpine tar czf "/backup/$vol.tar.gz" -C /data . 2>/dev/null

            if [ $? -eq 0 ]; then
                echo "    ✔ Done ($(du -sh "$VOLUMES_DIR/$vol.tar.gz" | cut -f1))"
            else
                echo "    ✘ Failed — volume may be empty or in use."
            fi
        done
    fi

    echo ""
    echo "----------------------------------------------"
    echo "  Step 3: Creating final transfer archive"
    echo "----------------------------------------------"

    FINAL_ARCHIVE="$EXPORT_DIR/vps-migration-$TIMESTAMP.tar.gz"
    echo "  Bundling everything..."
    tar czf "$FINAL_ARCHIVE" -C "$EXPORT_DIR" "stage-$TIMESTAMP"

    if [ -f "$FINAL_ARCHIVE" ]; then
        echo "  ✔ Final archive: $FINAL_ARCHIVE"
        echo "  Total size: $(du -sh "$FINAL_ARCHIVE" | cut -f1)"
        rm -rf "$STAGE_DIR"
    else
        echo "  ✘ Failed to create final archive."
        echo "    Your files and volumes are still available in: $STAGE_DIR"
    fi

    echo ""
    echo "=============================================="
    echo "  Export Complete!"
    echo "=============================================="
    echo ""
    echo "Transfer your archive to the new VPS with:"
    echo ""
    echo "  scp $FINAL_ARCHIVE YOUR_USER@NEW_VPS_IP:~/"
    echo ""
    echo "Then install and run vps-import on the new server."
    echo ""
}

vps_export
