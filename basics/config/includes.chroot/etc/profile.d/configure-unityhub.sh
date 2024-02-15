#!/bin/sh

set -e

# Setup globaly installed unity editors.
# Onetime setup.

# Check if config has already been run.
if [ -f ${HOME}/.config/cpos/unityhub-config.stage ]; then
  return 0
fi

# Create folder for unity editors.
mkdir -p ${HOME}/Unity/Hub/Editor

# Loop through all unity editors.
for EDITOR in $(ls /opt/Unity-LTS/); do
  # Create symlink to globaly installed editor.
  ln -s /opt/Unity-LTS/${EDITOR} ${HOME}/Unity/Hub/Editor/${EDITOR}
done

# Create config directory for CPOS.
mkdir -p ${HOME}/.config/cpos

# Mark config stage as completed.
touch ${HOME}/.config/cpos/unityhub-config.stage
