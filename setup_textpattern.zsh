#!/bin/zsh

# --- CONFIGURABLE VARIABLES ---
REPO_URL="https://github.com/textpattern/textpattern.git"
REPO_BRANCH="dev"
REPO_DIR="textpattern"
TMP_DIR="textpattern_tmp"
SETUP_JSON="setup.json"

# List of files/folders (relative to $REPO_DIR) to delete; extend/alter as needed
TO_DELETE=(
  ".git"
  ".github"
  ".gitignore"
  ".gitattributes"
  ".phpstorm.meta.php"
  "phpcs.xml"
  "composer.lock"
  "composer.json"
  "package.json"
  "HISTORY.txt"
  "UPGRADE.txt"
  "INSTALL.txt"
  "LICENSE.txt"
  "README.txt"
  "README.md"
  "CONTRIBUTING.md"
  "CODE_OF_CONDUCT.md"
  "SECURITY.md"
  "rpc"
  "sites"
)

# --- SCRIPT START ---

set -e  # Exit on errors

# 1. Clone the repo
git clone "$REPO_URL" --branch "$REPO_BRANCH" --depth 1

# 2. Delete listed files/folders
for item in $TO_DELETE; do
  target="$REPO_DIR/$item"
  if [[ -e $target ]]; then
    rm -rf "$target"
    echo "Deleted: $target"
  fi
done

# 3. Rename the folder
mv "$REPO_DIR" "$TMP_DIR"

# 4. Copy contents to base folder
cp -a "$TMP_DIR/." .

# 5. Delete leftover folder
rm -rf "$TMP_DIR"

# 6. Read setup.json and create MySQL DB if it doesn't exist
if [[ ! -f $SETUP_JSON ]]; then
  echo "ERROR: $SETUP_JSON not found!"
  exit 1
fi

db_host=$(jq -r '.database.host' "$SETUP_JSON")
db_user=$(jq -r '.database.user' "$SETUP_JSON")
db_pass=$(jq -r '.database.password' "$SETUP_JSON")
db_name=$(jq -r '.database.db_name' "$SETUP_JSON")
db_char=$(jq -r '.database.charset' "$SETUP_JSON")

if mysql -h"$db_host" -u"$db_user" -p"$db_pass" -e "USE \`$db_name\`;" 2>/dev/null; then
  echo "Database $db_name already exists. Exiting."
  exit 1
else
  mysql -h"$db_host" -u"$db_user" -p"$db_pass" --default-character-set="$db_char" -e "CREATE DATABASE \`$db_name\`;"
  echo "Database $db_name created."
fi

# 7. Run setup
php textpattern/setup/setup.php --config="$SETUP_JSON"
