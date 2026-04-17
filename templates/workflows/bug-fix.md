# Bug Fix Workflow

## When to Use

Use this workflow when fixing a bug, error, or unexpected behavior.

---

## Phase 1: REPRODUCE (mandatory)

Goal: confirm the bug exists and understand how to trigger it.

### Steps

1. **Ask the user for details**
   - "What were you doing when it happened?"
   - "What did you expect to happen?"
   - "What actually happened?"
   - "Can you share a screenshot or error message?"

2. **Try to reproduce**
   - Follow user's steps
   - Check browser console for errors
   - Check dev server logs (dev.log, /tmp/zdev.log)
   - Check network tab for failed requests

3. **Classify the bug**

   | Category | Examples | Fix complexity |
   |----------|----------|----------------|
   | UI glitch | Wrong color, layout shift, missing style | Low |
   | Runtime error | TypeError, undefined, null reference | Medium |
   | Build error | TypeScript error, import missing | Low |
   | Logic error | Wrong calculation, wrong state | Medium |
   | Server error | 500, API route failure | High |
   | Environment | .env missing, port conflict, DB error | Low |

4. **Record reproduction steps**
   ```
   Bug: [short description]
   Steps to reproduce:
   1. Open page /url
   2. Click button X
   3. Expected: Y happens
   4. Actual: Z happens instead
   Error: [paste error message if any]
   ```

### Output

- Reproduction steps documented
- Bug classified
- If cannot reproduce -> ask user for more details, DO NOT guess

---

## Phase 2: DIAGNOSE (mandatory)

Goal: find the root cause, not just the symptom.

### Steps

1. **Read the relevant code**
   - Start from where the error occurs
   - Trace back to the source
   - Check related files

2. **Form hypothesis**
   ```
   Hypothesis 1: Variable X is undefined because API returns null
   Hypothesis 2: CSS class is missing because conditional is wrong
   ```

3. **Test hypothesis**
   - Add console.log or check values
   - Verify data flow
   - Check edge cases

4. **Find root cause**
   ```
   Root cause: The component renders before API data loads.
   The loading state is not handled, so .map() is called on undefined.
   ```

### Rules

- Fix the ROOT CAUSE, not the symptom
- Example:
  - Symptom fix: `data?.map()` (adds optional chaining)
  - Root cause fix: Add loading state, render skeleton while loading

### Output

- Root cause identified and documented in worklog.md

---

## Phase 3: FIX (mandatory)

Goal: write the minimal fix that solves the root cause.

### Steps

1. **Plan the fix**
   ```
   Fix: Add loading state check before rendering data
   Files to modify: src/components/data-list.tsx
   ```

2. **Implement the fix**
   - Make the MINIMAL change needed
   - Do NOT refactor nearby code (separate task)
   - Do NOT add features while fixing

3. **Verify the fix locally**
   - Reproduce the bug -> should NOT reproduce now
   - Test edge cases
   - Run lint: `bun run lint`

4. **Commit**
   ```
   git commit -m "fix: add loading state check in DataList component"
   ```

### Commit message format

```
fix: <short description of what was fixed>
```

Examples:
- `fix: handle undefined data in user profile component`
- `fix: correct API route response type`
- `fix: resolve layout overflow on mobile viewport`

### Output

- Bug fixed
- Lint passes
- Commit created

---

## Phase 4: VERIFY (mandatory)

Goal: confirm the fix works and nothing else broke.

### Checklist

```
[ ] Bug no longer reproduces
[ ] Edge cases tested
[ ] bun run lint          - PASS
[ ] bun run build         - PASS
[ ] Other features still work (regression check)
[ ] Committed and pushed
[ ] worklog.md updated
```

### Steps

1. Test the original bug scenario -> should pass
2. Test 2-3 related features -> should still work
3. Run lint and build
4. Push to remote
5. Report to user:
   ```
   Bug fixed:
   - Root cause: [description]
   - Fix: [what was changed]
   - Files: [list]
   - Lint: PASS | Build: PASS
   - Regression: no other features affected
   ```

### If verification fails

- Revert the fix
- Go back to Phase 2 (re-diagnose)
- Do NOT push a fix that breaks other things

---

## Example: Full Workflow

```
User: "The guestbook shows an error when I submit a message"

Phase 1 REPRODUCE:
  1. Opened / in browser
  2. Typed message in guestbook form
  3. Clicked submit
  4. Got error: "TypeError: Cannot read property 'name' of undefined"
  Category: Runtime error

Phase 2 DIAGNOSE:
  - Read guestbook component code
  - Found: form calls /api/guestbook POST
  - Checked API route: returns { success: true }
  - Found: component tries to read response.data.name
  - Root cause: API returns no data field, component expects it

Phase 3 FIX:
  - Fix: Update component to use response directly, not response.data.name
  - File: src/app/page.tsx line 847
  - Lint: 0 errors
  - Commit: "fix: read guestbook response directly without nested data field"

Phase 4 VERIFY:
  - Bug no longer reproduces: PASS
  - Guestbook shows new message after submit: PASS
  - Other styles still work: PASS
  - Lint: PASS | Build: PASS
  - Pushed: yes
```

---

Built with: Next.js 16 + TypeScript + Tailwind CSS
