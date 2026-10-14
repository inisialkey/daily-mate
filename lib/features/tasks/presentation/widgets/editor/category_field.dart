import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/bare_decoration.dart';
import 'package:flutter/material.dart';

/// Free-text category with suggestions from categories already in use.
/// Commits on Enter, on picking a suggestion, or when focus leaves.
class CategoryField extends StatefulWidget {
  const CategoryField({
    required this.value,
    required this.suggestions,
    required this.onChanged,
    super.key,
  });

  final String? value;
  final List<String> suggestions;
  final ValueChanged<String?> onChanged;

  @override
  State<CategoryField> createState() => _CategoryFieldState();
}

class _CategoryFieldState extends State<CategoryField> {
  late final _controller = TextEditingController(text: widget.value ?? '');
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) _commit(_controller.text);
    });
  }

  @override
  void didUpdateWidget(CategoryField old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus && _controller.text != (widget.value ?? '')) {
      _controller.text = widget.value ?? '';
    }
  }

  void _commit(String text) {
    final value = text.trim();
    final next = value.isEmpty ? null : value;
    if (next != widget.value) widget.onChanged(next);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RawAutocomplete<String>(
    textEditingController: _controller,
    focusNode: _focus,
    optionsBuilder: (value) {
      final query = value.text.trim().toLowerCase();
      return widget.suggestions.where(
        (s) => s.toLowerCase().contains(query) && s != value.text,
      );
    },
    onSelected: _commit,
    fieldViewBuilder: (context, controller, focus, _) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.sm),
      child: TextField(
        controller: controller,
        focusNode: focus,
        style: context.text.bodyMedium,
        decoration: bareDecoration(
          hintText: 'None',
          hintStyle: context.text.bodyMedium?.copyWith(
            color: context.palette.textMuted,
          ),
        ),
        onSubmitted: _commit,
      ),
    ),
    optionsViewBuilder: (context, onSelected, options) => Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 8,
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(Radii.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 220, maxWidth: 240),
          child: ListView(
            padding: const EdgeInsets.all(Space.xs),
            shrinkWrap: true,
            children: [
              for (final option in options)
                ListTile(title: Text(option), onTap: () => onSelected(option)),
            ],
          ),
        ),
      ),
    ),
  );
}
