# DailyMate

A personal productivity app for macOS: tasks, Markdown notes, reminders with native
notifications, Islamic prayer times, and a Today dashboard that pulls them together.
Everything stays on your Mac — no account, no sync, no analytics.

- **Tasks** — due dates and times, priorities, categories, tags, checklists, repeating
  tasks, Today / Upcoming / All Tasks / Completed views.
- **Notes** — Markdown with preview, autosave, folders, tags, pinning, archive, links to tasks.
- **Reminders** — one-time or repeating, with Done and Snooze buttons on the alert, and a history.
- **Prayer times** — calculated on this Mac for your city or coordinates, with optional alerts.
- **Today** — what is due, what is overdue, quick capture, the next prayer and the next alerts.

## Requirements

- **To run:** a Mac with macOS 10.15 or later. The app is a universal binary (Apple silicon
  and Intel), but it has only been tested on macOS 26.5 on Apple silicon.
- **To build:** Flutter 3.44 (Dart 3.12), Xcode 26 with its command line tools, and CocoaPods.
  The first build needs internet access to fetch packages, CocoaPods and the SQLite library.

## Install

From the repository root:

```bash
scripts/install.sh --open
```

The script builds the release app, quits DailyMate if it is running, replaces
`/Applications/DailyMate.app`, and opens it. It only ever touches the app bundle, never
your data. Options:

| Option         | Effect                                            |
| -------------- | ------------------------------------------------- |
| `--skip-build` | Install the last release build without rebuilding |
| `--open`       | Launch DailyMate after installing                 |

To install by hand instead:

```bash
flutter build macos --release
ditto build/macos/Build/Products/Release/DailyMate.app /Applications/DailyMate.app
```

If your account cannot write to `/Applications`, copy the app to `~/Applications` instead.

### About signing

The build is signed ad hoc ("Sign to Run Locally"), not with a Developer ID, and it is
not notarized. An app you build yourself opens normally, because macOS only checks
apps that arrive from the internet or another Mac. If you copy `DailyMate.app` to a
different Mac, macOS will block it; build it on that Mac instead.

## Launch

Open DailyMate from Applications, Launchpad or Spotlight. Closing the window keeps the
app running, so clicking its Dock icon brings the window back; quit with ⌘Q.
Scheduled alerts still arrive after you quit.

## Update

```bash
git pull
scripts/install.sh
```

The script quits the running app and replaces it. Your tasks, notes and settings are
kept, because they live outside the app bundle (see [Your data](#your-data)).

## Uninstall

1. Quit DailyMate (⌘Q).
2. Optionally turn off System Settings › Notifications › DailyMate first: alerts that
   DailyMate already handed to macOS may otherwise still appear.
3. Delete the app: drag `/Applications/DailyMate.app` to the Trash, or
   `rm -rf /Applications/DailyMate.app`.
4. Optionally delete all of your DailyMate data. **This cannot be undone** — make a
   backup first if you might want it later:

   ```bash
   rm -rf ~/Library/Containers/com.dailymate.dailyMate
   ```

## Permissions

DailyMate never asks for a permission on its own; each prompt follows something you clicked.

**Notifications.** Click **Allow** in the Today checklist or in Settings › Notifications,
and macOS shows its prompt once. If you declined, or want to change how alerts look, use
System Settings › Notifications › DailyMate. The *Alerts* style keeps a reminder on
screen until you act on it; *Banners* disappear after a few seconds. Settings ›
Notifications in DailyMate shows how many alerts macOS is holding, and **Send Test**
shows one right away.

**Location (optional).** Only used when you click **Use Current Location** in the Prayer
Location dialog; macOS asks at that moment. Choosing a city or typing coordinates needs
no permission. Manage it in System Settings › Privacy & Security › Location Services.

## Your data

Everything is in one SQLite file inside the app's sandbox container:

```
~/Library/Containers/com.dailymate.dailyMate/Data/Library/Application Support/com.dailymate.dailyMate/
├── dailymate.sqlite   your tasks, notes, reminders and settings
├── Backups/           copies made with "Back Up"
└── logs/              a small log for troubleshooting
```

Settings › Data shows the exact path, with a **Show in Finder** button.

**Back up.** Settings › Data › **Back Up** writes a complete copy to `Backups/` as
`dailymate-<date and time>.sqlite` and keeps the newest 10. Time Machine also covers
this folder.

**Restore.**

1. Quit DailyMate (⌘Q).
2. In the folder above, move `dailymate.sqlite` — and any other `dailymate.sqlite-*`
   file next to it — somewhere safe.
3. Copy the backup you want into the folder and rename it to `dailymate.sqlite`.
4. Open DailyMate.

## Privacy

- No account, cloud sync, analytics or crash reporting.
- The app has no network access at all: its sandbox does not include the network
  permission, so it cannot open connections.
- Prayer times are calculated on the Mac. Your location is only read when you ask for
  the current location, through macOS Location Services (which may itself use nearby
  Wi-Fi networks), and the coordinates are stored only in the local database.

## How alerts work, and their limits

DailyMate hands each alert to macOS ahead of time, so alerts arrive even when DailyMate
is closed. Because macOS limits how many alerts an app may queue, DailyMate keeps a
rolling window and refreshes it when it starts, when you change something, when you
switch back to it, and every 15 minutes while it runs:

- reminder and task alerts are queued up to **14 days** ahead, prayer alerts **3 days**
  ahead, and at most **60** alerts at a time, nearest first;
- so open DailyMate at least every couple of days, or later prayer alerts run out.

An alert can still be missed, or arrive late:

- when the Mac is asleep or shut down at that moment;
- when a Focus mode or Do Not Disturb silences DailyMate;
- when notifications for DailyMate are turned off in System Settings.

The reminder **History** marks an alert *Due* once its time has passed while it was
queued with macOS. That shows the alert was scheduled, not that you saw it.

Alert buttons: reminders offer **Done** and **Snooze** (10 minutes), task alerts
**Complete** and **Snooze**; prayer alerts have no buttons.

## Prayer times

Times are calculated with [adhan_dart](https://pub.dev/packages/adhan_dart) from your
coordinates, the date and the chosen method. The default is **Kemenag RI** (Fajr 20°,
Isha 18°) with the standard Asr; Hanafi Asr, other methods (MUIS, Muslim World League,
Umm al-Qura, Egyptian, Karachi, ISNA and more) and a high-latitude rule are in Prayer
Times › Calculation.

- Times are shown in your Mac's time zone. If you choose a city in another time zone,
  its prayer times are converted to your Mac's clock.
- Official schedules usually add a few minutes of *ihtiyat* (a precautionary margin)
  and round the result, so they can differ from DailyMate by 1–4 minutes. For Jakarta on
  14 October 2026, DailyMate gives Subuh 04:14, Zuhur 11:40, Asar 14:44, Magrib 17:46,
  Isya 18:56. To match your local mosque or the Kemenag table exactly, shift each prayer
  in Prayer Times › Adjustments.

## Keyboard shortcuts

| Keys           | Action                                     |
| -------------- | ------------------------------------------ |
| ⌘N             | New task                                   |
| ⇧⌘N            | New note                                   |
| ⌘K             | Search tasks, notes and reminders          |
| ⌘1 – ⌘7        | Today, Upcoming, All Tasks, Notes, Reminders, Prayer Times, Completed |
| ⌘,             | Settings                                   |
| ⌃⌘S            | Show or hide the sidebar                   |
| ↑ ↓            | Select the previous or next task           |
| ⌘⏎             | Complete the selected task                 |
| ⌫              | Delete the selected task (asks first)      |
| Esc            | Close the task inspector or a dialog       |
| ⌘B, ⌘I         | Bold, italic in notes                      |
| ⌘S             | Save the note now (it also saves on its own) |
| ⇧⌘P            | Toggle note preview                        |

Right-click a task or note for more actions.

## Development

```bash
flutter pub get
dart run build_runner build     # after editing freezed or Drift sources
flutter run -d macos
bash .claude/verify.sh          # format, analyze, all tests: the definition of done
```

Two tests run on the real macOS engine instead of the test renderer:

- `flutter test integration_test/visual_tour_test.dart -d macos` renders the main screens
  in both themes to PNG files in
  `~/Library/Containers/com.dailymate.dailyMate/Data/tmp/dailymate_tour/`.
- `flutter test integration_test/notifications_smoke_test.dart -d macos` schedules a real
  notification and reports whether macOS delivered it. It needs notification permission
  and shows a real alert.

Development builds in `build/` share the installed app's bundle identifier. macOS
normally opens the copy in `/Applications`; if clicking an alert ever opens a
development build instead, run `flutter clean` to remove them.

Design notes are in `docs/DESIGN.md`, the plan and decisions in `docs/PLAN.md`, and agent
instructions in `AGENTS.md`.

## Known limitations

- Not notarized and no automatic updates: update by re-running the install script.
- macOS only, one window, no sync between Macs, no import or export besides the
  SQLite backups.
- Search matches plain text in titles, notes and reminder text; there is no fuzzy matching.
- Alerts depend on macOS as described above; DailyMate cannot wake a sleeping Mac.
- The interface is in English, with Indonesian prayer names (Subuh, Zuhur, Asar, Magrib,
  Isya); there are no translations.
