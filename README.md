# Agent Toolkit

**Standards + Skills + Rules** for AI agent projects.

---

Unified toolkit for AI agent behavior rules, skills, and project standards.
Copy into any Next.js project to ensure consistent agent behavior across sessions.

## Structure

```text
agent-toolkit/
  assets/                          - Project logos and images
    logo.png                       - Main square logo (1024x1024)
    logo-banner.png                - README banner (1344x768)
    favicon.png                    - Browser favicon
  skills/                          - Automated tools for agent
    git-safe-ops/SKILL.md          - Safe git operations (backup, force push)
    dev-watchdog/SKILL.md          - Dev server lifecycle management
  instructions/                    - Behavioral rules for agent
    onboarding-protocol.md         - How to enter existing project
    git-workflow-rules.md          - Git operation rules
    language-rule.md               - Language matching rule
    diagnostic-disclosure.md       - Data loss disclosure protocol
    writing-plans.md               - Task planning before coding
  standards/                       - Code and documentation standards
    No-Unicode_Policy_v2.1.md      - Unicode restrictions [C]
    MARKDOWN_STANDARD_RU_v2.1.md   - Markdown formatting rules (Russian) [W]
    MARKDOWN_STANDARD_EN_v2.1.md   - Markdown formatting rules (English) [W]
    README_TEMPLATE.md             - Mandatory README structure
    REPRODUCIBILITY-STANDARD.md    - Build reproducibility rules
    README_WORKLOG.md              - Worklog system guide
    TASK_TEMPLATE.md               - Prompt templates for sub-agents
    WORKLOG.md                     - Worklog journal template
    ПОРЯДОК_внедрения_стандартов.md - Implementation order (6 steps)
  templates/                       - Files to copy into new projects
    AGENT_RULES.md                 - Master rules file (copy and adapt)
    README_WORKLOG.md              - Worklog guide (copy)
    TASK_TEMPLATE.md               - Prompt templates (copy)
    WORKLOG.md                     - Worklog template (copy)
    workflows/                     - Development workflows
      feature-development.md       - New feature: brainstorm -> plan -> implement -> QA
      bug-fix.md                   - Bug fix: reproduce -> diagnose -> fix -> verify
      refactor.md                  - Refactor: analyze -> plan -> refactor -> verify
    e2e/                           - E2E test templates (Playwright)
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

```text
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
README_WORKLOG.md
TASK_TEMPLATE.md
```

### Option B: Clone with PAT (if you have a GitHub token)

```bash
git clone https://ghp_YOUR_PAT_HERE@github.com/Sts8987/agent-toolkit.git /tmp/agent-toolkit
cp -r /tmp/agent-toolkit/skills/ ./skills/
cp -r /tmp/agent-toolkit/instructions/ ./instructions/
cp /tmp/agent-toolkit/templates/AGENT_RULES.md ./AGENT_RULES.md
cp /tmp/agent-toolkit/templates/worklog.md ./worklog.md
cp /tmp/agent-toolkit/templates/README_WORKLOG.md ./README_WORKLOG.md
cp /tmp/agent-toolkit/templates/TASK_TEMPLATE.md ./TASK_TEMPLATE.md
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
cp /tmp/agent-toolkit/templates/README_WORKLOG.md ./README_WORKLOG.md
cp /tmp/agent-toolkit/templates/TASK_TEMPLATE.md ./TASK_TEMPLATE.md
mkdir -p upload && cp /tmp/agent-toolkit/standards/*.md ./upload/ 2>/dev/null
rm -rf /tmp/agent-toolkit
```

### After Setup

1. Verify files exist: `ls AGENT_RULES.md instructions/ skills/ worklog.md README_WORKLOG.md TASK_TEMPLATE.md`
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

## Implementation Order

Standards must be applied in order (each depends on the previous):

```text
Step 1: Accept standards (group B)         Read and accept rules
        |
        v
Step 2: Deploy worklog (group A)           Copy, create WORKLOG.md, verify compliance
        |
        v
Step 3: REPRODUCIBILITY                    Configure env, db, paths
        |
        v
Step 4: No-Unicode Policy [C]              ESLint rule + UI code cleanup
        |
        v
Step 5: MARKDOWN_STANDARD [W]              .md files cleanup (including group A)
        |
        v
Step 6: README_TEMPLATE                    Assemble README by template
```

See `standards/ПОРЯДОК_внедрения_стандартов.md` for full details.

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

| Standard | Level | Purpose |
|----------|-------|---------|
| No-Unicode Policy v2.1 | [C] Critical | Zero non-Cyrillic non-ASCII in production code, AI-chat [W] |
| MARKDOWN_STANDARD v2.1 | [W] Warning | ASCII + Cyrillic + typographics in text, strict in headings/code |
| README_TEMPLATE | - | Mandatory README sections (12 total) |
| REPRODUCIBILITY-STANDARD | - | .env.example, relative paths only |

### Worklog System (agent coordination)

| File | Purpose |
|------|---------|
| README_WORKLOG.md | Full guide: how worklog works, why sub-agents need explicit instructions |
| TASK_TEMPLATE.md | Ready-made prompt templates for full-stack-developer, Explore, general-purpose |
| WORKLOG.md | Empty journal template to copy into project |

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

v1.3.0 - Added logos (assets/), worklog system, ПОРЯДОК внедрения (6-step order), parameterized stack signature, AI-chat in No-Unicode Policy, (ref) exception for code blocks
v1.2.1 - Updated standards to v2.1 (typographics allowed in text, EN standard added)
v1.2.0 - Added writing-plans instruction (plan before code for tasks > 3 steps)
v1.1.0 - Added development workflows (feature, bug-fix, refactor) + E2E templates
v1.0.0 - Initial release from Web-Aesthetic-Showcase project

---
Built with: Next.js 16 + TypeScript + Tailwind CSS
