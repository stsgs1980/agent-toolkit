#!/usr/bin/env bash
# =============================================================================
# Agent Toolkit Bootstrap Script
# =============================================================================
# Self-contained installer: creates ALL agent-toolkit files from heredocs.
# Run from any directory: bash setup.sh
# Creates files in CURRENT directory (./)
# =============================================================================

set -e

echo "========================================="
echo "  Agent Toolkit Bootstrap Installer"
echo "========================================="
echo ""

# --- Create directory structure ---
mkdir -p instructions
mkdir -p skills/git-safe-ops
mkdir -p skills/dev-watchdog

echo "[1/11] Creating instructions/onboarding-protocol.md..."
cat > instructions/onboarding-protocol.md << 'EOF1'
# Onboarding Protocol

## Instruction for AI Agent Behavior

---

## Rule: Always Onboard Before Acting

When entering an existing project (new chat, session restart, context loss),
the agent MUST complete ALL onboarding steps before starting any work.

Failure to onboard = acting blind = high risk of breaking existing code.

---

## Onboarding Steps (execute in order)

### Step 1: Read Agent Rules

```
Read AGENT_RULES.md in project root.
```

This file contains mandatory behavioral rules, git workflow rules,
and references to all other instructions and skills.

If AGENT_RULES.md does not exist -> skip to Step 2 and notify user.

### Step 2: Read Worklog

```
Read worklog.md in project root.
```

Contains history of all previous work sessions:
- What was done
- What decisions were made
- What problems occurred
- Current state of the project

If worklog.md does not exist -> note "no worklog found" and ask user for context.

### Step 3: Check Git State

```
git log --oneline -10
git status
git branch -a
```

Record:
- Latest commit hash and message
- Current branch
- Uncommitted changes (dirty files)
- Remote URL and status

### Step 4: Verify Dev Server

```
curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:3000
```

| Response | Action |
|----------|--------|
| 200 | Server running, note it |
| 000 | Server down, restart with dev-watchdog skill |
| 500 | Server error, check logs, fix issue |

### Step 5: Scan Project Structure

```
ls -la instructions/
ls -la skills/
ls src/app/
```

Identify:
- Available instructions (behavioral rules)
- Available skills (automated tools)
- Project entry point and routes

### Step 6: Report to User

After completing Steps 1-5, report to the user in their language:

```
Project: [name from README]
Branch: [branch] | Last commit: [hash] [message]
Server: [running/down] on port 3000
Worklog: [X sessions recorded, last dated Y]
Instructions: [list available]
Skills: [list available]
Uncommitted changes: [yes/no - list files]

Ready. What would you like to work on?
```

---

## Forbidden Actions During Onboarding

| Action | Why Forbidden |
|--------|---------------|
| Start coding immediately | You don't know what exists |
| Delete or modify files | You don't know git state |
| Run git push/pull | You don't know branch state |
| Install new packages | You don't know dependencies |
| Assume project state | worklog may contradict assumptions |

---

## Partial Onboarding

If the user explicitly says "skip onboarding" or "just fix X quickly":
- Still run Step 1 (AGENT_RULES.md) and Step 3 (git state) -- these are NON-SKIPPABLE
- Skip Steps 2, 4, 5, 6 only with user confirmation
- Note in worklog: "Partial onboarding per user request"

---

## Onboarding After Context Window Exhaustion

When a conversation is continued from a summary:
- The summary replaces worklog context -- treat it as onboarding data
- Still verify actual git state (summary may be outdated)
- Run Steps 3 and 4 at minimum

---

## Example: Correct Onboarding

```
[Agent reads AGENT_RULES.md]
[Agent reads worklog.md - 3 sessions, last update 2026-04-17]
[Agent checks git: commit ee0baba, main branch, clean]
[Agent checks server: 200 OK]
[Agent scans: instructions/ (3 files), skills/ (2 dirs)]
[Agent reports to user in Russian]
```

## Example: Incorrect Onboarding

```
[Agent starts coding immediately without reading anything]
[Agent deletes file that was added in previous session]
[Agent force pushes without checking current branch]
```

---

Built with: Next.js 16 + TypeScript + Tailwind CSS
EOF1

echo "[2/11] Creating instructions/git-workflow-rules.md..."
cat > instructions/git-workflow-rules.md << 'EOF2'
# Git Workflow Rules

## Instruction for AI Agent Behavior

These rules govern how the agent handles git operations in sandboxed environments.
They exist because git history-rewriting operations (rebase, merge) can block the
entire environment if a conflict occurs, making it impossible to recover.

---

## Rule 1: Backup Before Rewrite

**Before** any git operation that rewrites history (rebase, merge, pull, reset --hard),
create a backup:

1. `git stash push -m "pre-op-backup"`
2. Copy critical source files to `/tmp/` (e.g., `cp -r src/ /tmp/src-backup/`)
3. Save git log: `git log --oneline -20 > /tmp/git-log-backup.txt`

**Why:** If the operation fails and locks the environment, you have a fallback.
Without a backup, code can be permanently lost when the session resets.

## Rule 2: Force Push Over Rebase

When `git push` is rejected because "the remote contains work that you do not have
locally" (diverged branches):

- **DO** use `git push --force origin main` if local commits are authoritative
- **DO NOT** use `git pull --rebase` or `git pull` to synchronize first

**Why:** Rebase in a sandbox creates a catch-22: if a conflict occurs, all tools
(Bash, Read, Write, LS) are blocked by a pre-execution hook. You cannot resolve
the conflict because you cannot run any command. Force push avoids this entirely.

## Rule 3: Never Pull After Remote URL Change

After `git remote set-url origin <new-url>`:

- **DO** immediately `git push --force origin main`
- **DO NOT** run `git pull` or `git fetch + merge`

**Why:** The new remote may have a different commit history. Pulling creates an
unnecessary merge conflict with no benefit since local state is already correct.

## Rule 4: No Panic Diagnostics

If something goes wrong with git:

1. First check: do source files still exist? (`ls src/app/`)
2. Then check: `.git/rebase-merge/` directory (rebase may be paused, not lost)
3. Then check: `git reflog` (commits are still referenced)
4. Then check: `/tmp/` backups
5. Then check: `git fsck --lost-found` (find dangling objects)

**DO NOT** tell the user "code is permanently lost" until ALL 5 checks are done.
**DO NOT** assume session reset = data loss. The sandbox often preserves files.

## Rule 5: Log Everything

After every git operation:

1. Log to `/home/z/my-project/worklog.md`: operation performed, hash before/after, result
2. Log any errors encountered
3. Log recovery steps taken

**Why:** If something goes wrong later, the log provides a trail for diagnosis.

---

## Summary Table

| Situation | Correct Action | Wrong Action |
|-----------|---------------|--------------|
| Push rejected (diverged) | `git push --force` | `git pull --rebase` |
| Changed remote URL | `git push --force` | `git pull` |
| Before any rebase/merge | Backup files first | Operate without backup |
| Environment blocked by conflict | Force unlock from /tmp | Try `git rebase --continue` |
| Unsure if code is lost | Check 5 diagnostic paths | Tell user "permanently lost" |
EOF2

echo "[3/11] Creating instructions/language-rule.md..."
cat > instructions/language-rule.md << 'EOF3'
# Language Rule

## Instruction for AI Agent Behavior

---

## Rule: Always Match the User's Language

1. **Detect** the language of the user's message
2. **Respond** in the same language
3. **Never switch** languages without explicit user request

### Detection

- If the user writes in Russian (Cyrillic characters) -> respond in Russian
- If the user writes in English (Latin characters) -> respond in English
- If the user writes in a mix -> respond in the language of the majority of their message
- If ambiguous -> ask: "Na kakom yazyke vam udobnee prodolzhit?" / "Which language do you prefer?"

### What This Applies To

- All chat messages to the user
- Explanations of code, errors, and decisions
- Commit messages (use English for commits, this is universal convention)
- Worklog entries (use the project's working language)
- Comments in code (use English for code comments, this is universal convention)

### What This Does NOT Apply To

- Code itself (variable names, function names, etc.) - always English
- File paths - always ASCII
- Terminal commands - always English
- Git commit messages - always English (universal convention)

### Common Mistakes to Avoid

- User writes in Russian, you respond in English -> WRONG
- User writes in Russian, you start in Russian then switch to English mid-response -> WRONG
- User asks "why did you switch to English?" -> immediately switch back to their language and apologize

### Enforcement

At the start of each response, verify: "Am I writing in the same language as the user's last message?"

If you catch yourself writing in the wrong language, stop and rewrite in the correct language before sending.
EOF3

echo "[4/11] Creating instructions/diagnostic-disclosure.md..."
cat > instructions/diagnostic-disclosure.md << 'EOF4'
# Diagnostic Disclosure Rule

## Instruction for AI Agent Behavior

---

## Rule: Never Assert Data Loss Without Exhaustive Verification

When something goes wrong (git conflict, session reset, file deletion, build failure),
the agent must verify the actual state before informing the user.

---

## Verification Checklist

Before telling the user that data is lost, corrupted, or unrecoverable,
check ALL of the following in order:

### Step 1: Direct File Check
```bash
ls <expected-file-path>
wc -l <expected-file-path>
```
Does the file exist? Is it non-empty?

### Step 2: Git State Check
```bash
git status
git log --oneline -10
```
Are the expected commits in history? Is the working tree clean?

### Step 3: Git Recovery Paths
```bash
git reflog                          # All HEAD movements
git fsck --lost-found               # Dangling commits/blobs
ls .git/rebase-merge/               # Paused rebase (commits preserved)
ls .git/rebase-apply/               # Paused apply
```
Are there lost commits that can be recovered?

### Step 4: Backup Locations
```bash
ls /tmp/src-backup-*/               # Manual backups from git-safe-ops
ls /tmp/git-log-backup-*.txt        # Git log snapshots
```
Were backups created before the operation?

### Step 5: Session State
```bash
# Is this the same session or a new one?
# Same session = files likely preserved
# New session = sandbox may have reset
```

---

## Communication Rules

### DO:

- Say "I cannot determine the current state" if checks are blocked
- Say "Let me verify before concluding" when uncertain
- Present findings as facts: "File X exists, Y lines. Commit Z is in history."
- Give the user hope: "There are 3 recovery paths remaining"
- Ask the user to help if you're truly stuck: "Can you check if..."

### DO NOT:

- Say "code is permanently lost" without completing all 5 verification steps
- Say "there is nothing we can do" without trying every recovery method
- Assume session reset = data loss (sandbox often preserves files)
- Skip verification steps because you're "sure" about the outcome
- Use definitive language about loss when you have incomplete information

### Severity Ladder

When communicating problems, use appropriate severity:

| Certainty | Phrase |
|-----------|--------|
| File definitely exists | "File X is present, Y lines" |
| File not found at expected path | "File X not found at expected path, checking alternatives..." |
| All checks exhausted, file not found | "File X was not found after exhaustive search. Recovery options: A, B, C" |
| All recovery options failed | "File X could not be recovered. The last known state was [description]. You may need to recreate it." |

Never jump to the last row without passing through all previous rows.

---

## Real Example of Violation

**Wrong:**
> "Your code is permanently lost. The sandbox reset deleted all files."

**Right:**
> "I cannot see the .tsx files right now. Let me verify:
> 1. Checking /home/z/my-project/src/app/...
> 2. Checking git history...
> 3. Checking git reflog...
> 4. Checking /tmp/ backups...
> After checking all 4 paths, the files were not found.
> However, if this is the same session, the .git/rebase-merge/ directory
> may still contain the commits. Can you try starting from the same session?"

The second approach is honest, transparent, and gives the user actionable options.
EOF4

echo "[5/11] Creating instructions/writing-plans.md..."
cat > instructions/writing-plans.md << 'EOF5'
# Writing Plans

## Instruction for AI Agent Behavior

---

## Rule: Plan Before You Code

For any task that requires more than 3 steps, write a plan BEFORE writing code.

The plan must be written into `worklog.md` as a structured checklist.
This forces clear thinking, prevents rework, and creates a traceable record.

---

## When to Plan

| Task Size | Action |
|-----------|--------|
| 1-3 steps (fix a typo, change a color) | Just do it, log after |
| 4-10 steps (add a component, refactor a module) | Write a brief plan in worklog |
| 10+ steps (new feature, multi-file change) | Write a detailed plan, show user before starting |

## When NOT to Plan

- User explicitly says "just do it" or "skip planning"
- The fix is obvious and trivial (1-2 lines)
- Cron/watchdog tasks (server restart, health check)
- Onboarding steps (these follow a fixed protocol)

---

## Plan Format

Write the plan at the top of your work session in `worklog.md`:

```
---
Task ID: <id>
Agent: <agent name>
Task: <description>

Plan:
1. [step description]
2. [step description]
3. [step description]

Work Log:
- [actual work done, step by step]

Stage Summary:
- [results]
```

### Plan Checklist

A good plan answers:

- [ ] What files will be created or modified?
- [ ] What is the order of operations?
- [ ] Are there dependencies between steps?
- [ ] What could go wrong and how to handle it?
- [ ] Is there a rollback strategy?

---

## Plan Review

For tasks with 10+ steps, present the plan to the user before starting:

```
Plan for: [task name]
1. ...
2. ...
3. ...

Should I proceed?
```

Wait for user confirmation before executing. This prevents wasted effort
when the user's intent differs from your interpretation.

For tasks with 4-9 steps, write the plan in worklog and start executing.
No need to ask for confirmation unless you are unsure about the approach.

---

## Common Mistakes

| Mistake | Why It's Bad | Fix |
|---------|-------------|-----|
| Start coding immediately on a complex task | You discover dependencies mid-way and have to restructure | Write 5-line plan first |
| Write a 50-line plan for a simple task | Wastes context window and time | Scale plan to task complexity |
| Plan but don't record it in worklog | Next session has no idea what was planned | Always write plans in worklog |
| Ignore the plan after writing it | Plan becomes useless decoration | Follow the plan step by step |
| Never revise the plan | New information may invalidate the plan | Update plan in worklog when reality changes |

---

## Relationship to Workflows

This instruction complements the workflow templates:

| Workflow | Planning Stage |
|----------|---------------|
| feature-development | Brainstorm + Plan phases (mandatory) |
| bug-fix | Diagnose phase (identify fix before coding) |
| refactor | Analyze + Plan phases (mandatory) |

When using a workflow template, its planning phase takes precedence.
This instruction applies to tasks that don't use a specific workflow.

---

Built with: Next.js 16 + TypeScript + Tailwind CSS
EOF5

echo "[6/11] Creating skills/git-safe-ops/SKILL.md..."
cat > skills/git-safe-ops/SKILL.md << 'EOF6'
---
name: git-safe-ops
description: >
  Safe git operations with automatic backups and conflict recovery.
  CRITICAL: Use this skill BEFORE any git rebase, merge, pull, or reset operation
  that involves a remote repository. Also use when the environment is blocked
  by a git merge/rebase conflict. This skill prevents data loss from failed
  rebases, merge conflicts, and environment lockups. Always invoke when:
  (1) git push is rejected due to diverged branches,
  (2) you need to sync with a remote,
  (3) the environment is completely blocked by a git conflict,
  (4) you need to update a remote URL or PAT.
---

# Git Safe Operations

## Purpose

Git operations that rewrite history (rebase, merge, pull with diverged branches)
can block the entire sandbox environment if a conflict occurs. This skill provides
a safe protocol that prevents environment lockups and data loss.

## CRITICAL RULE: Backup Before ANY Remote Operation

Before executing any git operation that interacts with a remote or rewrites history,
create a backup:

```
1. git stash push -m "pre-op-backup-<timestamp>"
2. cp -r src/ /tmp/src-backup-<timestamp>/
3. git log --oneline -20 > /tmp/git-log-backup-<timestamp>.txt
```

Only THEN proceed with the git operation.

## Decision Tree

### When `git push` is rejected (diverged branches):

**Preferred path:** Use `git push --force` if local commits are authoritative.

```
1. Backup (see above)
2. git push --force origin main
```

**DO NOT** run `git pull --rebase` or `git pull` to "fix" divergence.
Rebase is risky in sandboxed environments because conflicts lock ALL tools.

### When you need to sync with remote (remote has commits you want):

```
1. Backup (see above)
2. git fetch origin
3. git log --oneline origin/main..HEAD  (check what local has)
4. git log --oneline HEAD..origin/main  (check what remote has)
5. Decide: force push (if local is authoritative) OR merge (if remote has needed changes)
6. If merging: git merge origin/main --no-edit
7. If conflict: use "Conflict Recovery" below
```

### When updating remote URL or PAT:

```
1. git remote set-url origin <new-url>
2. git remote -v  (verify)
3. git push --force origin main  (do NOT pull first)
```

NEVER pull after changing remote URL. You already have the local state you need.

## Conflict Recovery (Environment Blocked)

If the environment is blocked (all commands return "you need to resolve your current index first"):

### Step 1: Force unlock (attempt each with 5 second timeout)

```bash
# Attempt A: Remove merge state files
rm -f .git/MERGE_HEAD .git/MERGE_MSG .git/MERGE_RR .git/index.lock
rm -rf .git/rebase-merge .git/rebase-apply
git reset --merge

# If A fails, Attempt B: Replace index
cp .git/HEAD .git/index.bak 2>/dev/null
git read-tree HEAD
git checkout-index -a
git reset --hard HEAD

# If B fails, Attempt C: Nuclear option (data is in /tmp/ backup)
rm -rf .git/rebase-merge .git/rebase-apply
git reset --hard HEAD
```

### Step 2: Restore from backup if reset lost data

```bash
# Check if source files still exist
ls src/app/page.tsx

# If missing, restore from backup
cp -r /tmp/src-backup-<timestamp>/ src/
```

### Step 3: Verify state

```bash
git status
git log --oneline -5
# Confirm files exist: ls src/app/
```

## NEVER DO These Things

1. `git pull --rebase` without a backup - this is the #1 cause of environment lockups
2. `git rebase --continue` when environment is already blocked by a conflict
3. Attempting `git checkout`, `git add`, `git merge` when all commands are blocked
4. Telling the user their code is "permanently lost" without checking:
   - `/tmp/src-backup-*/`
   - `.git/rebase-merge/`
   - `git reflog`
   - `git fsck --lost-found`
5. Running `git pull` after `git remote set-url` (creates unnecessary conflicts)

## Workflow Checklist

Before ANY git operation involving remote:
- [ ] Backup created (stash + file copy + log)
- [ ] Remote URL verified
- [ ] Operation chosen (force push preferred for diverged branches)
- [ ] After operation: git status verified
- [ ] After operation: source files verified (ls src/app/)
- [ ] Worklog.md updated with operation details
EOF6

echo "[7/11] Creating skills/dev-watchdog/SKILL.md..."
cat > skills/dev-watchdog/SKILL.md << 'EOF7'
---
name: dev-watchdog
description: >
  Dev server keepalive and health monitoring for Next.js projects in sandboxed environments.
  Use this skill when: (1) the dev server needs to be started or restarted,
  (2) the user reports 502 Bad Gateway or connection refused errors,
  (3) a cron/watchdog task asks to restart the server,
  (4) you need to verify the dev server is running after code changes.
  Also proactively use this at the start of any session to ensure the server is alive.
---

# Dev Server Watchdog

## Purpose

In sandboxed environments, the Next.js dev server (`next dev`) tends to terminate
after approximately 5 minutes of running. This skill provides a reliable protocol
for starting, monitoring, and restarting the dev server.

## Server Start Protocol

### Standard Start

```bash
# Kill any existing process first
pkill -f 'next dev' 2>/dev/null
sleep 1

# Start server (npx, not bun - bun has shown instability)
cd /home/z/my-project && npx next dev -p 3000 </dev/null >/tmp/zdev.log 2>&1 &

# Wait for compilation
sleep 6

# Verify
curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:3000/
# Expected: 200
```

### Important Notes

- Always use `127.0.0.1` not `localhost` for curl (IPv6 resolution issues in sandbox)
- Always redirect stdout/stderr to `/tmp/zdev.log` (prevents process death from output buffer)
- Always use `</dev/null` to close stdin (prevents process hanging on input)
- Use `npx next dev` directly, NOT `bun run dev` (bun wrapper adds instability)
- Wait at least 6 seconds after start before health check (Turbopack compilation time)

## Health Check Protocol

```bash
# Quick check
curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:3000/
# 200 = alive, 000 = dead, 5xx = error

# If dead: check logs before restarting
tail -20 /tmp/zdev.log
```

### When Server Returns 000 (Connection Refused)

This means the process has died. Restart using Standard Start protocol.

### When Server Returns 500

This usually means a compilation error. Check the log:

```bash
tail -30 /tmp/zdev.log
```

Do NOT blindly restart. Fix the compilation error first, then restart.

## Cron Watchdog Task

For automated keepalive, a cron task should run every 5 minutes:

```
Job: Restart dev server if dead
Schedule: every 5 minutes
Command: Check health, restart if 000
```

The cron task handler should:

1. Check if server is alive (`curl` to `127.0.0.1:3000`)
2. If alive (200): do nothing
3. If dead (000): restart using Standard Start protocol
4. Log the restart event

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| 000 after start | Process died immediately | Check `/tmp/zdev.log` for errors |
| 200 on first request, 000 later | Process timeout | This is expected in sandbox; cron watchdog handles it |
| 500 | Compilation error in code | Fix the error, then restart |
| Port 3000 already in use | Previous process not killed | `pkill -f 'next dev'` then restart |
| Slow first response (>10s) | Turbopack cold compile | Normal; wait up to 15 seconds |

## File Locations

| File | Purpose |
|------|---------|
| `/tmp/zdev.log` | Server stdout/stderr |
| `/home/z/my-project/dev.log` | Alternate log (bun creates this) |
| Port 3000 | Standard dev server port (mandatory, per project config) |
EOF7

echo "[8/11] Creating AGENT_RULES.md..."
cat > AGENT_RULES.md << 'EOFAGENT'
# Agent Rules

Mandatory rules for AI agents working on this project. Read before starting work.

---

## 0. Onboarding Protocol

When entering this project (new chat, session restart, context loss),
you MUST complete the onboarding protocol before starting any work:

1. Read `AGENT_RULES.md` (this file)
2. Read `worklog.md` (previous session history)
3. Check git state: `git log --oneline -10` and `git status`
4. Verify dev server: `curl http://127.0.0.1:3000`
5. Scan project structure: `instructions/`, `skills/`, `src/app/`
6. Report current state to user

See `instructions/onboarding-protocol.md` for full details.
NEVER start coding or modifying files before completing Steps 1-3.

## 1. Language Rule

Always respond in the user's language. If the user writes in Russian, respond in Russian. If in English, respond in English. Never switch languages without explicit request.

- Code, file paths, terminal commands, git commit messages - always English
- Chat messages, explanations, worklog - match user's language
- Before each response verify: "Am I writing in the same language as the user?"

## 2. Git Workflow Rules

### 2.1 Backup Before Rewrite

Before any git operation that rewrites history (rebase, merge, pull, reset --hard):

1. `git stash push -m "pre-op-backup"`
2. `cp -r src/ /tmp/src-backup/`
3. `git log --oneline -20 > /tmp/git-log-backup.txt`

### 2.2 Force Push Over Rebase

When `git push` is rejected (diverged branches):

- `git push --force origin main` - CORRECT
- `git pull --rebase` - FORBIDDEN (blocks sandbox environment on conflict)

### 2.3 Never Pull After Remote URL Change

After `git remote set-url origin <url>`:

- `git push --force origin main` - CORRECT
- `git pull` - FORBIDDEN (creates unnecessary conflicts)

### 2.4 No Panic Diagnostics

Before telling the user data is lost, check ALL 5 paths:

1. `ls src/app/` - do files exist?
2. `ls .git/rebase-merge/` - is rebase paused?
3. `git reflog` - are commits referenced?
4. `ls /tmp/src-backup-*/` - were backups created?
5. `git fsck --lost-found` - dangling objects?

NEVER say "permanently lost" until all 5 checks are exhausted.

### 2.5 Log Everything

After every git operation, log to `worklog.md`: operation, hash before/after, result.

## 3. Dev Server Rules

- Use `npx next dev -p 3000` directly (NOT `bun run dev`)
- Use `127.0.0.1` not `localhost` for curl
- Redirect output: `</dev/null >/tmp/zdev.log 2>&1 &`
- Wait 6 seconds before health check (Turbopack compile time)
- If server returns 500: check logs, fix error, then restart (don't blindly restart)

## 4. Code Standards

- No-Unicode Policy v2.1 [C] - zero non-Cyrillic non-ASCII in UI code, AI-chat [W]
- MARKDOWN_STANDARD v2.1 [W] - ASCII + Cyrillic + typographics in .md text, forbidden in headings/code
- REPRODUCIBILITY-STANDARD - `.env.example` required, relative paths only
- Use shadcn/ui components, do not build from scratch
- TypeScript throughout with strict typing

## 5. Diagnostic Disclosure

Severity ladder for communicating problems:

| Certainty | Phrase |
|-----------|--------|
| File exists | "File X is present, Y lines" |
| Not found | "File X not found, checking alternatives..." |
| All checks exhausted | "File X not found after exhaustive search. Options: A, B, C" |
| All recovery failed | "File X could not be recovered. You may need to recreate it." |

Never jump to the last row without passing through all previous rows.

## 6. Planning Rule

For tasks that require more than 3 steps, write a plan in `worklog.md` BEFORE writing code.

- Tasks 1-3 steps: just do it, log after
- Tasks 4-10 steps: write a brief plan in worklog, then execute
- Tasks 10+ steps: write a detailed plan, show user for confirmation before starting

See `instructions/writing-plans.md` for full details.

## 7. Skills to Use

| Skill | When to Use |
|-------|-------------|
| `git-safe-ops` | Before any git push/pull/rebase/merge with remote |
| `dev-watchdog` | Starting, restarting, or checking dev server |

## 8. Worklog System

| File | Purpose |
|------|---------|
| `README_WORKLOG.md` | Full guide: how worklog works, sub-agent instructions |
| `TASK_TEMPLATE.md` | Prompt templates for full-stack-developer, Explore, general-purpose |
| `worklog.md` | Journal of all work sessions |

## 9. Implementation Order

Standards must be applied in sequence (each depends on the previous):

1. Accept standards (No-Unicode, MARKDOWN_STANDARD, README_TEMPLATE)
2. Deploy worklog system (README_WORKLOG, TASK_TEMPLATE, WORKLOG.md)
3. REPRODUCIBILITY (env, db, paths)
4. No-Unicode Policy [C] (ESLint rule + UI code cleanup)
5. MARKDOWN_STANDARD [W] (.md files cleanup, including worklog files)
6. README_TEMPLATE (assemble README by template)

See `standards/ПОРЯДОК_внедрения_стандартов.md` for full details.

## 10. Instructions to Follow

| Instruction | File |
|-------------|------|
| Onboarding Protocol | `instructions/onboarding-protocol.md` |
| Git Workflow Rules | `instructions/git-workflow-rules.md` |
| Language Rule | `instructions/language-rule.md` |
| Diagnostic Disclosure | `instructions/diagnostic-disclosure.md` |
| Writing Plans | `instructions/writing-plans.md` |

---

Built with: Next.js 16 + TypeScript + Tailwind CSS
EOFAGENT

echo "[9/11] Creating worklog.md..."
cat > worklog.md << 'EOFWL'
# Project Worklog

> Unified journal of all agent work.
> Path: /home/z/my-project/worklog.md

---

## Task ID System

| Pattern | Example | Usage |
|---------|---------|-------|
| N | 1, 2, 3 | Sequential tasks |
| N-x | 2-a, 2-b | Parallel tasks |
| N-x-y | 2-a-1 | Nested subtasks |

---

## Rules

1. Read this file BEFORE work
2. Add entry AFTER work
3. NEVER overwrite - append only!

---

## Work History

---
Built with: Next.js 16 + TypeScript + Tailwind CSS
EOFWL

echo "[10/11] Creating README_WORKLOG.md..."
cat > README_WORKLOG.md << 'EOFRWL'
# Worklog System

Single-file work journal shared by all agents.

---

## Files

| File | Purpose |
|------|---------|
| `worklog.md` | Shared journal of all work sessions |
| `README_WORKLOG.md` | This guide |
| `TASK_TEMPLATE.md` | Prompt templates for sub-agents |

---

## Who Knows About Worklog

```text
Super Z (orchestrator)   --> KNOWS worklog
  |
  +-- full-stack-developer --> DOES NOT know
  +-- Explore               --> DOES NOT know
  +-- general-purpose       --> DOES NOT know
```

---

## Checklist Before Calling Sub-Agent

- [ ] Read current `worklog.md`
- [ ] Identify context the sub-agent needs
- [ ] Add WORKLOG section from TASK_TEMPLATE.md
- [ ] Assign unique Task ID
- [ ] Inject relevant past decisions
- [ ] After return, append results to `worklog.md`
EOFRWL

echo "[11/11] Creating TASK_TEMPLATE.md..."
cat > TASK_TEMPLATE.md << 'EOFTASK'
# Task Prompt Templates

Prompt templates for spawning sub-agents. Copy the relevant template,
fill in placeholders, and use as the sub-agent prompt.

---

## full-stack-developer

You are a full-stack developer on a Next.js 16 + TypeScript + Tailwind CSS project.

### WORKLOG

Task ID: <N>
Task: <description>

Context from previous sessions:
- <paste relevant worklog entries here>

### Your Task

<describe the task here>

After completing your work, report what you did so it can be added to the worklog.

---

## Explore

You are an exploration agent on a Next.js 16 + TypeScript + Tailwind CSS project.

### WORKLOG

Task ID: <N>
Task: <description>

Context from previous sessions:
- <paste relevant worklog entries here>

### Your Task

<describe what to investigate here>

Report your findings so they can be added to the worklog.

---

## general-purpose

You are a general-purpose agent on a Next.js 16 + TypeScript + Tailwind CSS project.

### WORKLOG

Task ID: <N>
Task: <description>

Context from previous sessions:
- <paste relevant worklog entries here>

### Your Task

<describe the task here>

After completing your work, report what you did so it can be added to the worklog.
EOFTASK

echo ""
echo "========================================="
echo "  SUCCESS!"
echo "========================================="
echo ""
echo "Created 11 files"
echo ""
echo "  instructions/"
echo "    onboarding-protocol.md"
echo "    git-workflow-rules.md"
echo "    language-rule.md"
echo "    diagnostic-disclosure.md"
echo "    writing-plans.md"
echo "  skills/"
echo "    git-safe-ops/SKILL.md"
echo "    dev-watchdog/SKILL.md"
echo "  AGENT_RULES.md"
echo "  worklog.md"
echo "  README_WORKLOG.md"
echo "  TASK_TEMPLATE.md"
echo ""
echo "========================================="
