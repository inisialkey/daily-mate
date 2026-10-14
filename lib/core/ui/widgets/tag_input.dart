import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/bare_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Tag chips plus an inline field. Enter or comma adds; suggestions come
/// from tags already in use.
class TagInput extends StatefulWidget {
  const TagInput({
    required this.tags,
    required this.suggestions,
    required this.onChanged,
    super.key,
  });

  final List<String> tags;
  final List<String> suggestions;
  final ValueChanged<List<String>> onChanged;

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  void _add(String raw) {
    final tag = raw.replaceAll(',', ' ').trim();
    _controller.clear();
    if (tag.isEmpty) return;
    final exists = widget.tags.any((t) => t.toLowerCase() == tag.toLowerCase());
    if (!exists) widget.onChanged([...widget.tags, tag]);
    _focus.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Wrap(
      spacing: Space.xs,
      runSpacing: Space.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final tag in widget.tags)
          InputChip(
            label: Text('#$tag'),
            onDeleted: () => widget.onChanged([
              for (final t in widget.tags)
                if (t != tag) t,
            ]),
            deleteIcon: const Icon(CupertinoIcons.xmark, size: 10),
            deleteButtonTooltipMessage: 'Remove tag $tag',
          ),
        SizedBox(
          width: 140,
          child: RawAutocomplete<String>(
            textEditingController: _controller,
            focusNode: _focus,
            optionsBuilder: (value) {
              final query = value.text.trim().toLowerCase();
              if (query.isEmpty) return const [];
              return widget.suggestions.where(
                (s) =>
                    s.toLowerCase().contains(query) &&
                    !widget.tags.any((t) => t.toLowerCase() == s.toLowerCase()),
              );
            },
            onSelected: _add,
            fieldViewBuilder: (context, controller, focus, onSubmit) =>
                TextField(
                  controller: controller,
                  focusNode: focus,
                  style: context.text.bodyMedium,
                  decoration: bareDecoration(
                    hintText: 'Add tag',
                    hintStyle: context.text.bodyMedium?.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                  onChanged: (text) {
                    if (text.endsWith(',')) _add(text);
                  },
                  onSubmitted: _add,
                ),
            optionsViewBuilder: (context, onSelected, options) =>
                _Suggestions(options: options, onSelected: onSelected),
          ),
        ),
      ],
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.options, required this.onSelected});

  final Iterable<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topLeft,
    child: Material(
      elevation: 8,
      color: context.colors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(Radii.md),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200, maxWidth: 220),
        child: ListView(
          padding: const EdgeInsets.all(Space.xs),
          shrinkWrap: true,
          children: [
            for (final option in options)
              ListTile(
                title: Text('#$option'),
                onTap: () => onSelected(option),
              ),
          ],
        ),
      ),
    ),
  );
}
