#!/usr/bin/env bash
set -euo pipefail

# grc depends on private git packages. flutter pub get does not use git credential
# rewrites reliably, so clone all repos with the PAT and override them via
# pubspec_overrides.yaml before pub get.

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "ERROR: GITHUB_TOKEN is not set in Render environment variables."
  exit 1
fi

check_repo_access() {
  local repo="$1"
  local http_code
  http_code="$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/hananmalik21/${repo}")"

  case "${http_code}" in
    200) echo "GitHub token can access ${repo}." ;;
    401)
      echo "ERROR: GitHub token is invalid or expired (HTTP 401)."
      exit 1
      ;;
    404)
      echo "ERROR: Cannot access hananmalik21/${repo} (HTTP 404)."
      echo "Ensure the PAT has read access to all private Digify packages."
      exit 1
      ;;
    *)
      echo "ERROR: Unexpected GitHub API response HTTP ${http_code} for ${repo}."
      exit 1
      ;;
  esac
}

PRIVATE_REPOS=(
  digify_core
  grc_suite
  digify_enterprise_structure
  digify_security_console
)

for repo in "${PRIVATE_REPOS[@]}"; do
  check_repo_access "${repo}"
done

AUTH="https://oauth2:${GITHUB_TOKEN}@github.com/hananmalik21"

echo "Cloning private packages into _vendor/..."
rm -rf _vendor
mkdir -p _vendor

git clone --depth 1 --branch main "${AUTH}/digify_core.git" _vendor/digify_core
git clone --depth 1 --branch main "${AUTH}/grc_suite.git" _vendor/grc_suite
git clone --depth 1 --branch main "${AUTH}/digify_enterprise_structure.git" _vendor/digify_enterprise_structure
git clone --depth 1 --branch main "${AUTH}/digify_security_console.git" _vendor/digify_security_console

cat > pubspec_overrides.yaml <<'EOF'
# Generated on Render — do not commit.
dependency_overrides:
  digify_core:
    path: _vendor/digify_core
  digify_grc_suite:
    path: _vendor/grc_suite
  digify_enterprise_structure:
    path: _vendor/digify_enterprise_structure
  digify_security_console:
    path: _vendor/digify_security_console
EOF

FLUTTER_VERSION="3.44.4"
curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o flutter.tar.xz
tar xf flutter.tar.xz
export PATH="$PWD/flutter/bin:$PATH"

flutter --version
flutter config --enable-web

PUB_CACHE_DIR="${PUB_CACHE:-${HOME}/.pub-cache}"
rm -rf "${PUB_CACHE_DIR}/git" 2>/dev/null || true

flutter pub get
flutter build web --release
