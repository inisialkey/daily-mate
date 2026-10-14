import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Selection for task pages, seeded from `?task=<id>` so search results and
/// links can open a task.
mixin RouteTaskSelection<T extends StatefulWidget> on State<T> {
  int? selectedTaskId;
  String? _handledParam;

  void selectTask(int? id) => setState(() => selectedTaskId = id);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final param = GoRouterState.of(context).uri.queryParameters['task'];
    if (param != _handledParam) {
      _handledParam = param;
      final id = int.tryParse(param ?? '');
      if (id != null) selectedTaskId = id;
    }
  }
}
