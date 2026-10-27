#!/usr/bin/env bash
set -euo pipefail

# 1. Generate the latest reference
./docs/reference/generate.sh

# 2. Clone or update the wiki repo temporarily
wiki_dir=$(mktemp -d)
git clone --quiet https://github.com/Trivaris/Trivnix.wiki.git "$wiki_dir"

# 3. Copy the reference as the Home page (or any named wiki page)
cp docs/reference/README.md "$wiki_dir/Home.md"

# 4. Commit and push to the wiki
cd "$wiki_dir"
git add Home.md
if git diff --cached --quiet; then
    echo "Wiki is already up to date."
else
    git commit -m "Update option reference from main"
    git push origin master
    echo "Wiki published successfully!"
fi
