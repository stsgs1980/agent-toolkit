# Feature Development Workflow

## When to Use

Use this workflow when building a NEW feature, component, or page.

Skip brainstorm for trivial tasks (fix a typo, change a color).
Skip brainstorm for tasks the user described in full detail.

---

## Phase 1: BRAINSTORM (skip for simple tasks)

Goal: understand what the user wants and propose approaches.

### Steps

1. **Clarify requirements**
   - Ask: "What should this feature do?"
   - Ask: "Who will use it?"
   - Ask: "Any specific design preferences?"

2. **Propose approaches**
   - Give 2-3 options with pros/cons
   - Example:
     ```
     Option A: shadcn/ui Dialog component
       + Accessible, tested, consistent
       - Requires dialog state management

     Option B: Custom modal with CSS animation
       + Full control over animation
       - Need to handle a11y manually
     ```

3. **User picks approach**
   - Never proceed without user confirmation

### Output

- User's confirmed choice recorded in worklog.md

---

## Phase 2: PLAN (mandatory for all features)

Goal: define exact files, order, and risks before writing code.

### Steps

1. **List files to create/modify**
   ```
   Files to create:
   - src/components/feature-name.tsx
   - src/app/api/feature/route.ts

   Files to modify:
   - src/app/page.tsx (add import)
   ```

2. **Define implementation order**
   ```
   1. Create API route (backend)
   2. Create component (frontend)
   3. Integrate into page
   4. Add responsive styles
   ```

3. **Identify risks**
   ```
   Risks:
   - Database migration needed? No
   - Breaking existing functionality? No
   - External dependencies? No
   ```

4. **Write plan to worklog.md**
   ```
   ---
   Task: Add user profile feature
   Plan:
   - 1. Create /api/profile route (GET, PUT)
   - 2. Create ProfileCard component
   - 3. Add to dashboard page
   Risks: None
   ```

5. **Get user confirmation**
   - Show plan, ask: "Proceed?"

### Output

- Plan in worklog.md
- User confirmation

---

## Phase 3: IMPLEMENT

Goal: write code following the plan exactly.

### Steps

1. **Work in planned order**
   - Do NOT skip steps
   - Do NOT add unplanned features

2. **Commit after each logical unit**
   ```
   git add src/app/api/profile/route.ts
   git commit -m "feat(profile): add API route"
   ```

3. **Run lint after each commit**
   ```
   bun run lint
   ```

4. **Keep user informed**
   - Report progress: "Step 2/4 done"
   - Report blockers immediately

### Rules

- If plan needs to change -> go back to Phase 2 (update plan, confirm)
- If you discover a bug -> note it, fix later (don't lose focus)
- If user changes requirements -> restart from Phase 1

### Output

- Code files created/modified
- Git commits with semantic messages

---

## Phase 4: QA

Goal: verify everything works before reporting "done".

### Checklist

```
[ ] bun run lint          - No errors
[ ] bun run build         - Builds successfully
[ ] Manual test           - Feature works in browser
[ ] Responsive test       - Works on mobile (375px) and desktop (1920px)
[ ] No console errors     - Check browser dev tools
[ ] No forbidden Unicode  - Check new files
[ ] Git committed         - All changes committed
[ ] Git pushed            - Changes pushed to remote
```

### Steps

1. Run lint
2. Run build
3. Test in browser (via Preview Panel)
4. Report results:
   ```
   Feature complete:
   - lint: PASS
   - build: PASS
   - manual test: PASS
   - commits: feat(profile): add API route, feat(profile): add ProfileCard
   - pushed: yes
   ```

### If QA fails

- Fix the issue
- Re-run failed checks
- Do NOT report "done" until all checks pass

---

## Example: Full Workflow

```
User: "I want a dark mode toggle"

Phase 1 BRAINSTORM:
  Option A: next-themes library
    + Handles system preference, SSR, flash prevention
    - Extra dependency
  Option B: Custom context + localStorage
    + No extra dependency
    - Need to handle SSR flash manually
  User picks: Option A

Phase 2 PLAN:
  Files to create: src/components/theme-toggle.tsx
  Files to modify: src/app/layout.tsx (add ThemeProvider)
  Order: 1. layout.tsx, 2. theme-toggle.tsx, 3. integrate
  Risks: None
  User confirms: yes

Phase 3 IMPLEMENT:
  [1/3] Modified layout.tsx - added ThemeProvider
  [2/3] Created theme-toggle.tsx - sun/moon icon toggle
  [3/3] Integrated into header
  Lint: 0 errors

Phase 4 QA:
  lint: PASS
  build: PASS
  manual: toggle works, persists on refresh
  pushed: yes
```

---

Built with: Next.js 16 + TypeScript + Tailwind CSS
