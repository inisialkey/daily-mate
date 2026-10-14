/// Editors with debounced saves register their flush here, so leaving the
/// window or quitting the app writes pending text first.
class PendingWrites {
  final Set<Future<void> Function()> _flushers = {};

  void register(Future<void> Function() flush) => _flushers.add(flush);

  void unregister(Future<void> Function() flush) => _flushers.remove(flush);

  Future<void> flushAll() =>
      Future.wait([for (final flush in _flushers.toList()) flush()]);
}
