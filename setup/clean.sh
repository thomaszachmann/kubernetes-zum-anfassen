#!/usr/bin/env bash
# clean.sh [--all] – räumt den Namespace notes ab; --all löscht das ganze Cluster
set -euo pipefail
source "$(dirname "$0")/env.sh"
if [ "${1:-}" = "--all" ]; then
  kind delete cluster --name "$CLUSTER"
else
  helm --kube-context "kind-$CLUSTER" uninstall notes -n "$NS" 2>/dev/null || true
  kubectl --context "kind-$CLUSTER" delete namespace "$NS" --ignore-not-found --wait
fi
echo "✔ aufgeräumt"
