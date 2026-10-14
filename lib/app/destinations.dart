import 'package:flutter/cupertino.dart';

/// Sidebar destinations. The order is the router branch order and the
/// ⌘1…⌘7 shortcut order.
enum AppDestination {
  today('/today', 'Today', CupertinoIcons.sun_max),
  upcoming('/upcoming', 'Upcoming', CupertinoIcons.calendar),
  tasks('/tasks', 'All Tasks', CupertinoIcons.list_bullet),
  notes('/notes', 'Notes', CupertinoIcons.doc_text),
  reminders('/reminders', 'Reminders', CupertinoIcons.bell),
  prayer('/prayer', 'Prayer Times', CupertinoIcons.moon_stars),
  completed('/completed', 'Completed', CupertinoIcons.checkmark_circle),
  settings('/settings', 'Settings', CupertinoIcons.gear);

  const AppDestination(this.path, this.label, this.icon);

  final String path;
  final String label;
  final IconData icon;

  static const List<AppDestination> main = [
    today,
    upcoming,
    tasks,
    notes,
    reminders,
    prayer,
    completed,
  ];

  /// "⌘1" … "⌘7" for main destinations, "⌘," for settings.
  String get shortcutLabel =>
      this == settings ? '⌘,' : '⌘${main.indexOf(this) + 1}';
}
