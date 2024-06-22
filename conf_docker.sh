#!/bin/bash

DOCKER_CONFIG_FILE="/etc/docker/daemon.json"

REGISTRY_MIRROR_URL="http://localhost:32000"

# Backup the config
cp "$DOCKER_CONFIG_FILE" "$DOCKER_CONFIG_FILE.bak"


if [ -s "$DOCKER_CONFIG_FILE" ]; then
  if grep -q '"registry-mirrors"' "$DOCKER_CONFIG_FILE"; then
    jq '.["registry-mirrors"] |= . + ["'"$REGISTRY_MIRROR_URL"'"]' "$DOCKER_CONFIG_FILE" > "$DOCKER_CONFIG_FILE.tmp"
  else
    jq '. + {"registry-mirrors": ["'"$REGISTRY_MIRROR_URL"'"]}' "$DOCKER_CONFIG_FILE" > "$DOCKER_CONFIG_FILE.tmp"
  fi
else
  echo '{"registry-mirrors": ["'"$REGISTRY_MIRROR_URL"'"]}' > "$DOCKER_CONFIG_FILE.tmp"
fi

mv "$DOCKER_CONFIG_FILE.tmp" "$DOCKER_CONFIG_FILE"

if command -v systemctl &> /dev/null; then
  systemctl restart docker
else
  service docker restart
fi

echo "Docker configuration updated and Docker service restarted."
