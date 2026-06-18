#!/bin/bash
# =============================================================================
# Monorepo Root Workspace — Git Setup Script
# Review every command before running. Execute from the root workspace folder.
# =============================================================================

set -euo pipefail

echo "=== Step 1: Initialize root git repo ==="
git init

echo "=== Step 2: Add .gitignore and root config files ==="
git add .gitignore .gitmodules .claude/ .agents/ git-setup.sh

echo "=== Step 3: Register submodules ==="
# These commands register the existing folders as submodules.
# Prerequisite: both Luvax/ and app-fe/ must already be initialized
# git repos with their remote URLs configured.
git submodule add https://github.com/zentech-graduation/Luvax.git Luvax
git submodule add https://github.com/zentech-graduation/app-fe.git app-fe

echo "=== Step 4: Initial commit on root repo ==="
git add .
git commit -m "chore(ci): initialize monorepo workspace with submodules"

echo "=== Step 5: Add root remote and push ==="
# Replace the URL below with the root aggregator repo URL on GitHub
# git remote add origin <ROOT_REPO_REMOTE_URL>
# git push -u origin main
echo "ACTION REQUIRED: Uncomment and fill in the root remote URL, then push manually."

echo "=== Done ==="
