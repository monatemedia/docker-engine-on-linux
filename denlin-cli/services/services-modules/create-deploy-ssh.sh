#!/bin/bash

# Main script: Configure VPS
# Description: Generate and install a per-environment SSH deploy key, then store it as GitHub Actions secrets

# Get the username of the logged-in user on the VPS
vps_user=$(whoami)

# Variables
CONF_FILE="/etc/denlin-cli.conf"

# Step 1: Check if configuration file exists
if [ -f "$CONF_FILE" ]; then
    source "$CONF_FILE"
fi

# Step 2: Ask for VPS IP
if [ -z "$vps_ip" ]; then
    read -p "Enter your VPS IP address: " vps_ip
else
    read -p "VPS IP ($vps_ip): Do you want to change it? (y/n): " confirm_ip
    if [ "$confirm_ip" == "y" ]; then
        read -p "Enter your VPS IP address: " vps_ip
    fi
fi

# Step 3: Ask which environment this deploy key is for
echo "This key is used by GitHub Actions to deploy — not for your own personal login"
echo "(use 'denlin setup-ssh-login' for that instead)."
while true; do
    read -p "Which environment is this deploy key for? (staging/production): " deploy_environment
    if [[ "$deploy_environment" == "staging" || "$deploy_environment" == "production" ]]; then
        break
    fi
    echo "Please enter 'staging' or 'production'."
done
env_upper=$(echo "$deploy_environment" | tr '[:lower:]' '[:upper:]')

# Named per-environment (not a fixed "/tmp/create-deploy-ssh-temp.sh") so that
# running this twice in a row for two different environments — staging, then
# production, say — before downloading/running the first one can't silently
# overwrite it on the VPS. That collision used to be real: the second run's
# temp script would clobber the first's at the same fixed path, so only the
# second environment's key ever actually got generated even though both runs
# reported success.
TEMP_SCRIPT="/tmp/create-deploy-ssh-temp-${deploy_environment}.sh"

# Step 4: Ask for the project name and build the work dir from it, rather
# than asking for the full absolute path directly — a hand-typed path is an
# easy place to fat-finger a typo (wrong username, wrong app name, forgetting
# the -staging/-production suffix, a stray extra slash), and unlike most
# typos this one fails silently: it just creates/uses a different directory
# than intended, with no error, and can end up sharing a path with another
# environment's docker-compose.yml.
echo "The work dir is built for you as /home/${vps_user}/<project>-${deploy_environment} —"
echo "you only need to give the project name below (must be unique among whatever"
echo "other apps/environments already share this VPS)."
while true; do
    read -p "Project name (lowercase, kebab-case, e.g. 'actuallyfind' or 'my-app'): " project_name
    if [[ "$project_name" =~ ^[a-z][a-z0-9]*(-[a-z0-9]+)*$ ]]; then
        break
    fi
    echo "Please use lowercase letters, digits, and hyphens only, starting with a letter"
    echo "(kebab-case) — e.g. 'actuallyfind' or 'my-app', not 'ActuallyFind' or 'my_app'."
done
work_dir="/home/${vps_user}/${project_name}-${deploy_environment}"
echo "Work dir will be: $work_dir"

# Step 5: Save vps_ip to configuration file (github_username/CR_PAT untouched if already set)
echo "Saving configuration to $CONF_FILE..."
sudo bash -c "cat <<EOL > $CONF_FILE
vps_ip=\"$vps_ip\"
github_username=\"${github_username:-}\"
CR_PAT=\"${CR_PAT:-}\"
EOL"

# Step 6: Create the temporary script — everything below runs on the LOCAL
# machine, not the VPS: keygen, ssh-copy-id (local -> VPS), and gh secret set
# (needs the local project's git remote) all have to happen there.
echo "Creating the temporary script to configure the deploy key locally..."
cat <<EOL >"$TEMP_SCRIPT"
#!/bin/bash

set -e

# NOTE ON MSYS_NO_PATHCONV: this used to be exported globally right here, for
# the whole script. That was wrong — it broke ssh-keygen for anyone whose
# Windows PATH resolves \`ssh-keygen\` to Windows' own built-in OpenSSH client
# (C:\\Windows\\System32\\OpenSSH\\ssh-keygen.exe, not Git's MSYS-runtime-linked
# one) rather than Git for Windows' bundled version: with MSYS_NO_PATHCONV set,
# Bash stops auto-converting "\$HOME/.ssh/..." into a real Windows path before
# handing it to a native (non-MSYS) binary, so a genuinely native ssh-keygen.exe
# gets a literal "/c/Users/.../.ssh/..." string it can't resolve and fails with
# "No such file or directory" — even though \`mkdir -p ~/.ssh\` right beforehand
# succeeds, since that's Git Bash's own MSYS-native mkdir, unaffected either way.
# \$WORK_DIR is a different case: it's never meant to be resolved as a path on
# THIS machine at all — it's just a string describing a path on the remote VPS —
# so gh.exe (also genuinely native, no MSYS runtime) must NOT have it rewritten.
# Scoped narrowly to just the \`gh secret set\` calls below instead of exported
# for the whole script, so ssh-keygen/ssh-copy-id/ssh get normal path handling.

VPS_USER="$vps_user"
VPS_IP="$vps_ip"
DEPLOY_ENVIRONMENT="$deploy_environment"
ENV_UPPER="$env_upper"
WORK_DIR="$work_dir"

# Step 1: Identify the current project's repo name and GitHub remote
application_name=\$(basename "\$(pwd)")
remote_url=\$(git config --get remote.origin.url)
if [[ -z "\$remote_url" ]]; then
    echo "Error: No remote URL found. Run this from the project's root folder."
    exit 1
fi
if [[ "\$remote_url" =~ github\.com[:/](.+)/(.+)\.git ]]; then
    repo_owner="\${BASH_REMATCH[1]}"
    repo_name="\${BASH_REMATCH[2]}"
else
    echo "Error: Unable to parse the remote URL '\$remote_url'."
    exit 1
fi
full_repo="\${repo_owner}/\${repo_name}"

# Step 2: Generate the key pair — NO passphrase (-N ""). This key is loaded
# unattended by GitHub Actions' ssh-agent step; there is no human present to
# answer a passphrase prompt in CI, so a protected key fails silently there.
# (This is the opposite of 'denlin setup-ssh-login', which is a human's own
# login key and correctly DOES prompt for a passphrase.)
key_path="\$HOME/.ssh/\${application_name}_\${DEPLOY_ENVIRONMENT}_\$(date +%Y)"
if [ -f "\$key_path" ]; then
    echo "Reusing existing key: \$key_path"
else
    # ssh-keygen won't create a missing ~/.ssh itself — it just fails with
    # "No such file or directory" if this is the first time SSH has ever
    # written anything there on this machine. Cheap to guard unconditionally.
    mkdir -p "\$HOME/.ssh"
    echo "Generating ed25519 key pair (no passphrase — used unattended by CI)..."
    ssh-keygen -t ed25519 -N "" -f "\$key_path" -C "\${application_name}-\${DEPLOY_ENVIRONMENT}+\$(date +%Y)@monatemedia.com"
fi

# Step 3: Install the public key on the VPS
echo "Copying public key to \$VPS_USER@\$VPS_IP..."
ssh-copy-id -i "\${key_path}.pub" "\$VPS_USER@\$VPS_IP"

# Step 4: Preflight — a lightweight reachability/banner check, loosely
# mirroring the 'Add Server to Known Hosts' CI step. Some local ssh-keyscan
# builds on Windows can't negotiate with Ubuntu 24.04's OpenSSH 9.6, which
# offers the sntrup761x25519-sha512@openssh.com hybrid post-quantum KEX
# method by default — either failing outright with "unsupported KEX method",
# or (on older builds with no algorithm-override flag at all — no -o, only
# the unrelated -O) never getting that far. Passing an explicit KexAlgorithms
# override to work around this reliably isn't possible across every
# ssh-keyscan build in the wild, so instead: treat those two specific
# failure signatures as a known local-tooling gap, not a real connectivity
# problem — proven by ssh-copy-id (which uses ssh.exe, not ssh-keyscan.exe)
# having already succeeded immediately above — and don't hard-fail on them.
# Still hard-fail on anything else (bad IP, closed firewall, downed VPS),
# and Step 5 right after this does a full real login check regardless.
echo "Preflight: ssh-keyscan..."
# "|| true" is load-bearing here, not decoration: under 'set -e', a bare
# non-conditional command that exits non-zero kills the whole script right
# then and there — silently, since ssh-keyscan's own output is redirected
# into the check file rather than the terminal. That's exactly what a KEX
# negotiation failure does (it exits non-zero), so without "|| true" this
# line alone defeats the whole tolerant-check block below: the script would
# die right here with zero visible output, immediately after the "Preflight:
# ssh-keyscan..." echo, instead of ever reaching the logic that's supposed
# to treat that specific failure as non-fatal.
ssh-keyscan -T 10 -H "\$VPS_IP" > /tmp/deploy_ssh_keyscan_check 2>&1 || true
if [ ! -s /tmp/deploy_ssh_keyscan_check ] || grep -qiE "unsupported KEX method|unknown option" /tmp/deploy_ssh_keyscan_check; then
    if grep -qiE "unsupported KEX method|unknown option" /tmp/deploy_ssh_keyscan_check 2>/dev/null; then
        echo "⚠️  Local ssh-keyscan couldn't negotiate with the VPS (known limitation of"
        echo "    some ssh-keyscan builds, not a real connectivity problem) — skipping."
        echo "    Continuing to the real login preflight, which uses ssh directly."
    else
        echo "Error: ssh-keyscan could not reach \$VPS_IP. Check the IP, firewall (port 22), and that the VPS is up."
        cat /tmp/deploy_ssh_keyscan_check 2>/dev/null || true
        rm -f /tmp/deploy_ssh_keyscan_check
        exit 1
    fi
fi
rm -f /tmp/deploy_ssh_keyscan_check

# Step 5: Preflight — non-interactive login, mirroring how GitHub Actions'
# ssh-agent step will use this key with no human present.
echo "Preflight: non-interactive login..."
if ! ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -i "\$key_path" "\$VPS_USER@\$VPS_IP" "echo SSH_OK" | grep -q SSH_OK; then
    echo "Error: key-based login failed in batch mode."
    if ! ssh-keygen -y -P "" -f "\$key_path" >/dev/null 2>&1; then
        echo "\$key_path is passphrase-protected — that is the likely cause. Strip it with:"
        echo "  ssh-keygen -p -f \"\$key_path\" -N \"\""
    else
        echo "Check that the public key was actually added to ~/.ssh/authorized_keys for \$VPS_USER on the VPS."
    fi
    exit 1
fi
echo "Both preflight checks passed."

# Step 6: Upload the four secrets. \$WORK_DIR describes a path on the remote
# VPS, not this machine — scope MSYS_NO_PATHCONV here only, so gh.exe (a
# genuinely native binary, no MSYS runtime) receives it as the literal string
# it is instead of having Bash "helpfully" rewrite it into a local Windows
# path first. See the note above Step 2 for why this must NOT be exported
# any earlier — it broke ssh-keygen for the opposite reason.
export MSYS_NO_PATHCONV=1

if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) not found — install it first: https://cli.github.com/"
    exit 1
fi
if ! gh auth status &> /dev/null; then
    echo "You are not authenticated with GitHub CLI. Please authenticate now."
    gh auth login
fi

gh_env_flag=()
if [[ "\$DEPLOY_ENVIRONMENT" == "production" ]]; then
    echo "Uploading as Environment secrets scoped to 'production' (repo secrets alone won't"
    echo "respect any required-reviewer/branch protection rules later added to that Environment)."
    gh_env_flag=(--env production)
fi

echo
echo "Setting \${ENV_UPPER}_SSH_HOST / _SSH_USER / _SSH_KEY / _WORK_DIR for \$full_repo..."
gh secret set "\${ENV_UPPER}_SSH_HOST" --body "\$VPS_IP" --repo "\$full_repo" "\${gh_env_flag[@]}"
gh secret set "\${ENV_UPPER}_SSH_USER" --body "\$VPS_USER" --repo "\$full_repo" "\${gh_env_flag[@]}"
gh secret set "\${ENV_UPPER}_SSH_KEY" --repo "\$full_repo" "\${gh_env_flag[@]}" < "\$key_path"
gh secret set "\${ENV_UPPER}_WORK_DIR" --body "\$WORK_DIR" --repo "\$full_repo" "\${gh_env_flag[@]}"
echo "Done."

echo
echo "You can find these secrets here:"
echo "  https://github.com/\$full_repo/settings/secrets/actions"

echo
echo "✅ Your GitHub repo (\$full_repo) is now connected to the remote server (\$VPS_IP)."
echo "   GitHub Actions can deploy '\${DEPLOY_ENVIRONMENT}' to \$WORK_DIR on that VPS from here on."

# Step 7: Cleanup — VPS-side delete first, local self-delete last. See
# provision-app-env.sh's cleanup_and_exit for why this order matters: this
# script deletes its own file (\$0), and doing that before a network call
# that still has to run risks the interpreter trying to keep reading from a
# file that's already gone out from under it — seen this hang on Windows on
# one run and not another with the same code, back to back.
echo "Cleaning up temporary script..."
ssh "${vps_user}@${vps_ip}" "rm $TEMP_SCRIPT"
rm -- "\$0"
echo "Cleanup complete. You may now close this terminal."
EOL

chmod +x "$TEMP_SCRIPT"

# Step 7: Provide instructions to the user
echo "To configure the deploy key locally, do the following:"
echo ""
echo "1. Open a terminal in the root of your PROJECT'S folder on your local computer"
echo "   (not this VPS, and not the denlin-cli folder — the actual app repo being deployed)."
echo ""
echo "2. Download the script using the following command:"
echo "   scp ${vps_user}@${vps_ip}:$TEMP_SCRIPT ./create-deploy-ssh-temp-${deploy_environment}.sh"
echo ""
echo "3. Run the script using:"
echo "   ./create-deploy-ssh-temp-${deploy_environment}.sh"
echo ""
echo "Once the script finishes, it will delete itself from both the VPS and the local computer."
