#!/usr/bin/env bash
# up.sh – legt das kind-Cluster an (idempotent) und lädt die Images der App
set -euo pipefail
source "$(dirname "$0")/env.sh"
if kind get clusters 2>/dev/null | grep -qx "$CLUSTER"; then
  echo "✔ Cluster $CLUSTER läuft schon"
else
  sed "s/hostPort: 30080/hostPort: $NODEPORT_HOST/" "$LAB/setup/kind.yaml" \
    | kind create cluster --name "$CLUSTER" --config - --wait 120s
fi
"$LAB/setup/images.sh" 0.1.0
