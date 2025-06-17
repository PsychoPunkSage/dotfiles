#!/bin/bash

# Usage:
#   ./init-git.sh --personal repo-name
#   ./init-git.sh --work repo-name

# === CONFIG ===
PERSONAL_NAME="Abhinav Prakash"
PERSONAL_EMAIL="abhinav.prakash319@gmail.com"
PERSONAL_GPG="FB95F90CC39C5973"
PERSONAL_SSH="github.com"
PERSONAL_GH_USERNAME="PsychoPunkSage"

WORK_NAME="Abhinav Prakash"
WORK_EMAIL="a.prakash@supraoracles.com"
WORK_GPG="290B4EE63C14F0EF"
WORK_SSH="github.com-supra"
WORK_GH_USERNAME="Entropy-Foundation"

SEIZEUM_GH_USERNAME="Seizeum"

# ==============

# Parse flag and repo name
if [[ "$1" == "--personal" ]]; then
    PROFILE="personal"
elif [[ "$1" == "--work" ]]; then
    PROFILE="work"
elif [[ "$1" == "--seizeum" ]]; then
    PROFILE="seizeum"
else
    echo "❌ Usage: $0 [--personal|--work] <repo-name>"
    exit 1
fi

REPO="$2"

if [[ -z "$REPO" ]]; then
    echo "❌ Please provide a repository name."
    exit 1
fi

# Create and enter the repo directory
# git init "$REPO"
# cd "$REPO" || exit

# Apply settings based on profile
if [[ "$PROFILE" == "personal" ]]; then
    git remote set-url origin git@$PERSONAL_SSH:$PERSONAL_GH_USERNAME/$REPO.git
    git config user.name "$PERSONAL_NAME"
    git config user.email "$PERSONAL_EMAIL"
    git config user.signingkey "$PERSONAL_GPG"
elif [[ "$PROFILE" == "work" ]]; then
    git remote set-url origin git@$WORK_SSH:$WORK_GH_USERNAME/$REPO.git
    git config user.name "$WORK_NAME"
    git config user.email "$WORK_EMAIL"
    git config user.signingkey "$WORK_GPG"
else
    git remote set-url origin git@$PERSONAL_SSH:$SEIZEUM_GH_USERNAME/$REPO.git
    git config user.name "$PERSONAL_NAME"
    git config user.email "$PERSONAL_EMAIL"
    git config user.signingkey "$PERSONAL_GPG"
fi

git config commit.gpgSign true

# Initial commit
# echo "# $REPO" >README.md
# git add README.md
# git commit -S -m "Initial commit"

echo "✅ Repo '$REPO' initialized with $PROFILE profile."
