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

### For New Project

1. Copy entire `agent-toolkit/` to project root
2. Copy `templates/AGENT_RULES.md` to project root
3. Create `worklog.md` in project root
4. Agent will auto-onboard via onboarding-protocol.md

### For Existing Project

1. Copy `agent-toolkit/` to project root
2. Copy `templates/AGENT_RULES.md` to project root
3. Add "Agent Rules (Mandatory)" section to README.md
4. Agent will detect and follow rules on next session

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
