# Agent Toolkit

Unified toolkit for AI agent behavior rules, skills, and project standards.
Copy into any Next.js project to ensure consistent agent behavior across sessions.

## Structure

```
agent-toolkit/
  skills/                          - Automated tools for agent
    git-safe-ops/SKILL.md          - Safe git operations (backup, force push)
    dev-watchdog/SKILL.md          - Dev server lifecycle management
  instructions/                    - Behavioral rules for agent
    onboarding-protocol.md         - How to enter existing project
    git-workflow-rules.md          - Git operation rules
    language-rule.md               - Language matching rule
    diagnostic-disclosure.md       - Data loss disclosure protocol
  standards/                       - Code and documentation standards
    README_TEMPLATE.md             - Mandatory README structure
    MARKDOWN_STANDARD_RU_v2.0.md   - Markdown formatting rules
    No-Unicode_Policy_v2.0.md      - Unicode restrictions
    REPRODUCIBILITY-STANDARD.md    - Build reproducibility rules
  templates/                       - Files to copy into new projects
    AGENT_RULES.md                 - Master rules file (copy and adapt)
```

## Quick Start

### Option A: Copy-Paste Commands (recommended)

Run these commands from your project root:

```bash
# 1. Clone toolkit to temp folder
git clone https://github.com/Sts8987/agent-toolkit.git /tmp/agent-toolkit

# 2. Copy skills and instructions into project
cp -r /tmp/agent-toolkit/skills/ ./skills/
cp -r /tmp/agent-toolkit/instructions/ ./instructions/

# 3. Copy template files to project root
cp /tmp/agent-toolkit/templates/AGENT_RULES.md ./AGENT_RULES.md
cp /tmp/agent-toolkit/templates/worklog.md ./worklog.md

# 4. Copy standards (optional, for reference)
mkdir -p upload
cp /tmp/agent-toolkit/standards/* ./upload/

# 5. Clean up
rm -rf /tmp/agent-toolkit
```

### Option B: Copy Entire Folder

```bash
# Copy everything at once
git clone https://github.com/Sts8987/agent-toolkit.git
cp -r agent-toolkit/skills/ ./skills/
cp -r agent-toolkit/instructions/ ./instructions/
cp agent-toolkit/templates/AGENT_RULES.md ./
cp agent-toolkit/templates/worklog.md ./
rm -rf agent-toolkit
```

### After Setup

1. Verify files exist: `ls AGENT_RULES.md instructions/ skills/ worklog.md`
2. Add "Agent Rules (Mandatory)" section to your README.md (see template below)
3. Commit everything: `git add -A && git commit -m "setup: add agent toolkit"`
4. On next chat session the agent will auto-onboard via onboarding-protocol.md

### README Section to Add

```markdown
## Agent Rules (Mandatory)

Any AI agent working on this project MUST read and follow `AGENT_RULES.md`
before performing any operations.

See `AGENT_RULES.md` for full details.
See `instructions/` for complete rule descriptions.
See `skills/` for automated tooling.
```

## What Each Component Does

### Skills (automated tools)

| Skill | Purpose | Trigger |
|-------|---------|---------|
| git-safe-ops | Prevent git disasters in sandbox | Before push/pull/rebase |
| dev-watchdog | Keep dev server alive | Server start/restart/check |

### Instructions (behavioral rules)

| Instruction | Purpose |
|-------------|---------|
| onboarding-protocol | 6-step agent entry into existing project |
| git-workflow-rules | Backup before ops, force push over rebase |
| language-rule | Match user's language, never switch |
| diagnostic-disclosure | 5 verification steps before declaring data loss |

### Standards (code quality)

| Standard | Purpose |
|----------|---------|
| README_TEMPLATE | Mandatory README sections (12 total) |
| MARKDOWN_STANDARD | ASCII + Cyrillic only, no Unicode |
| No-Unicode_Policy | Zero non-Cyrillic non-ASCII in production code |
| REPRODUCIBILITY-STANDARD | .env.example, relative paths only |

## Problem History

This toolkit was created from real incidents in Z.ai sandbox:

- `git pull --rebase` blocked entire sandbox for 2 hours (git-safe-ops)
- Agent falsely declared code permanently lost (diagnostic-disclosure)
- Agent switched language without user request (language-rule)
- Dev server died every 5 minutes with no recovery (dev-watchdog)
- New chat sessions started blind with no context (onboarding-protocol)

## Version

v1.0.0 - Initial release from Web-Aesthetic-Showcase project

---
Built with: Next.js 16 + TypeScript + Tailwind CSS
