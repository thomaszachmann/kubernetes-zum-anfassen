#!/usr/bin/env bash
# images.sh [VERSION] – baut notes-api, notes-worker, notes-web und lädt sie ins Cluster
set -euo pipefail
source "$(dirname "$0")/env.sh"
version="${1:-0.1.0}"
for app in api worker web; do
  docker build -q --build-arg VERSION="$version" \
    -t "notes-$app:$version" "$NOTES/notes-$app" >/dev/null
  kind load docker-image "notes-$app:$version" --name "$CLUSTER" >/dev/null 2>&1
  echo "✔ notes-$app:$version gebaut und geladen"
done
