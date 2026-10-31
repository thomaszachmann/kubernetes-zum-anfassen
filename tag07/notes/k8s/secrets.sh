#!/usr/bin/env bash
# k8s/secrets.sh – Stand Ende Tag 7: legt die Secrets an (idempotent, nur Lab-Werte)
set -euo pipefail
kubectl -n notes create secret generic notes-api \
  --from-literal=api-key="${NOTES_API_KEY:-lab-api-key-123}" \
  --dry-run=client -o yaml | kubectl apply -f -
pw="${POSTGRES_PASSWORD:-lab-db-pw-123}"
kubectl -n notes create secret generic notes-db \
  --from-literal=password="$pw" \
  --from-literal=db-url="postgres://notes:$pw@db:5432/notes" \
  --dry-run=client -o yaml | kubectl apply -f -
