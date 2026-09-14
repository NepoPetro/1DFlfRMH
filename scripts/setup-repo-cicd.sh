#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Uso: $0 <owner> <repo>"
  exit 1
fi

OWNER="$1"
REPO="$2"
REQUIRED_CHECK="build-and-test"
MILESTONE_TITLE="Sprint 1"

echo "==> Verificando autenticación de gh..."
if ! gh auth status >/dev/null 2>&1; then
  echo "Error: gh no está autenticado. Corre 'gh auth login' primero."
  exit 1
fi

echo "==> Repositorio: ${OWNER}/${REPO}"
echo

echo "==> [1/6] Habilitando GitHub Actions en el repositorio..."
gh api -X PUT "repos/${OWNER}/${REPO}/actions/permissions" \
  -F enabled=true \
  -F allowed_actions=all

echo "==> [2/6] Configurando permisos mínimos del GITHUB_TOKEN..."
gh api -X PUT "repos/${OWNER}/${REPO}/actions/permissions/workflow" \
  -F default_workflow_permissions=read \
  -F can_approve_pull_request_reviews=false

echo "==> [3/6] Protegiendo la rama main..."
gh api -X PUT "repos/${OWNER}/${REPO}/branches/main/protection" \
  -F required_status_checks[strict]=true \
  -F "required_status_checks[contexts][]=${REQUIRED_CHECK}" \
  -F enforce_admins=true \
  -F "required_pull_request_reviews[required_approving_review_count]=1" \
  -F restrictions=null

echo "==> [4/6] Creando labels (ci, documentation, bug)..."
gh label create ci --repo "${OWNER}/${REPO}" \
  --color "0E8A16" --description "Relacionado a CI/CD" --force
gh label create documentation --repo "${OWNER}/${REPO}" \
  --color "0075CA" --description "Documentación" --force
gh label create bug --repo "${OWNER}/${REPO}" \
  --color "D73A4A" --description "Bug o falla" --force

echo "==> [5/6] Creando milestone '${MILESTONE_TITLE}'..."
EXISTING_MILESTONE=$(gh api "repos/${OWNER}/${REPO}/milestones" \
  --jq ".[] | select(.title==\"${MILESTONE_TITLE}\") | .number" || true)

if [ -z "${EXISTING_MILESTONE}" ]; then
  gh api -X POST "repos/${OWNER}/${REPO}/milestones" \
    -f title="${MILESTONE_TITLE}"
else
  echo "    Milestone ya existe (número ${EXISTING_MILESTONE}), se omite creación."
fi

echo "==> [6/6] Creando issue inicial vinculado al milestone..."
gh issue create --repo "${OWNER}/${REPO}" \
  --title "Configurar CI Sprint 1" \
  --body "Issue inicial generado por setup-repo-cicd.sh.

Criterios de aceptación:
- [ ] Workflow ejecutándose en push y PR a main/develop
- [ ] Protección de rama main activa
- [ ] Labels y milestone creados
- [ ] Documentación del flujo en la Wiki" \
  --milestone "${MILESTONE_TITLE}" \
  --label ci

echo
echo "==> Listo. Pendiente manual:"
echo "    - Cargar secrets reales en Settings > Secrets and variables > Actions"
echo "    - Crear el GitHub Project (tablero Kanban):"
echo "        gh project create --owner ${OWNER} --title \"Sprint Board\""
echo "    - Vincular PRs a issues con 'Closes #<numero>' en la descripción del PR"