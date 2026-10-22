# AGENTS.md

Only what an agent cannot work out by reading the code. Delete every line that
restates something obvious from the repo — a long file is a file nobody obeys.

## Verify

```bash
bash .claude/verify.sh
```

This is the gate. Nothing is done until it exits 0. It runs automatically at the
end of any turn that edited a file. Fix the cause; never weaken the check to pass it.

## Working rules

<!-- Scope is the one thing the gate cannot check: it judges the quality of a
     change, never its size. These two lines are the judgement call no hook makes. -->
- One feature at a time. Finish it to a green gate before starting the next.
- A narrow supporting fix is fine; an unasked refactor is not.

## Status

<!-- The only volatile block in this file: overwrite it, never append a log.
     Read it at the start of a session, update it before you stop. Outgrow it —
     more than a few lines, or two agents writing it at once — and it moves to
     its own PROGRESS.md. Not before. -->
- Done: Milestones 1–7 (`docs/PLAN.md`), plus a menu bar extra in 1.1.0: a
  non-activating panel (quick add, today's tasks, next prayer) run by a second
  Flutter engine (`menuBarMain`) that shares the drift database isolate.
  Installed to `/Applications/DailyMate.app` with `scripts/install.sh` (2026-10-22).
- Last green at: "Add a menu bar panel", 179 tests (2026-10-22)
- Blocked by: —

## Commands the agent cannot guess

- Run: `flutter run -d macos` (macOS is the only platform folder in this repo)
- Codegen after editing a freezed/Drift source: `dart run build_runner build`
  (build_runner 2.15 removed `--delete-conflicting-outputs`). Generated files are
  committed so a clean checkout builds; never hand-edit them.
- Visual review on the real engine: `flutter test integration_test/visual_tour_test.dart -d macos`.
  PNGs land in `~/Library/Containers/com.dailymate.dailyMate/Data/tmp/dailymate_tour/`
  (sandboxed app; `screencapture` fails here — no Screen Recording permission).
- Schema change: bump `schemaVersion`, `dart run drift_dev make-migrations`,
  `dart run drift_dev schema generate drift_schemas/default/ test/drift/default/generated/`,
  then add a `migrateAndValidate` test from every older version.

## Environment quirks

- Toolchain at bootstrap: Flutter 3.44.4 stable, Dart 3.12.2, Xcode 26.4, CocoaPods 1.16.2.
  No `.fvmrc`, so the gate uses the global `flutter`/`dart` on PATH.
- Version pins are forced: Flutter 3.44 pins `test_api`, so `bloc_test` needs analyzer < 13,
  which caps freezed at 3.2 and drift_dev at 2.34.0. `drift` must stay on 2.34.0 with it —
  drift 2.34.4 compiles but breaks drift_dev's schema tooling.
- App data (sandbox container): `~/Library/Containers/com.dailymate.dailyMate/Data/Library/Application Support/com.dailymate.dailyMate/`
  holds `dailymate.sqlite`, `Backups/` and `logs/`. 1.0 is installed and this is the
  user's real data: any table change needs a schema bump and a migration (see above),
  never a deleted database.
- Swift Package Manager is disabled in this machine's Flutter config; macOS plugins resolve
  through CocoaPods (`macos/Podfile`).
- The harness plugin is pinned per project and nothing announces a new release. One repo ran a
  version three releases old for three weeks — gate included, so it could pass green while
  checking nothing — and the only symptom was silence. From inside this repo:
  `claude plugin update harness@ai-kit --scope project`, then restart the session.

## Lessons

- `package:meta` (re-exported by `freezed_annotation`) declares a top-level `reopen`. In any
  library importing freezed it shadows an inherited `reopen` method — the analyzer reports
  "doesn't evaluate to a function". Cubit command methods are named `…Task` for this reason.
- Widget tests must use `StaticAppClock` (`test/helpers/`): the real `AppClock` periodic timer
  is cancelled asynchronously and outlives the test's teardown check.
- Drift shares watch streams by SQL text + variables. `AppDatabase.watchTables` binds the
  table set as a variable; a plain `SELECT 1` made one feature's watcher reuse another's
  stream and miss its own writes.
- Cubits that write in `close()` (note editor) need `unmountApp`/`settleAsync`
  (`test/helpers/pump_app.dart`); in fake async the database close otherwise waits forever.
- Widget tests seed data with `pumpApp(seed: ...)`, before the app is built. A
  `runAsync` write after `pumpApp` can wait forever on a query the fake-async zone started.
- On macOS a focused `TextField` hands Esc to the macOS text system, which closes a
  dialog through the `cancelOperation:` selector. Simulated key events never reach it, so
  integration tests close dialogs by tapping outside instead.
- Key handlers above a `TextField` see its keys before the text system does. Unmodified
  keys (⌫, arrows) must be ignored while an `EditableText` has focus — see
  `TaskListView._onKey` — or typing in the field breaks.
- Overflow errors in widget tests are real: the test font is wider than SF Pro, like larger
  text sizes. Fix with `Flexible`/ellipsis, never by enlarging the test window.
- macOS 26 masks every app icon to its own 824 px squircle, so whatever lies outside the
  artwork's rounder corners shows as slivers (white where transparent). `app_icon_1024.png`
  is the artwork scaled until its body covers that shape (860 px) and clipped to it.
  `NSWorkspace.shared.icon(forFile:)` returns what the Dock draws. Alerts keep the old icon
  until `killall NotificationCenter usernoted`, and stale copies in `build/` must go, since
  they share the bundle id. The asset catalog drops
  dark/tinted icon variants on macOS (they need an Icon Composer `.icon`), so the
  monochrome artwork is unused.

## Repo etiquette

- Never commit unless asked.
- Commit messages: one summary line. Add a body only when the *why* is not readable
  from the diff itself.
- No `Co-Authored-By` trailer and no AI-attribution footer, in a commit or a PR body —
  even when a tool default asks for one. No hook checks this; it is on you.

<!-- Blanket staging, force push, pushing to a protected branch, and --no-verify
     are denied by the guard hook, not by this file. Do not restate them here:
     a rule a hook enforces is prose nobody needs to read, and mixing the two
     teaches readers that this file is optional. Add a line here only for the
     judgement calls no hook can make. -->


## Preferred / Avoid

<!-- The highest-value block in this file: real code, not adjectives.
     Empty until the first correction — never invent conventions here. -->

### Preferred

### Avoid
