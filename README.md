# Agent Toolkit

**Standards + Skills + Rules** for AI-driven development

> Toolkit version: **v1.4.0**

---

## What Is This

Agent Toolkit is a self-contained set of governance documents, operational templates, and behavioral instructions that ensure AI agents produce consistent, clean, and reproducible code and documentation across projects.

It solves three problems:

1. **Inconsistency** -- different agents format code and docs differently
2. **Unicode pollution** -- emoji and Unicode symbols creeping into source code and docs
3. **Reproducibility** -- projects that break on clone because of hardcoded paths and missing env vars

---

## Quick Start

### Option A: Full Toolkit (recommended)

```bash
# Clone the toolkit
git clone https://github.com/Sts8987/agent-toolkit.git

# Copy standards and templates to your project
cp -r agent-toolkit/standards/  your-project/standards/
cp -r agent-toolkit/templates/  your-project/templates/
cp -r agent-toolkit/instructions/ your-project/instructions/
cp agent-toolkit/AGENT_RULES.md   your-project/
cp agent-toolkit/PROJECT_CONFIG.md your-project/

# Edit PROJECT_CONFIG.md for your stack
```

### Option B: Standards Only

```bash
git clone https://github.com/Sts8987/agent-toolkit.git
cp -r agent-toolkit/standards/ your-project/standards/
```

### Option C: Single Document

Download only the standard you need from the `standards/` directory.

---

## Implementation Order

**Do not apply standards randomly.** There is a mandatory 6-step sequence.

Each step builds on the previous one. Violating the order causes rework.

```text
Step 1: Accept Standards (Group B)      Read, understand, define stack
         |
         v
Step 2: Deploy Worklog (Group A)        Copy templates, verify against B
         |
         v
Step 3: REPRODUCIBILITY                 Configure env, DB, paths
         |                              Log to WORKLOG
         v
Step 4: No-Unicode Policy [C]           ESLint rule + UI code cleanup
         |                              Log to WORKLOG
         v
Step 5: MARKDOWN_STANDARD [W]           .md file cleanup (incl. Group A)
         |                              Log to WORKLOG
         v
Step 6: README_TEMPLATE                 Assemble README from template
                                        Log to WORKLOG
```

Full details: see `standards/ПОРЯДОК_внедрения_стандартов.md`

---

## Repository Structure

```text
agent-toolkit/
  AGENT_RULES.md              Behavioral rules for AI agents
  PROJECT_CONFIG.md           Project-specific settings (stack, server, paths)
  README.md                   This file

  standards/                  Group B: Governance documents (apply first)
    MARKDOWN_STANDARD_RU_v2.1.md    Markdown formatting (Russian) v2.1.4
    MARKDOWN_STANDARD_EN_v2.1.md    Markdown formatting (English) v2.1.4
    No-Unicode_Policy_v2.1.md       Unicode/emoji prohibition v2.1.3
    README_TEMPLATE.md              Mandatory README structure v2.1
    REPRODUCIBILITY-STANDARD.md     Clone + install + dev = works
    ПОРЯДОК_внедрения_стандартов.md Implementation sequence v2.0

  templates/                  Group A: Operational templates (deploy after B)
    WORKLOG.md                Agent work journal v2.1.1
    TASK_TEMPLATE.md          Sub-agent prompt templates v2.1.1
    README_WORKLOG.md         Worklog system guide v2.1.1

  instructions/               Detailed behavioral instructions
    onboarding-protocol.md    What to do when entering a project
    git-workflow-rules.md     Safe git operations in sandbox
    language-rule.md          Always match user's language
    diagnostic-disclosure.md  Never assert data loss without verification
    writing-plans.md          Plan before you code

  skills/                     Automated agent skills
    git-safe-ops/             Safe git push/pull/rebase
    dev-watchdog/             Dev server management

  assets/                     Visual assets
    logo.png
    favicon.png
```

---

## Document Classification

### Group B -- Governance (standards)

These define rules. They are read and accepted, not modified per project.

| Document | Version | Level | Scope |
|----------|---------|-------|-------|
| `No-Unicode_Policy_v2.1.md` | v2.1.3 | [C]+[W]+[I] | UI code [C], AI-chat + docs [W], prototypes [I] |
| `MARKDOWN_STANDARD_RU_v2.1.md` | v2.1.4 | [W] | README, project documentation |
| `MARKDOWN_STANDARD_EN_v2.1.md` | v2.1.4 | [W] | Same in English |
| `README_TEMPLATE.md` | v2.1 | -- | Mandatory README structure |
| `ПОРЯДОК_внедрения_стандартов.md` | v2.0 | -- | 6-step implementation sequence |
| `REPRODUCIBILITY-STANDARD.md` | v1.0 | [C] | Environment, paths, DB |

### Group A -- Operational (templates)

These are deployed into a project. They SUBMIT to Group B standards.

| Document | Version | Purpose |
|----------|---------|---------|
| `WORKLOG.md` | v2.1.1 | Agent work journal (live file) |
| `TASK_TEMPLATE.md` | v2.1.1 | Sub-agent prompt templates |
| `README_WORKLOG.md` | v2.1.1 | Worklog system guide |

### Infrastructure

| Document | Purpose |
|----------|---------|
| `AGENT_RULES.md` | Behavioral rules (universal) |
| `PROJECT_CONFIG.md` | Project-specific settings (per project) |
| `instructions/*.md` | Detailed behavioral instructions |

---

## Key Rules Summary

### No-Unicode Policy

- No emoji or Unicode graphic characters in source code, UI text, or AI chat responses
- `(ref)` exception: identification symbols in tables and code blocks
- Typographic characters (em dash, copyright, degree) allowed in plain text
- User messages in chat are NOT regulated
- Levels: [C] for code/UI, [W] for AI-chat and documentation

### MARKDOWN_STANDARD

- ASCII + Cyrillic + typographic characters in text
- No Unicode in headings, code, or tables (except `(ref)`)
- 4 backticks for nested code blocks
- Language tags required on all code blocks
- Dash `-` for unordered lists (not `*` or `+`)
- Stack signature: `Built with: <project technologies>`

### REPRODUCIBILITY

- `.env.example` required with all variables
- Relative paths only (no `/home/`, `http://localhost:`)
- `connection_limit=1` for SQLite
- `clone + install + dev = works`

---

## Toolkit Versioning

| Component | Version |
|-----------|---------|
| **Toolkit** | **v1.4.0** |
| MARKDOWN_STANDARD (RU/EN) | v2.1.4 |
| No-Unicode_Policy | v2.1.3 |
| WORKLOG / TASK_TEMPLATE / README_WORKLOG | v2.1.1 |
| ПОРЯДОК_внедрения_стандартов | v2.0 |
| REPRODUCIBILITY-STANDARD | v1.0 |
| README_TEMPLATE | v2.1 |

When updating individual standards, update the toolkit version in `AGENT_RULES.md` and `README.md`.

---

## Configuration

After copying the toolkit to your project, edit **`PROJECT_CONFIG.md`**:

1. Set your stack signature (e.g., `Built with: React + Python + PostgreSQL`)
2. Set your dev server command and port
3. Set your project paths

`AGENT_RULES.md` references `PROJECT_CONFIG.md` for all project-dependent settings, so you never need to modify the agent rules themselves.

---

## License

This toolkit is provided as-is for use with AI-driven development workflows.

---

## Changelog

| Version | Changes |
|---------|---------|
| **v1.4.0** | Unified toolkit: AGENT_RULES rewritten, PROJECT_CONFIG.md added, README overhauled, No-Unicode levels synced [C]+[W]+[I], REPRODUCIBILITY classified as Group B, real PNG images |
| v1.3.0 | Added logos (assets/), worklog system, Implementation Order (6-step sequence), parameterized stack signature, AI-chat in No-Unicode Policy, `(ref)` exception for code blocks |
| v1.2.1 | Updated standards to v2.1 (typographics allowed in text, EN standard added) |
| v1.2.0 | Added writing-plans instruction (plan before code for tasks > 3 steps) |
| v1.1.0 | Added development workflows (feature, bug-fix, refactor) + E2E templates |
| v1.0.0 | Initial release from Web-Aesthetic-Showcase project |

---

Built with: Next.js 16 + TypeScript + Tailwind CSS
