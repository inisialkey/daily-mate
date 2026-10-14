# DailyMate design system

Direction came from the `ui-ux-pro-max` skill (`--design-system`, queries
"personal productivity desktop app tasks notes calm minimal" and "productivity
task manager", Flutter stack and UX searches), then adjusted for a native
macOS app. Code: `lib/core/theme/`.

## Direction

- **Style:** Minimalism & Swiss (both design-system runs agreed): clear type
  hierarchy, generous whitespace, hairline borders instead of shadows, one accent.
- **Product guidance (productivity tool):** clear hierarchy + functional color;
  avoid complex onboarding.
- **Not applied:** the skill's landing-page patterns (hero, testimonials, video)
  and GSAP scroll motion — they target marketing sites, not a desktop tool.

## Color

One accent, teal, used for selection, primary actions and the next prayer.
Status colors appear only where they carry meaning.

| Role | Light | Dark |
|---|---|---|
| Accent (primary) | `#0F766E` (white text 5.5:1) | `#2DD4BF` (dark text) |
| Content surface | `#FFFFFF` | `#17181B` |
| Sidebar | `#F4F5F7` | `#1D1E22` |
| Selection | `#DDF1EE` | `#173A36` |
| Text / secondary / muted | `#111827` / `#4B5563` / `#646B76` | `#ECEDEF` / `#A3A7AF` / `#8C9199` |
| Success / warning / danger | `#15803D` / `#B45309` / `#B91C1C` | `#4ADE80` / `#FBBF24` / `#F87171` |
| Priority high / medium / low | `#DC2626` / `#D97706` / `#2563EB` | `#F87171` / `#FBBF24` / `#60A5FA` |

The skill suggested teal `#0D9488` with black on-primary and an orange CTA
accent; the accent was darkened to `#0F766E` so white button text passes 4.5:1,
and the second accent was dropped (the brief asks for restrained accents).
Muted text is `#646B76` so it stays above 4.5:1 on the gray sidebar too.

## Type

The macOS system font (SF Pro). The skill recommended Plus Jakarta Sans; it was
not adopted because a native feel was an explicit requirement and bundling or
fetching a web font buys nothing offline. Scale (size/line height): page title
28/34 bold, section title 18/24, card title 15/20, body 14/20, meta 12/16,
labels 13 and 12. Tabular figures for times and countdowns.

## Space, shape, motion

- Spacing on a 4-pt rhythm: 4, 8, 12, 16, 24, 32, 48 (`Space`).
- Radii: 6 controls-small, 8 controls, 12 cards, 16 dialogs (`Radii`).
- Icons: Cupertino (SF-Symbols-like) outline set only, 14/16/18/22 (`IconSizes`).
- Motion: 120 ms state changes, 200 ms panels, 280 ms larger moves, ease-out
  cubic (`Motion`). No ink splashes; hover and pressed use a neutral overlay.

## Layout

- Window min 760×560, opens at 1280×820, remembers its frame.
- Transparent title bar; the sidebar reserves 44 pt for the traffic lights and
  every header's empty space drags the window.
- Sidebar 232 pt, collapses to 76 pt icons (⌃⌘S) and automatically below 980 pt.
- Inspector panels 380 pt; they become overlays below 1180 pt.

## Review checklist (from `references/pro-rules.md`, adapted to desktop)

- Text contrast ≥ 4.5:1 in both themes; dividers visible in both.
- Visible keyboard focus on every control; every shortcut has a menu/tooltip.
- Icon-only buttons have tooltips/semantic labels; color never the only signal.
- Pressed and hover states never shift layout.
- Both themes rendered and reviewed (`integration_test/visual_tour_test.dart`).
