#!/bin/bash
# Agent Toolkit Setup Script
# Run this script to set up agent-toolkit in any Next.js project.
# Usage: bash <(curl -L URL) or copy-paste and run locally.

set -e

# === Configuration ===
GITHUB_USER="Sts8987"
REPO="agent-toolkit"
TMP_DIR="/tmp/agent-toolkit-setup"

# === Functions ===
info()  { echo "[INFO]  $1"; }
ok()    { echo "[OK]    $1"; }
fail()  { echo "[FAIL]  $1"; exit 1; }

# === Check prerequisites ===
command -v git >/dev/null 2>&1 || fail "git is not installed"
command -v curl >/dev/null 2>&1 || fail "curl is not installed"

# === Determine auth method ===
if [ -n "$1" ] && echo "$1" | grep -q "^ghp_"; then
  AUTH="$1"
  AUTH_TYPE="PAT"
else
  AUTH=""
  AUTH_TYPE="public"
fi

# === Clone toolkit ===
info "Cloning agent-toolkit ($AUTH_TYPE)..."
rm -rf "$TMP_DIR"

if [ -n "$AUTH" ]; then
  git clone "https://${AUTH}@github.com/${GITHUB_USER}/${REPO}.git" "$TMP_DIR" 2>/dev/null || {
    # If PAT clone fails, try public
    info "PAT clone failed, trying public..."
    git clone "https://github.com/${GITHUB_USER}/${REPO}.git" "$TMP_DIR" 2>/dev/null || {
      fail "Cannot clone. Use: bash setup.sh ghp_YOUR_PAT_HERE"
    }
  }
else
  git clone "https://github.com/${GITHUB_USER}/${REPO}.git" "$TMP_DIR" 2>/dev/null || {
    info "Public clone failed. GitHub may require PAT."
    info "Try: bash setup.sh ghp_YOUR_PAT_HERE"
    fail "Clone failed. Provide PAT as argument."
  }
fi

ok "Cloned to $TMP_DIR"

# === Verify clone ===
[ -d "$TMP_DIR/skills" ] || fail "Invalid clone: skills/ not found"
[ -d "$TMP_DIR/instructions" ] || fail "Invalid clone: instructions/ not found"
[ -f "$TMP_DIR/templates/AGENT_RULES.md" ] || fail "Invalid clone: AGENT_RULES.md not found"

# === Copy files ===
info "Copying skills..."
cp -r "$TMP_DIR/skills/" ./skills/

info "Copying instructions..."
cp -r "$TMP_DIR/instructions/" ./instructions/

info "Copying templates..."
[ -f "AGENT_RULES.md" ] && info "AGENT_RULES.md exists, backing up..." && cp AGENT_RULES.md AGENT_RULES.md.bak
cp "$TMP_DIR/templates/AGENT_RULES.md" ./AGENT_RULES.md

[ -f "worklog.md" ] || cp "$TMP_DIR/templates/worklog.md" ./worklog.md

# === Optional: copy standards ===
info "Copying standards..."
mkdir -p upload
cp "$TMP_DIR/standards/"*.md ./upload/ 2>/dev/null || true

# === Optional: copy workflows ===
info "Copying workflows..."
mkdir -p instructions
cp "$TMP_DIR/templates/workflows/"*.md ./instructions/ 2>/dev/null || true

# === Cleanup ===
rm -rf "$TMP_DIR"

# === Verify ===
info "Verifying installation..."
FILES_OK=true
for f in AGENT_RULES.md instructions/ skills/; do
  if [ -e "$f" ]; then
    ok "$f"
  else
    fail "$f"
    FILES_OK=false
  fi
done

[ -f "worklog.md" ] && ok "worklog.md"

# === Done ===
echo ""
echo "==============================="
echo "  Agent Toolkit installed!"
echo "==============================="
echo ""
echo "Installed:"
echo "  - skills/ (git-safe-ops, dev-watchdog)"
echo "  - instructions/ (4 rules)"
echo "  - AGENT_RULES.md"
echo "  - worklog.md"
echo ""
echo "Next steps:"
echo "  1. Add 'Agent Rules' section to README.md"
echo "  2. git add -A && git commit -m 'setup: add agent toolkit'"
echo "  3. On next chat, agent will auto-onboard"
echo ""
