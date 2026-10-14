import 'dart:async';

import 'package:daily_mate/core/errors/validation_exception.dart';
import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:flutter/material.dart';

/// Shortens [title] for confirmations: “Water the plants…”.
String quoted(String title, {int max = 40}) {
  final short = title.length > max
      ? '${title.substring(0, max).trimRight()}…'
      : title;
  return '“$short”';
}

/// Runs a user-triggered change and reports the outcome in one place:
/// an optional confirmation with Undo, the validation message, or a
/// generic failure (logged with its stack). Returns whether it succeeded.
Future<bool> runAction(
  BuildContext context,
  Future<void> Function() action, {
  String? success,
  Future<void> Function()? undo,
}) async {
  final messenger = context.mounted ? ScaffoldMessenger.maybeOf(context) : null;
  void show(String text, {SnackBarAction? snackAction}) => messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), action: snackAction));

  try {
    await action();
    if (success != null) {
      show(
        success,
        snackAction: undo == null
            ? null
            : SnackBarAction(
                label: 'Undo',
                onPressed: () => unawaited(undo()),
              ),
      );
    }
    return true;
  } on ValidationException catch (error) {
    show(error.message);
  } on Exception catch (error, stack) {
    AppLogger.e('Action failed', error, stack);
    show("Couldn't save that change. Nothing was lost — please try again.");
  }
  return false;
}
