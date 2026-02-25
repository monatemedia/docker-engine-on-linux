#!/bin/bash

# Menu: Docker Management
# Description: Import project files and Docker volumes onto a new VPS after migration.

vps_import() {
    echo ""
    echo "=============================================="
    echo "  VPS Migration Import"
    echo "=============================================="
    echo ""
    echo "This script will:"
    echo "  1. Extract your project files and dotfiles"
    echo "  2. Restore all Docker named volumes"
    echo "  3. Remind you of post-migration steps"
    echo ""

    # --- Check Docker is installed ---
    if ! command -v docker &> /dev/null; then
        echo "  ✘ Docker is not installed on this server."
        echo ""
        echo "  Please install Docker first, then re-run this script."
        echo "  You can install it with:"
        echo "    denlin docker-install"
        echo "  or visit: https://docs.docker.com/engine/install/ubuntu/"
        echo ""
        exit 1
    fi
    echo "  ✔ Docker is installed."
    echo ""

    # --- Step 1: Locate the migration archive ---
    echo "----------------------------------------------"
    echo "  Step 1: Locate the migration archive"
    echo "----------------------------------------------"
    echo ""

    FOUND_ARCHIVES=$(find "$HOME" -maxdepth 2 -name "vps-migration-*.tar.gz" 2>/dev/null)

    if [ -z "$FOUND_ARCHIVES" ]; then
        echo "  No migration archive found automatically."
        echo "  Expected filename pattern: vps-migration-YYYYMMDD_HHMMSS.tar.gz"
        echo ""
        read -rp "  Enter the full path to your migration archive: " ARCHIVE_PATH
    else
        echo "  Found archive(s):"
        echo "$FOUND_ARCHIVES" | while read -r f; do
            echo "    - $f ($(du -sh "$f" | cut -f1))"
        done
        echo ""
        ARCHIVE_PATH=$(echo "$FOUND_ARCHIVES" | sort | tail -n 1)
        echo "  Using most recent: $ARCHIVE_PATH"
        read -rp "  Press ENTER to confirm, or type a different path: " OVERRIDE_PATH
        [ -n "$OVERRIDE_PATH" ] && ARCHIVE_PATH="$OVERRIDE_PATH"
    fi

    if [ ! -f "$ARCHIVE_PATH" ]; then
        echo ""
        echo "  ✘ File not found: $ARCHIVE_PATH"
        echo "  Please check the path and try again."
        exit 1
    fi

    # --- Step 2: Extract the outer archive ---
    echo ""
    echo "----------------------------------------------"
    echo "  Step 2: Extracting archive"
    echo "----------------------------------------------"

    WORK_DIR="$HOME/vps-migration-restore"
    mkdir -p "$WORK_DIR"

    echo "  Extracting to: $WORK_DIR ..."
    tar xzf "$ARCHIVE_PATH" -C "$WORK_DIR"

    if [ $? -ne 0 ]; then
        echo "  ✘ Failed to extract archive. File may be corrupt."
        exit 1
    fi
    echo "  ✔ Archive extracted."

    # --- Step 3: Restore project files ---
    echo ""
    echo "----------------------------------------------"
    echo "  Step 3: Restoring project files"
    echo "----------------------------------------------"

    FILES_ARCHIVE=$(find "$WORK_DIR" -name "vps-files-*.tar.gz" | sort | tail -n 1)

    if [ -z "$FILES_ARCHIVE" ]; then
        echo "  ✘ Could not find files archive inside the migration bundle."
    else
        echo "  Archive found: $FILES_ARCHIVE"
        echo ""
        echo "  WARNING: This will restore files into $HOME, including:"
        echo "    - ~/.ssh  (authorized_keys and deploy keys)"
        echo "    - ~/.bashrc and ~/.profile"
        echo "    - ~/.env"
        echo "    - All project folders containing docker-compose.yml"
        echo ""
        read -rp "  Proceed with file restore? [y/N]: " confirm_files

        if [[ "$confirm_files" =~ ^[Yy]$ ]]; then
            tar xzf "$FILES_ARCHIVE" -C "$HOME"
            if [ $? -eq 0 ]; then
                echo "  ✔ Project files restored."
                source "$HOME/.bashrc" 2>/dev/null || true
            else
                echo "  ✘ File restore encountered errors. Some files may not have restored correctly."
            fi
        else
            echo "  Skipping file restore."
        fi
    fi

    # --- Step 4: Restore Docker volumes ---
    echo ""
    echo "----------------------------------------------"
    echo "  Step 4: Restoring Docker volumes"
    echo "----------------------------------------------"

    VOLUMES_DIR=$(find "$WORK_DIR" -type d -name "volumes" | head -n 1)

    if [ -z "$VOLUMES_DIR" ]; then
        echo "  No volumes directory found in bundle. Skipping."
    else
        VOLUME_FILES=$(find "$VOLUMES_DIR" -name "*.tar.gz")

        if [ -z "$VOLUME_FILES" ]; then
            echo "  No volume archives found. Skipping."
        else
            echo "  Found volume archives:"
            echo "$VOLUME_FILES" | while read -r f; do
                echo "    - $(basename "$f" .tar.gz)  ($(du -sh "$f" | cut -f1))"
            done
            echo ""
            read -rp "  Restore all volumes? [y/N]: " confirm_volumes

            if [[ "$confirm_volumes" =~ ^[Yy]$ ]]; then
                while IFS= read -r vol_archive; do
                    VOL_NAME=$(basename "$vol_archive" .tar.gz)
                    echo ""
                    echo "  Restoring: $VOL_NAME ..."

                    docker volume create "$VOL_NAME" > /dev/null 2>&1

                    EXISTING_DATA=$(docker run --rm -v "$VOL_NAME":/data alpine sh -c "ls /data | wc -l" 2>/dev/null)

                    if [ "${EXISTING_DATA:-0}" -gt 0 ] 2>/dev/null; then
                        echo "    ⚠ Volume already has data — skipping to avoid overwrite."
                        echo "      To force: docker volume rm $VOL_NAME  then re-run this script."
                    else
                        docker run --rm \
                            -v "$VOL_NAME":/data \
                            -v "$VOLUMES_DIR":/backup \
                            alpine tar xzf "/backup/$VOL_NAME.tar.gz" -C /data

                        if [ $? -eq 0 ]; then
                            echo "    ✔ Restored."
                        else
                            echo "    ✘ Failed to restore: $VOL_NAME"
                        fi
                    fi
                done <<< "$VOLUME_FILES"
            else
                echo "  Skipping volume restore."
            fi
        fi
    fi

    # --- Step 5: Cleanup ---
    echo ""
    echo "----------------------------------------------"
    echo "  Step 5: Cleanup"
    echo "----------------------------------------------"
    echo ""
    read -rp "  Delete the temporary restore directory ($WORK_DIR)? [y/N]: " cleanup

    if [[ "$cleanup" =~ ^[Yy]$ ]]; then
        rm -rf "$WORK_DIR"
        echo "  ✔ Temporary files removed."
    else
        echo "  Keeping restore directory at: $WORK_DIR"
    fi

    # --- Step 6: Post-migration checklist ---
    echo ""
    echo "=============================================="
    echo "  Import Complete!"
    echo "=============================================="
    echo ""
    echo "Post-migration checklist:"
    echo ""
    echo "  [ ] Create the Docker proxy network (if not already):"
    echo "        docker network create proxy-network"
    echo ""
    echo "  [ ] Start your proxy container FIRST (e.g. nginx-proxy):"
    echo "        cd ~/nginx-proxy && docker compose up -d"
    echo ""

    # Dynamically list all discovered compose projects for the startup reminder
    COMPOSE_PROJECTS=$(find "$HOME" -maxdepth 2 -name "docker-compose.yml" -not -path "*/.git/*" -not -path "*/nginx-proxy/*" 2>/dev/null)

    if [ -n "$COMPOSE_PROJECTS" ]; then
        echo "  [ ] Start your app containers:"
        while IFS= read -r compose_file; do
            PROJECT_DIR=$(dirname "$compose_file")
            echo "        cd $PROJECT_DIR && docker compose up -d"
        done <<< "$COMPOSE_PROJECTS"
        echo ""
    fi

    echo "  [ ] Update DNS records to point to this server's IP address."
    echo ""
    echo "  [ ] Check any cron jobs from the old server: crontab -l"
    echo ""
    echo "  [ ] Verify all containers are running: docker ps"
    echo ""
}

vps_import
