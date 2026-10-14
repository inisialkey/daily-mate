# DailyMate — implementation plan

Personal, offline macOS productivity app: tasks, notes, reminders, Islamic prayer
times, and a Today dashboard. Single user, no backend, no account.

## Stack (verified against Flutter 3.44.4 / Dart 3.12.2, Xcode 26.4, macOS 26.5)

| Concern | Choice | Note |
|---|---|---|
| State | `flutter_bloc` 9 (Cubit) | Bloc only if an event log is ever needed |
| Models / state | `freezed` 3.2 | freezed 4 needs Dart 3.13; `bloc_test` pins analyzer < 13 |
| DI | `get_it` 9 as `sl` | one central file, `lib/core/di/service_locator.dart` |
| Routing | `go_router` 17 | `StatefulShellRoute` keeps each section's state |
| Storage | Drift 2.34 + SQLite (`sqlite3` 3.x build hook) | DB in Application Support, not Documents |
| Notifications | `flutter_local_notifications` 22.3 | `UNCalendarNotificationTrigger`, verified via pending list |
| Prayer times | `adhan_dart` 2.0.1 | maintained (2026-05), has KEMENAG method |
| Location (optional) | `geolocator` 14 | only on explicit request |
| Markdown | `flutter_markdown_plus` 1.0 | community successor of `flutter_markdown` |
| Logging | `logger` 2.8 behind `AppLogger` | console in debug, file in Application Support |

Deliberate deviations from `flutter@ai-kit` defaults (the project brief takes precedence):
no `fpdart`/`Either` (brief forbids it without need), no UseCase layer (Cubits use the
domain repository contracts directly), no flavors / screenutil / ARB l10n (single
personal macOS build, English UI).

## Milestones and acceptance criteria

1. **Foundation** — theme + tokens, app shell with collapsible sidebar, routing, DI,
   logging, Drift schema v1 with migration test, native window chrome.
   *Done when* the app builds for macOS, launches, every sidebar destination renders,
   light/dark both work, gate green.
2. **Tasks** — CRUD, subtasks, tags, category, priority, filters, sort, Today /
   Upcoming / All / Completed views, quick add, recurrence.
   *Done when* recurrence tests cover month ends, leap years, weekdays, idempotent
   completion and reopen; repository tests run on in-memory SQLite.
3. **Notes** — Markdown write/preview, autosave with visible status, pin, archive,
   folders, tags, search, convert to task, task links.
   *Done when* typing is never lost on navigation, window close or quit (flush tested).
4. **Reminders** — one-time and recurring reminders, task deadline reminders, snooze,
   done, history, permission onboarding, OS scheduling with launch reconciliation.
   *Done when* planner/reconciler tests prove no duplicates, cancellation of obsolete
   requests, and recovery after restart; a real notification is observed on this Mac.
5. **Prayer times** — location (city list, coordinates, optional current location),
   method, Asr madhab, high-latitude rule, per-prayer adjustment / alert / advance /
   sound, countdown, scheduling through the same reconciler.
   *Done when* calculations are tested against fixed coordinates/dates.
6. **Dashboard and polish** — Today dashboard, search (⌘K), keyboard shortcuts,
   context menus, empty states, first-use guidance, accessibility pass, visual review
   of the running app in both themes.
7. **Release** — format, analyze, full tests, `flutter build macos --release`,
   verify `DailyMate.app`, install script, README with install/update/uninstall and
   documented platform limitations.
