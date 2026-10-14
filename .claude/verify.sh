#!/usr/bin/env bash
# The gate. A change is not done until this exits 0.
# Runs automatically at the end of every turn that edited a file (harness plugin).
# Run it yourself any time: bash .claude/verify.sh
#
# It runs with the session's shell environment, unattended, as soon as the repo has it: the
# harness extends its own trust to this file. Review a change here like a change to a
# pre-commit hook. It is tamper-evident — a turn that edits it is blocked once and logged.
#
# The harness passes the turn's edited paths in CLAUDE_CHANGED_FILES (newline
# separated, repo-relative). Set = a hook run, scoped to those paths.
# Unset = a manual run, or a turn that edited through Bash — everything runs.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."   # .claude/verify.sh -> project root, monorepo-safe

FLUTTER="${FLUTTER:-flutter}"
DART="${DART:-dart}"
# fvm pins the SDK for BOTH binaries. A global `dart format` formats with whatever SDK is
# on PATH — Dart 3.7 changed the formatter's style, so the gate and CI's
# `dart format --set-exit-if-changed` would disagree on every file.
# Only when fvm is actually installed. A hosted CI agent has .fvmrc and no fvm; without the
# `command -v` guard the gate died there on `fvm: command not found` while passing on every
# developer machine. CI installs the version .fvmrc names, so the formatter still matches —
# that equivalence is the only thing this pin protects.
if [ -f .fvmrc ] && command -v fvm >/dev/null 2>&1; then FLUTTER="fvm flutter"; DART="fvm dart"; fi

# --- Collect the changed Dart files, minus generated ones (machine-owned) -------
# ponytail: no mapfile/readarray — macOS ships bash 3.2 and both are bash 4+.
CHANGED=""
TOOLING=0   # analyzer/deps config changed -> analysis can shift project-wide
L10N=0      # an .arb or l10n.yaml changed -> the generated strings are stale
while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$f" in
    *.g.dart|*.freezed.dart|*.config.dart) continue ;;
    *.dart) [ -f "$f" ] && CHANGED="$CHANGED $f" ;;
    *.arb) L10N=1 ;;
    l10n.yaml) TOOLING=1; L10N=1 ;;
    pubspec.yaml|pubspec.lock|analysis_options.yaml|build.yaml) TOOLING=1 ;;
  esac
done <<< "${CLAUDE_CHANGED_FILES:-}"

# --- 0. A turn that touched nothing Dart-relevant has nothing to verify --------
# Distinguish set-but-irrelevant (docs/CI/asset edits — skip everything) from
# unset (manual run — run everything). Without this, every README edit paid a
# project-wide format + analyze + the FULL test suite.
if [ -n "${CLAUDE_CHANGED_FILES+x}" ] && [ -z "$CHANGED" ] && [ "$TOOLING" -eq 0 ] && [ "$L10N" -eq 0 ]; then
  exit 0
fi

# --- 1. Leftover debug instrumentation is a failure, not a warning --------------
if [ -n "$CHANGED" ] && grep -l '\[DEBUG-' $CHANGED 2>/dev/null; then
  echo "^ leftover [DEBUG- instrumentation. Remove it before finishing." >&2
  exit 1
fi

# --- 2. Banned imports — the dependency rule and the Either library ------------
# The same greps CI runs (github-actions/pr.yml), moved to the end of the turn.
# On a PR they fire minutes later, once the agent that broke the rule is gone; here
# it is still around to fix it. grep over lib/ is cheap, so this is not scoped.
BOUNDARY=0

# A grep whose glob matches nothing exits 2, and `if` reads that as "clean". The two checks
# below would then pass green forever without ever having looked at anything — the same
# could-never-fire shape the kit deleted from its own CI. Measured across the repos this
# template was written for: 4 of 6 name the layer `presentation`, 2 name it `pages`, so this
# is not hypothetical. Fail loudly rather than silently enforcing nothing.
if [ -d lib/features ] && ! ls -d lib/features/*/presentation >/dev/null 2>&1; then
  echo "lib/features/ exists but no lib/features/*/presentation — the dependency-rule checks" >&2
  echo "below cannot match anything and would pass green forever." >&2
  echo "FIX: this repo names the layer something else (commonly pages/). Change 'presentation'" >&2
  echo "to that name in the two greps here AND in the CI copy, so both tell the same story." >&2
  exit 1
fi

if grep -RInE "import .*/data/" lib/features/*/presentation 2>/dev/null; then
  echo "^ presentation imports data/ — route through domain (UseCase/Repository)." >&2
  BOUNDARY=1
fi
if grep -RInE "import 'package:(flutter|dio|http)/|dart:io|import 'dart:convert'" lib/features/*/domain 2>/dev/null; then
  echo "^ domain imports a framework/IO package — domain is pure Dart." >&2
  BOUNDARY=1
fi
# One Either library, everywhere. Two in one codebase is the actual failure mode:
# `Either` resolves to whichever was imported, and a repository returning the other
# library's Left type is a compile error nobody can read. dartz is also unmaintained.
#
# Adopting a repo that already has dartz? This fires on every file at once. Do NOT
# comment it out: a disabled check is dead code waiting on a TODO nobody pays, and the
# repo then spends the whole migration with no guard at all. INVERT it — swap the
# pattern to `package:fpdart/` and the message to say dartz is the one library until
# the migration lands. The rule still guards exactly what it exists for, a second
# Either library, just from the other direction; it flips back on the commit that
# migrates; and nothing is left commented out. Mirror the inversion in CI so the two
# copies never tell different stories.
if grep -RIn "package:dartz/" lib 2>/dev/null; then
  echo "^ dartz is banned — this workflow uses fpdart. Swap the import; Either/Left/Right/fold are spelled the same." >&2
  BOUNDARY=1
fi
[ "$BOUNDARY" -eq 0 ] || exit 1

# --- 3. Format (fix, do not fail) ----------------------------------------------
if [ -n "$CHANGED" ]; then
  $DART format $CHANGED
elif [ -z "${CLAUDE_CHANGED_FILES+x}" ]; then
  # Generated files are excluded here for the same reason the collect loop above skips them:
  # they are machine-owned. `dart format .` reached every one of them, and where a repo commits
  # its generated output that is a standing fight, not a cosmetic difference — build_runner
  # writes those files with the dart_style its own dependencies pin, the SDK formats with the
  # pinned SDK's, and each run undoes the other. Measured on the fourth consumer pilot:
  # `dart format .` rewrites 416 files, 349 of them generated, and the next build_runner run
  # puts all 349 back. Keep this pattern list in step with the collect loop's.
  # Hidden directories and build/ are pruned because `dart format .` skipped them too;
  # `-exec ... +` runs nothing at all when nothing matches.
  find . -path './.*' -prune -o -path './build' -prune -o \
    -name '*.dart' ! -name '*.g.dart' ! -name '*.freezed.dart' ! -name '*.config.dart' \
    -exec $DART format {} +
fi

# --- 4. Generated code the analyzer needs, when the repo does not commit it -----
# `flutter analyze` cannot resolve a symbol whose source has not been generated yet.
# Where that output is git-ignored, a fresh clone and every CI agent fail here while the
# machine that last ran the generator by hand stays green — a gate that passes only
# where someone already did the work is a check that never fires, one step earlier.
# Measured on the three repos this template was written for: all three git-ignore their
# gen-l10n output, and all three had to add this step to their gate by hand.
#
# Not on every turn: regenerate when an .arb changed, on an unscoped run, or when the
# output directory is missing (a fresh clone). A Dart-only edit pays nothing. The output
# directory is read from l10n.yaml rather than hardcoded, so this needs no editing.
if [ -f l10n.yaml ]; then
  L10N_OUT=$(sed -n 's|^[[:space:]]*output-dir:[[:space:]]*\([^[:space:]#]*\).*|\1|p' l10n.yaml | head -1)
  if [ "$L10N" -eq 1 ] || [ -z "${CLAUDE_CHANGED_FILES+x}" ] || { [ -n "$L10N_OUT" ] && [ ! -d "$L10N_OUT" ]; }; then
    $FLUTTER gen-l10n
  fi
fi
# build_runner is deliberately NOT here. Two of those three repos commit their *.g.dart
# and *.freezed.dart, so the generator has nothing to add to a gate run and about 30 s to
# add to its cost; there, CI's staleness check — regenerate, then `git diff --exit-code` —
# is what catches a stale commit. Add it here only when the repo git-ignores that output,
# because then the analyzer genuinely cannot run without it:
#   $DART run build_runner build --delete-conflicting-outputs

# --- 5. Analyze — always project-wide, at CI strictness -------------------------
# Dart analysis is project-scoped: a change in one file can only be judged against
# the whole program, so there is nothing to narrow here. --fatal-infos matches
# pr.yml; without it an info-level lint passes this gate and fails CI minutes
# later, once the agent that wrote it is gone.
$FLUTTER analyze --fatal-infos

# --- 6. Test — scoped to what changed ------------------------------------------
# lib/x.dart -> test/x_test.dart when the mirror exists; an edited test runs itself;
# a lib file with no mirror adds no target (analyze still gates it).
# ponytail: a TOOLING-only change (pubspec bump) runs analyze, not the full suite —
# a behavior-only dep break rides to CI. Full tests on every pubspec touch was the
# old cost bug in reverse.
TARGETS=""
for f in $CHANGED; do
  case "$f" in
    test/*_test.dart) TARGETS="$TARGETS $f" ;;
    lib/*.dart)
      mirror="test/${f#lib/}"
      mirror="${mirror%.dart}_test.dart"
      [ -f "$mirror" ] && TARGETS="$TARGETS $mirror"
      ;;
  esac
done

if [ -z "${CLAUDE_CHANGED_FILES+x}" ]; then
  $FLUTTER test                      # manual run: everything
elif [ -n "$TARGETS" ]; then
  # shellcheck disable=SC2086
  $FLUTTER test $(printf '%s\n' $TARGETS | sort -u | tr '\n' ' ')
fi

# Add as the project grows:
#   dart pub global run import_lint   — resolves imports properly, so it sees the
#     aliased and transitive violations step 2's grep cannot. Worth it once the
#     feature count makes grep's blind spots likely.
