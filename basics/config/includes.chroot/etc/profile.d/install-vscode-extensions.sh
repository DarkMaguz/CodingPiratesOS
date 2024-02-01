#!/bin/sh

set -e

# Check if the extension is already installed
# if [ -n "$(code --list-extensions)" ]; then
#   return 0
# fi

EXTENTIONS_DIR=${HOME}/.cpos/vscode-extensions/

# Install the extensions from the extensions folder
for file in $(find ${EXTENTIONS_DIR} -type f -name "*.vsix"); do
  echo "Installing extension: ${file}"
  code --install-extension "${file}" || true
done
