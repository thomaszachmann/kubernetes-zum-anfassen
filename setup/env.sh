# shellcheck shell=bash
# env.sh – zum source'n: Variablen des Trainingsgeländes
# Für Tests überschreibbar: LAB, CLUSTER, NODEPORT_HOST
export LAB="${LAB:-$HOME/k8s-lab}"
export NOTES="$LAB/notes"
export CLUSTER="${CLUSTER:-lab}"               # kind-Cluster, Kontext kind-$CLUSTER
export NODEPORT_HOST="${NODEPORT_HOST:-30080}" # Port auf dem Mac für NodePort/Gateway
export NS=notes
