# Refactor Workflow

## When to Use

Use this workflow when improving existing code WITHOUT changing its behavior.

Refactoring means: same functionality, better code structure.

---

## Phase 1: ANALYZE (mandatory)

Goal: understand what needs refactoring and why.

### Steps

1. **Identify the problem**
   ```
   Code smell examples:
   - Function too long (> 100 lines)
   - Duplicate code in multiple files
   - Component does too many things
   - Deep nesting (> 3 levels)
   - Magic numbers/strings without constants
   - Inconsistent naming
   - Missing TypeScript types (using 'any')
   ```

2. **Classify refactor type**

   | Type | Description | Risk |
   |------|-------------|------|
   | Extract | Pull logic into separate function/component | Low |
   | Rename | Improve variable/function naming | Low |
   | Simplify | Reduce complexity, remove nesting | Low |
   | Consolidate | Merge duplicate code | Medium |
   | Restructure | Change file/folder organization | Medium |
   | Re-architect | Change data flow or state management | High |

3. **Measure before**
   - Count lines of code in target files
   - Count duplicate patterns
   - Note build time
   - Record: "BEFORE: X lines, Y components, Z ms build"

4. **Document current state**
   ```
   Refactor target: src/app/page.tsx
   Current state: 1550 lines, 6 style sections inline
   Problem: monolithic file, hard to maintain
   Type: Restructure + Extract
   Risk: Medium (touching main page)
   ```

### Rules

- NEVER refactor without documenting the current state first
- NEVER refactor and add features at the same time
- ALWAYS be able to prove behavior did not change

### Output

- Problem identified and classified
- Current state measured
- Documented in worklog.md

---

## Phase 2: PLAN (mandatory)

Goal: define the refactoring steps with a rollback strategy.

### Steps

1. **Define target state**
   ```
   Target:
   - Extract 6 style sections into src/components/styles/
   - Each style in its own file
   - Main page imports and switches between them
   - Target: page.tsx under 200 lines
   ```

2. **Step-by-step plan**
   ```
   Step 1: Create src/components/styles/ directory
   Step 2: Extract TerminalStyle into terminal-style.tsx
   Step 3: Extract CLIStyle into cli-style.tsx
   Step 4: Extract BrutalStyle into brutal-style.tsx
   Step 5: Extract SciFiStyle into scifi-style.tsx
   Step 6: Extract CodeArtStyle into code-art-style.tsx
   Step 7: Extract ModernStyle into modern-style.tsx
   Step 8: Update page.tsx to import and use extracted components
   Step 9: Verify all styles still work
   Step 10: Clean up unused code
   ```

3. **Define rollback strategy**
   ```
   Before starting:
   - git stash push -m "pre-refactor-backup"
   - git tag pre-refactor-v1

   If anything breaks:
   - git stash pop
   - OR git checkout pre-refactor-v1
   ```

4. **Get user confirmation**
   - Show plan + rollback strategy
   - Ask: "Proceed?"

### Output

- Plan with numbered steps
- Rollback strategy defined
- User confirmation received

---

## Phase 3: REFACTOR

Goal: execute the plan step by step with verification after each.

### Steps

1. **Create backup**
   ```bash
   git stash push -m "pre-refactor-backup"
   cp -r src/ /tmp/src-pre-refactor/
   ```

2. **Execute one step at a time**
   - Complete step 1
   - Verify: `bun run lint`
   - Verify: page still renders (curl check)
   - Commit: `git commit -m "refactor: extract TerminalStyle component"`

3. **Do NOT combine steps**
   - One logical change per commit
   - Easy to bisect if something breaks

4. **Keep user informed**
   - "Step 3/10: Extracting BrutalStyle"
   - "Step 7/10: All styles extracted, updating page.tsx"

### Commit message format

```
refactor: <short description of what changed>
```

Examples:
- `refactor: extract TerminalStyle into separate component`
- `refactor: replace magic numbers with named constants`
- `refactor: simplify nested conditionals with early returns`

### Rules

- If lint fails -> fix before continuing
- If build fails -> stop, investigate, do NOT push forward
- If behavior changes -> this is NOT a refactor, use feature workflow instead

### Output

- Code restructured
- All commits with semantic messages
- Lint passes after each step

---

## Phase 4: VERIFY (mandatory)

Goal: prove behavior is identical after refactoring.

### Checklist

```
[ ] bun run lint              - PASS
[ ] bun run build             - PASS
[ ] BEFORE measurements recorded
[ ] AFTER measurements taken
[ ] Behavior identical        - all features work
[ ] Lines of code reduced     (if goal was reduction)
[ ] No regressions            - no new bugs
[ ] Committed and pushed
[ ] Backup cleaned up
[ ] worklog.md updated
```

### Steps

1. **Run lint and build**
2. **Compare measurements**
   ```
   BEFORE: 1550 lines, 1 component, build 3.2s
   AFTER:  page.tsx 180 lines + 6 style components, build 2.8s
   Delta:  -1370 lines in page.tsx, +6 components, -400ms build
   ```

3. **Test all affected features**
   - Every feature that was touched must still work
   - Every visual style must render correctly
   - Responsive design must still work

4. **Report to user**
   ```
   Refactor complete:
   - What: Extracted 6 style sections from page.tsx
   - Before: 1550 lines in 1 file
   - After: 180 lines + 6 components
   - Lint: PASS | Build: PASS
   - Behavior: identical, no regressions
   - Backup: cleaned up
   ```

5. **Clean up backup**
   ```bash
   rm -rf /tmp/src-pre-refactor/
   git stash drop  # only if everything works
   ```

### If verification fails

- Stop immediately
- Use rollback strategy (git stash pop or git checkout tag)
- Analyze what went wrong
- Re-plan and retry

---

## Example: Full Workflow

```
User: "page.tsx is 1550 lines, can you split it up?"

Phase 1 ANALYZE:
  Target: src/app/page.tsx
  Current: 1550 lines, 6 inline style sections
  Problem: monolithic, hard to maintain, long load
  Type: Restructure + Extract
  Risk: Medium

Phase 2 PLAN:
  Steps: extract 6 styles into components, update page.tsx
  Target: page.tsx under 200 lines
  Rollback: git stash + cp backup to /tmp/
  User confirms: yes

Phase 3 REFACTOR:
  [backup] git stash + cp src/ to /tmp/src-pre-refactor/
  [1/10] Created src/components/styles/ directory
  [2/10] Extracted TerminalStyle -> terminal-style.tsx (lint PASS)
  [3/10] Extracted CLIStyle -> cli-style.tsx (lint PASS)
  [4/10] Extracted BrutalStyle -> brutal-style.tsx (lint PASS)
  [5/10] Extracted SciFiStyle -> scifi-style.tsx (lint PASS)
  [6/10] Extracted CodeArtStyle -> code-art-style.tsx (lint PASS)
  [7/10] Extracted ModernStyle -> modern-style.tsx (lint PASS)
  [8/10] Updated page.tsx to import extracted components (lint PASS)
  [9/10] Verified all 6 styles render correctly
  [10/10] Cleaned up unused code

Phase 4 VERIFY:
  Lint: PASS | Build: PASS
  Before: 1550 lines, 1 file
  After: 180 lines + 6 components
  All 6 styles: working
  Mobile/desktop: working
  Backup: cleaned up
```

---

Built with: Next.js 16 + TypeScript + Tailwind CSS
