import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/app/shell/sidebar_item.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/widgets/window_drag_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    required this.current,
    required this.collapsed,
    required this.onSelect,
    super.key,
    this.onToggle,
    this.onSearch,
    this.onNewTask,
    this.badges = const {},
    this.captions = const {},
  });

  final AppDestination current;
  final bool collapsed;
  final ValueChanged<AppDestination> onSelect;

  /// Null when the window is too narrow to expand the sidebar.
  final VoidCallback? onToggle;
  final VoidCallback? onSearch;
  final VoidCallback? onNewTask;
  final Map<AppDestination, int> badges;
  final Map<AppDestination, String> captions;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedContainer(
      duration: Motion.of(context, Motion.medium),
      curve: Motion.curve,
      width: collapsed ? Dimens.sidebarCollapsedWidth : Dimens.sidebarWidth,
      decoration: BoxDecoration(
        color: palette.sidebar,
        border: Border(right: BorderSide(color: palette.sidebarBorder)),
      ),
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) =>
              _content(context, showLabel: constraints.maxWidth > 150),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, {required bool showLabel}) {
    final onSearch = this.onSearch;
    final onNewTask = this.onNewTask;
    final onToggle = this.onToggle;
    Widget destination(AppDestination d) => SidebarItem(
      icon: d.icon,
      label: d.label,
      shortcut: d.shortcutLabel,
      selected: d == current,
      showLabel: showLabel,
      badge: badges[d],
      caption: captions[d],
      onTap: () => onSelect(d),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Room for the traffic lights; drags the window like a title bar.
        const SizedBox(height: 44, child: WindowDragArea()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (onSearch != null)
                SidebarItem(
                  icon: CupertinoIcons.search,
                  label: 'Search',
                  shortcut: '⌘K',
                  showLabel: showLabel,
                  onTap: onSearch,
                ),
              if (onNewTask != null)
                SidebarItem(
                  icon: CupertinoIcons.plus_circle_fill,
                  label: 'New Task',
                  shortcut: '⌘N',
                  showLabel: showLabel,
                  emphasized: true,
                  onTap: onNewTask,
                ),
            ],
          ),
        ),
        const SizedBox(height: Space.md),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: Space.md),
            children: [
              for (final d in AppDestination.main) ...[
                destination(d),
                const SizedBox(height: Space.xxs),
              ],
            ],
          ),
        ),
        Divider(color: context.palette.sidebarBorder),
        Padding(
          padding: const EdgeInsets.all(Space.md),
          child: showLabel
              ? Row(
                  children: [
                    Expanded(child: destination(AppDestination.settings)),
                    if (onToggle != null)
                      _ToggleButton(collapsed: collapsed, onPressed: onToggle),
                  ],
                )
              : Column(
                  children: [
                    destination(AppDestination.settings),
                    if (onToggle != null)
                      _ToggleButton(collapsed: collapsed, onPressed: onToggle),
                  ],
                ),
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.collapsed, required this.onPressed});

  final bool collapsed;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: collapsed ? 'Show sidebar  ⌃⌘S' : 'Hide sidebar  ⌃⌘S',
    onPressed: onPressed,
    icon: const Icon(CupertinoIcons.sidebar_left),
  );
}
