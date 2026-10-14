/// Stored by index (Drift `intEnum`), so append new values, never reorder.
enum Priority {
  none('None'),
  low('Low'),
  medium('Medium'),
  high('High');

  const Priority(this.label);

  final String label;
}
