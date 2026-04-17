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
    writing-plans.md                - Task planning before coding
  standards/                       - Code and documentation standards
    README_TEMPLATE.md             - Mandatory README structure
    MARKDOWN_STANDARD_RU_v2.0.md   - Markdown formatting rules
    No-Unicode_Policy_v2.0.md      - Unicode restrictions
    REPRODUCIBILITY-STANDARD.md    - Build reproducibility rules
  templates/                       - Files to copy into new projects
    AGENT_RULES.md                 - Master rules file (copy and adapt)
    workflows/                     - Development workflows
      feature-development.md       - New feature: brainstorm -> plan -> implement -> QA
      bug-fix.md                   - Bug fix: reproduce -> diagnose -> fix -> verify
      refactor.md                  - Refactor: analyze -> plan -> refactor -> verify
    e2e/                            - E2E test templates (Playwright)
    playwright.config.ts           - Playwright configuration
```

## Quick Start

### Option A: Bootstrap Script (always works, no git needed)

Copy the content of `dist/setup.txt` and paste into any chat.
The agent will create all 9 files from the embedded content.
No GitHub access, no PAT, no git required.

Or run the script directly if you have the file:

```bash
# From local copy
bash dist/setup.sh

# Or from GitHub (with PAT)
curl -sL https://ghp_YOUR_PAT@raw.githubusercontent.com/Sts8987/agent-toolkit/main/dist/setup.sh | bash
```

Files created:

```
instructions/
  onboarding-protocol.md
  git-workflow-rules.md
  language-rule.md
  diagnostic-disclosure.md
  writing-plans.md
skills/
  git-safe-ops/SKILL.md
  dev-watchdog/SKILL.md
AGENT_RULES.md
worklog.md
```

### Option B: Clone with PAT (if you have a GitHub token)

```bash
git clone https://ghp_YOUR_PAT_HERE@github.com/Sts8987/agent-toolkit.git /tmp/agent-toolkit
cp -r /tmp/agent-toolkit/skills/ ./skills/
cp -r /tmp/agent-toolkit/instructions/ ./instructions/
cp /tmp/agent-toolkit/templates/AGENT_RULES.md ./AGENT_RULES.md
cp /tmp/agent-toolkit/templates/worklog.md ./worklog.md
mkdir -p upload && cp /tmp/agent-toolkit/standards/*.md ./upload/ 2>/dev/null
rm -rf /tmp/agent-toolkit
```

Replace `ghp_YOUR_PAT_HERE` with your GitHub Personal Access Token.

### Option C: Public Clone (if repo is visible on GitHub)

```bash
git clone https://github.com/Sts8987/agent-toolkit.git /tmp/agent-toolkit
cp -r /tmp/agent-toolkit/skills/ ./skills/
cp -r /tmp/agent-toolkit/instructions/ ./instructions/
cp /tmp/agent-toolkit/templates/AGENT_RULES.md ./AGENT_RULES.md
cp /tmp/agent-toolkit/templates/worklog.md ./worklog.md
mkdir -p upload && cp /tmp/agent-toolkit/standards/*.md ./upload/ 2>/dev/null
rm -rf /tmp/agent-toolkit
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
| writing-plans | Plan before coding for tasks > 3 steps |

### Standards (code quality)

| Standard | Purpose |
|----------|---------|
| README_TEMPLATE | Mandatory README sections (12 total) |
| MARKDOWN_STANDARD | ASCII + Cyrillic only, no Unicode |
| No-Unicode_Policy | Zero non-Cyrillic non-ASCII in production code |
| REPRODUCIBILITY-STANDARD | .env.example, relative paths only |

### Workflows (development process)

| Workflow | When to Use | Phases |
|----------|-------------|--------|
| feature-development | New feature or component | Brainstorm -> Plan -> Implement -> QA |
| bug-fix | Fixing a bug or error | Reproduce -> Diagnose -> Fix -> Verify |
| refactor | Improving code structure | Analyze -> Plan -> Refactor -> Verify |

## Problem History

This toolkit was created from real incidents in Z.ai sandbox:

- `git pull --rebase` blocked entire sandbox for 2 hours (git-safe-ops)
- Agent falsely declared code permanently lost (diagnostic-disclosure)
- Agent switched language without user request (language-rule)
- Dev server died every 5 minutes with no recovery (dev-watchdog)
- New chat sessions started blind with no context (onboarding-protocol)

## Version

v1.2.0 - Added writing-plans instruction (plan before code for tasks > 3 steps)
v1.1.0 - Added development workflows (feature, bug-fix, refactor) + E2E templates
v1.0.0 - Initial release from Web-Aesthetic-Showcase project

---
Built with: Next.js 16 + TypeScript + Tailwind CSS
