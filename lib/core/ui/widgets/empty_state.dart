import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    super.key,
    this.message,
    this.action,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  /// Smaller variant for cards and side panels.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    final action = this.action;
    final badge = compact ? 40.0 : 56.0;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: EdgeInsets.all(compact ? Space.lg : Space.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Container(
                  width: badge,
                  height: badge,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: compact ? IconSizes.lg : IconSizes.xl + 4,
                    color: context.palette.textMuted,
                  ),
                ),
              ),
              SizedBox(height: compact ? Space.sm : Space.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: compact
                    ? context.text.titleSmall
                    : context.text.titleMedium,
              ),
              if (message != null) ...[
                const SizedBox(height: Space.xs),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.palette.textMuted,
                  ),
                ),
              ],
              if (action != null) ...[
                SizedBox(height: compact ? Space.md : Space.lg),
                action,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
