import 'package:clock/clock.dart';
import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/widgets/key_hint.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/search/presentation/cubit/search_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// ⌘K: search tasks, notes and reminders; ↑/↓ to choose, ↩ to open.
Future<void> showSearchDialog(BuildContext context) => showDialog<void>(
  context: context,
  barrierColor: Colors.black.withValues(alpha: 0.2),
  builder: (_) => BlocProvider(
    create: (_) => sl<SearchCubit>(),
    child: const SearchDialog(),
  ),
);

typedef _Hit = ({IconData icon, String title, String detail, String location});

class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  int _highlight = 0;

  List<(String, List<_Hit>)> _groups(SearchResults r) {
    final today = dateOnly(clock.now());
    return [
      (
        'Tasks',
        [
          for (final t in r.tasks)
            (
              icon: t.isCompleted
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.circle,
              title: t.title,
              detail: t.isCompleted
                  ? 'Completed'
                  : (t.dueDate == null
                        ? 'No date'
                        : formatRelativeDay(t.dueDate!, today)),
              location: '${AppDestination.tasks.path}?task=${t.id}',
            ),
        ],
      ),
      (
        'Notes',
        [
          for (final n in r.notes)
            (
              icon: CupertinoIcons.doc_text,
              title: n.displayTitle,
              detail: n.archived ? 'Archived' : (n.folder ?? 'Note'),
              location: '${AppDestination.notes.path}?note=${n.id}',
            ),
        ],
      ),
      (
        'Reminders',
        [
          for (final rem in r.reminders)
            (
              icon: CupertinoIcons.bell,
              title: rem.title,
              detail: formatWhen(context, rem.startAt, clock.now()),
              location: AppDestination.reminders.path,
            ),
        ],
      ),
    ].where((g) => g.$2.isNotEmpty).toList();
  }

  void _open(_Hit hit) {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.go(hit.location);
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<SearchCubit, SearchResults>(
    builder: (context, results) {
      final groups = _groups(results);
      final hits = [for (final g in groups) ...g.$2];
      final highlight = hits.isEmpty
          ? -1
          : _highlight.clamp(0, hits.length - 1);
      var index = 0;
      return Align(
        alignment: const Alignment(0, -0.6),
        child: Material(
          color: context.colors.surfaceContainerLowest,
          elevation: 16,
          borderRadius: BorderRadius.circular(Radii.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620, maxHeight: 520),
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                    setState(() => _highlight = highlight + 1),
                const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                    setState(
                      () => _highlight = highlight <= 0 ? 0 : highlight - 1,
                    ),
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Space.md),
                    child: TextField(
                      autofocus: true,
                      style: context.text.titleMedium,
                      decoration: const InputDecoration(
                        hintText: 'Search tasks, notes and reminders',
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          size: IconSizes.lg,
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(Space.md),
                          child: KeyHint('esc'),
                        ),
                      ),
                      onChanged: (q) {
                        _highlight = 0;
                        context.read<SearchCubit>().search(q);
                      },
                      onSubmitted: (_) {
                        if (highlight >= 0) _open(hits[highlight]);
                      },
                    ),
                  ),
                  if (results.query.isNotEmpty && results.isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Space.xl,
                        0,
                        Space.xl,
                        Space.xl,
                      ),
                      child: Text(
                        'Nothing matches “${results.query}”.',
                        style: context.text.bodyMedium?.copyWith(
                          color: context.palette.textMuted,
                        ),
                      ),
                    ),
                  if (hits.isNotEmpty)
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(
                          Space.sm,
                          0,
                          Space.sm,
                          Space.md,
                        ),
                        children: [
                          for (final (title, groupHits) in groups) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                Space.md,
                                Space.sm,
                                Space.md,
                                Space.xs,
                              ),
                              child: Text(
                                title,
                                style: context.text.labelMedium?.copyWith(
                                  color: context.palette.textMuted,
                                ),
                              ),
                            ),
                            for (final hit in groupHits)
                              _HitTile(
                                hit: hit,
                                highlighted: index++ == highlight,
                                onTap: () => _open(hit),
                              ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _HitTile extends StatelessWidget {
  const _HitTile({
    required this.hit,
    required this.highlighted,
    required this.onTap,
  });

  final _Hit hit;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: highlighted ? context.palette.selection : Colors.transparent,
    borderRadius: BorderRadius.circular(Radii.md),
    child: InkWell(
      borderRadius: BorderRadius.circular(Radii.md),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.sm,
        ),
        child: Row(
          children: [
            Icon(hit.icon, size: IconSizes.md, color: context.colors.primary),
            const SizedBox(width: Space.md),
            Expanded(
              child: Text(
                hit.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodyMedium,
              ),
            ),
            const SizedBox(width: Space.md),
            Text(
              hit.detail,
              style: context.text.labelMedium?.copyWith(
                color: context.palette.textMuted,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
