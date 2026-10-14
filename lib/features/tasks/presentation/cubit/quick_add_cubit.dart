import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_commands.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Backs the quick-add dialog; the dialog itself holds the draft.
class QuickAddCubit extends Cubit<void> with TaskCommands {
  QuickAddCubit(this.tasks) : super(null);

  @override
  final TaskRepository tasks;
}
