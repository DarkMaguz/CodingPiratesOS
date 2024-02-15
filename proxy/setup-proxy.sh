#!/bin/sh -e

# This script prepairs the proxy caching server by generating a self-signed 
# certificate and initializing the cache and log directories.
# Finally it configures docker to use the proxy in the 
# docker config file located at ~/.docker/config.json

# Get the lastest debian:trixie image.
docker pull debian:trixie

# Create a bridge network if it doesn't already exist.
if [ -z "$(docker network ls | grep cpos)" ]; then
  docker network create --driver bridge cpos > /dev/null \
    && echo "Created bridge network." \
    || echo "Failed to create bridge network."
fi

# Build the image.
docker build -t darkmagus/cpos-proxy .

# List of directories containing generated files.
DIR_LIST="etc/squid/certs cache log log/squid"

NON_EMPTY_DIRS=""
for DIR in ${DIR_LIST}; do
  # Create the directory.
  mkdir -p ${DIR}
  # Test for non-empty directory.
  if [ -n "$(ls -A ${DIR})" ]; then
    NON_EMPTY_DIRS="${NON_EMPTY_DIRS}\n   ${DIR}"
  fi
done

# Check if any of the directories are not empty.
if [ -n "${NON_EMPTY_DIRS}" ]; then
  # Ask the user if they want to proceed.
  TITLE="!!! WARNING !!!"
  QUESTION="The following directories are not empty and will be deleted:\n\
${NON_EMPTY_DIRS}\n\n\n\
Do you want to proceed?"

  # Count the number non-empty directories.
  LINE_COUNT=$(echo "${NON_EMPTY_DIRS}" | wc -l)

  # Ask the user if they want to continue.
  if ! whiptail --title "${TITLE}" --yesno "${QUESTION}" $((LINE_COUNT + 12)) 70 --defaultno; then
    echo "Aborting..."
    echo 
    return 1
  fi
  echo "Deleting files..."
  # Delete all files in the non-empty directories.
  for DIR in $(echo ${NON_EMPTY_DIRS} | tr -d ' ' | tr '\n' ' '); do
    # Use docker to delete the files as root.
    docker run --rm \
      --volume "${PWD}/${DIR}:/tmp/deleteme" \
      --entrypoint "" \
      darkmagus/cpos-proxy \
      sh -c "rm -rf /tmp/deleteme/*"
  done
fi

# Generate a self-signed certificate valid for 100 years.
docker run --rm \
  --volume ${PWD}/etc/squid:/etc/squid:rw \
  --volume ${PWD}/etc/ssl/openssl.cnf:/etc/ssl/openssl.cnf:ro \
  --workdir /etc/squid/certs \
  --name proxy_setup \
  --entrypoint "" \
  darkmagus/cpos-proxy \
  openssl req -x509 -nodes -days 36500 -newkey rsa:2048 -subj "/CN=proxy" \
    -keyout proxy-selfsigned.key \
    -out proxy-selfsigned.crt

# Initialize log and cache directories.
docker run --rm \
  --volume ${PWD}/etc/squid:/etc/squid:rw \
  --volume ${PWD}/etc/ssl/openssl.cnf:/etc/ssl/openssl.cnf:ro \
  --volume ${PWD}/cache:/var/spool/squid:rw \
  --volume ${PWD}/log:/var/log:rw \
  --volume ${PWD}/docker-initialize.sh:/docker-initialize.sh:ro \
  --name proxy_setup \
  --entrypoint "./docker-initialize.sh" \
  darkmagus/cpos-proxy

# Initialize log and cache directories.
# echo " --- Any warnings below about IPV6 can safely be ignored."
# docker run --rm \
#   --volume ${PWD}/etc-squid:/etc/squid:rw \
#   --volume ${PWD}/openssl.cnf:/etc/ssl/openssl.cnf:ro \
#   --volume ${PWD}/cache:/var/spool/squid:rw \
#   --volume ${PWD}/log:/var/log:rw \
#   --name proxy_setup \
#   --entrypoint "" \
#   darkmagus/cpos-proxy sh -c \
#   "/usr/lib/squid/security_file_certgen -c -s /var/log/ssl_db -M 20MB && \
#   squid -z"
# echo " --- Any warnings above about IPV6 can safely be ignored."

# Setup config file for apt.
cat <<EOF > etc/apt/apt.conf
Acquire::http::proxy "http://proxy:3128";
Acquire::https::proxy "http://proxy:3128";
Acquire::ftp::proxy "http://proxy:3128";
EOF

# Docker config file of the current user.
DOCKER_CFG_FILE=${HOME}/.docker/config.json

# Docker config file content to be written.
DOCKER_CFG=$(cat <<EOF
{
  "proxies": {
    "default": {
      "httpProxy": "http://proxy:3128",
      "httpsProxy": "https://proxy:3128"
    }
  }
}
EOF
)

# If the docker config file does not exist or is empty, create it and return 0.
if [ ! -f ${DOCKER_CFG_FILE} ] || [ -z "$(cat ${DOCKER_CFG_FILE})" ]; then
  mkdir -p ${HOME}/.docker || true
  echo "${DOCKER_CFG}" > ${DOCKER_CFG_FILE}
  echo "A new docker config file has been created."
  return 0
fi

# If the docker config file is equal to the new cfg, return 0.
if [ "$(cat ${DOCKER_CFG_FILE})" = "${DOCKER_CFG}" ]; then
  echo "The docker config file is already setup correctly."
  return 0
fi

# Backup the current docker config file.
DOCKER_CFG_BACKUP="${DOCKER_CFG_FILE}.bak_$(date "+%s")"
cp $DOCKER_CFG_FILE $DOCKER_CFG_BACKUP

# Function to display the differences between the current docker config file and new cfg.
diff_cfg() {
  mkfifo DIFF_PIPE
  echo "$DOCKER_CFG" | \
    diff -u \
    --label "Current cfg" \
    --label "Changes" \
    --color=always \
    $DOCKER_CFG_FILE \
    - > DIFF_PIPE &
  less -R -c < DIFF_PIPE
  rm DIFF_PIPE
}

while [ true ]; do
  RESULT=$(
  whiptail --title "Docker Config File Already Contains Proxy Settings" \
  --menu "Choose an option" 25 78 16 \
  "Overwrite" "Overwrite the current docker config file." \
  "Diff" "Show the differences between the current " \
  "Ignore" "Append the proxy settings to the current docker config file." \
  "Cancel" "End setup without changing the docker config file." 3>&2 2>&1 1>&3 || true
  )

  case "${RESULT}" in
    "Overwrite")
      echo "Overwriting current configuration."
      echo "${DOCKER_CFG}" > ${DOCKER_CFG_FILE}
      break
    ;;
    "Diff")
    diff_cfg
    ;;
    "Append")
      echo "Appending new configuration."
      echo "${DOCKER_CFG}" >> ${DOCKER_CFG_FILE}
      break
    ;;
    "Cancel" | *)
      echo "Cancel"
      break
    ;;
  esac
done

# Check if there has been any changes to the docker config file.
if [ -z "$(diff ${DOCKER_CFG_FILE} ${DOCKER_CFG_BACKUP})" ]; then
  echo "No changes was made to the docker config file."
  rm $DOCKER_CFG_BACKUP
else
  echo "A backup of the docker config file has been created at ${DOCKER_CFG_BACKUP}."
fi
