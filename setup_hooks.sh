#!/usr/bin/env bash
# =============================================================================
# NYS · Pre-Commit Security Hook Setup
# Installs a git pre-commit hook that scans staged files for hardcoded secrets,
# API keys, and credential patterns before any commit reaches the index.
#
# Usage:
#   chmod +x setup_hooks.sh
#   ./setup_hooks.sh
#
# Optionally uses `git-secrets` if installed (brew install git-secrets).
# Falls back to a comprehensive inline regex validator if git-secrets is absent.
# =============================================================================

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
HOOKS_DIR="${REPO_ROOT}/.git/hooks"
HOOK_FILE="${HOOKS_DIR}/pre-commit"

echo ""
echo "  NYS - Pre-Commit Secret Scanner Setup"
echo "    Repository: ${REPO_ROOT}"
echo ""

# 1. Ensure hooks directory exists
mkdir -p "${HOOKS_DIR}"

# 2. Detect git-secrets (optional enhanced scanner)
if command -v git-secrets &>/dev/null; then
  echo "  git-secrets found. Configuring AWS + custom Nys patterns."
  git -C "${REPO_ROOT}" secrets --install --force 2>/dev/null || true
  git -C "${REPO_ROOT}" secrets --register-aws 2>/dev/null || true
  git -C "${REPO_ROOT}" secrets --add 'AIza[0-9A-Za-z_-]{35}'
  git -C "${REPO_ROOT}" secrets --add 'sk_live_[0-9a-zA-Z]{24,}'
  git -C "${REPO_ROOT}" secrets --add 'AKIA[0-9A-Z]{16}'
  git -C "${REPO_ROOT}" secrets --add --allowed 'EXAMPLE_API_KEY'
  git -C "${REPO_ROOT}" secrets --add --allowed 'YOUR_API_KEY_HERE'
  echo "  git-secrets configured. Hook installed at ${HOOK_FILE}."
  echo ""
  exit 0
fi

echo "  git-secrets not found. Installing inline regex pre-commit hook."
echo "    (Upgrade with: brew install git-secrets && ./setup_hooks.sh)"
echo ""

# 3. Write the inline regex pre-commit hook
cat > "${HOOK_FILE}" << 'HOOK_SCRIPT'
#!/usr/bin/env bash
# NYS Pre-Commit Secret Scanner

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo ""
echo "  Nys pre-commit secret scan running..."

# Files to always block regardless of content
BLOCKED_FILENAMES=("GoogleService-Info.plist" "google-services.json" "serviceAccountKey.json")

# Regex patterns that must not appear in staged content
REGEX_PATTERNS=(
  'AIza[0-9A-Za-z_-]{35}'
  '"type"[[:space:]]*:[[:space:]]*"service_account"'
  'sk_live_[0-9a-zA-Z]{24,}'
  'pk_live_[0-9a-zA-Z]{24,}'
  'AKIA[0-9A-Z]{16}'
  'Bearer [a-zA-Z0-9_.-]{40,}'
  '[Aa][Pp][Ii][_-]?[Kk][Ee][Yy][[:space:]]*[:=][[:space:]]*[A-Za-z0-9_-]{20,}'
)

# Literal strings to block (using fgrep / grep -F to avoid flag-parsing issues)
LITERAL_PATTERNS=(
  "BEGIN RSA PRIVATE KEY"
  "BEGIN PRIVATE KEY"
  "BEGIN EC PRIVATE KEY"
  "BEGIN OPENSSH PRIVATE KEY"
)

# Files excluded from content scanning (this script and its generated hook)
EXCLUDED_FROM_SCAN=("setup_hooks.sh" ".git/hooks/pre-commit")

FOUND_ISSUE=false

# --- Check staged filenames ---
echo "  Checking staged filenames..."
while IFS= read -r staged_file; do
  filename=$(basename "${staged_file}")
  for blocked in "${BLOCKED_FILENAMES[@]}"; do
    if [[ "${filename}" == "${blocked}" ]]; then
      echo -e "${RED}  BLOCKED: Credential file staged: ${staged_file}${NC}"
      FOUND_ISSUE=true
    fi
  done
done < <(git diff --cached --name-only --diff-filter=ACMR)

# --- Collect staged content, excluding scanner files ---
echo "  Scanning staged content for secrets..."
STAGED_DIFF=$(git diff --cached --unified=0 -- \
  ':!setup_hooks.sh' \
  ':!.git/hooks/pre-commit' \
  2>/dev/null | grep '^+' | grep -v '^+++' || true)

if [[ -n "${STAGED_DIFF}" ]]; then
  # Regex patterns
  for pattern in "${REGEX_PATTERNS[@]}"; do
    if echo "${STAGED_DIFF}" | grep -qE "${pattern}" 2>/dev/null; then
      echo -e "${RED}  SECRET DETECTED (regex): ${pattern}${NC}"
      echo -e "${YELLOW}    Locate with: git diff --cached | grep -E '${pattern}'${NC}"
      FOUND_ISSUE=true
    fi
  done

  # Literal patterns (safe for strings with hyphens/special chars)
  for pattern in "${LITERAL_PATTERNS[@]}"; do
    if echo "${STAGED_DIFF}" | grep -qF "${pattern}" 2>/dev/null; then
      echo -e "${RED}  SECRET DETECTED (literal): ${pattern}${NC}"
      echo -e "${YELLOW}    Locate with: git diff --cached | grep -F '${pattern}'${NC}"
      FOUND_ISSUE=true
    fi
  done
fi

# --- Result ---
if [[ "${FOUND_ISSUE}" == "true" ]]; then
  echo ""
  echo -e "${RED}COMMIT BLOCKED - Potential secrets detected.${NC}"
  echo -e "${RED}Remove the matched values and retry.${NC}"
  echo -e "${RED}Use Xcode build settings or environment variables instead.${NC}"
  echo ""
  exit 1
fi

echo -e "${GREEN}  No secrets detected. Proceeding with commit.${NC}"
echo ""
exit 0
HOOK_SCRIPT

chmod +x "${HOOK_FILE}"

echo "  Pre-commit hook installed at: ${HOOK_FILE}"
echo ""
echo "  The hook scans staged files for:"
echo "  - Firebase / GCP API key patterns"
echo "  - PEM private key blocks"
echo "  - Stripe live key prefixes"
echo "  - AWS access key IDs"
echo "  - Blocked filenames (GoogleService-Info.plist, etc.)"
echo ""
echo "  Emergency bypass (not recommended): git commit --no-verify"
echo "  Upgrade: brew install git-secrets && ./setup_hooks.sh"
echo ""
