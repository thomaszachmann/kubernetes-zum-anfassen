#!/usr/bin/env bash
# shellcheck disable=SC2015  # ok() gibt immer 0 zurück
# check.sh – prüft das Trainingsgelände; Exit-Code = Zahl der ✘
source "$(dirname "$0")/env.sh"
fail=0
ok() { echo "✔ $1"; }
ko() { echo "✘ $1"; fail=$((fail + 1)); }
docker info >/dev/null 2>&1 && ok "Docker läuft" || ko "Docker läuft nicht (colima start)"
for t in kind kubectl helm jq; do
  command -v "$t" >/dev/null && ok "$t vorhanden" || ko "$t fehlt (brew install $t)"
done
kind get clusters 2>/dev/null | grep -qx "$CLUSTER" \
  && ok "Cluster $CLUSTER vorhanden" || ko "Cluster $CLUSTER fehlt ($LAB/setup/up.sh)"
ready=$(kubectl --context "kind-$CLUSTER" get nodes --no-headers 2>/dev/null \
  | grep -c ' Ready ')
[ "$ready" -ge 3 ] && ok "$ready Nodes Ready" || ko "nur $ready Nodes Ready"
[ -d "$NOTES/notes-api" ] && ok "Demo-Anwendung unter $NOTES" || ko "$NOTES fehlt"
exit "$fail"
