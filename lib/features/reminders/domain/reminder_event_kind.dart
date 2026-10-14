/// Stored by name (Drift `textEnum`).
enum ReminderEventKind {
  due('Due'),
  snoozed('Snoozed'),
  done('Done'),
  dismissed('Dismissed');

  const ReminderEventKind(this.label);

  final String label;
}
