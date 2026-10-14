import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/widgets/window_drag_area.dart';
import 'package:flutter/material.dart';

/// Title block at the top of every page. Its empty space drags the window.
class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.actions = const [],
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  /// Optional row under the title (filters, tabs, date navigation).
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    final bottom = this.bottom;
    return Stack(
      children: [
        const Positioned.fill(child: WindowDragArea()),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.xxl,
            Dimens.titleBarHeight + Space.sm,
            Space.xl,
            Space.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: IgnorePointer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(
                              title,
                              style: context.text.displaySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: Space.xxs),
                            Text(
                              subtitle,
                              style: context.text.bodyMedium?.copyWith(
                                color: context.palette.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  for (final action in actions) ...[
                    const SizedBox(width: Space.sm),
                    action,
                  ],
                ],
              ),
              if (bottom != null) ...[
                const SizedBox(height: Space.md),
                bottom,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
