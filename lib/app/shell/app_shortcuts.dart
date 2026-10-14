import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// App-wide keyboard shortcuts that work wherever focus is — including
/// when it has fallen back to the window's root scope, which focus-based
/// `Shortcuts` never hear. Ignored while a dialog covers the window.
class AppShortcuts extends StatefulWidget {
  const AppShortcuts({required this.bindings, required this.child, super.key});

  final Map<SingleActivator, VoidCallback> bindings;
  final Widget child;

  @override
  State<AppShortcuts> createState() => _AppShortcutsState();
}

class _AppShortcutsState extends State<AppShortcuts> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handle);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handle);
    super.dispose();
  }

  bool _handle(KeyEvent event) {
    if (event is! KeyDownEvent || !mounted) return false;
    if (!(ModalRoute.of(context)?.isCurrent ?? true)) return false;
    final keyboard = HardwareKeyboard.instance;
    for (final entry in widget.bindings.entries) {
      final activator = entry.key;
      if (activator.trigger == event.logicalKey &&
          activator.meta == keyboard.isMetaPressed &&
          activator.shift == keyboard.isShiftPressed &&
          activator.control == keyboard.isControlPressed &&
          activator.alt == keyboard.isAltPressed) {
        entry.value();
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
