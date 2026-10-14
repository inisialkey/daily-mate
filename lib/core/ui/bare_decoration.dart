import 'package:flutter/material.dart';

/// Decoration for text edited in place (titles, notes, checklist items):
/// no fill, no border in any state. `InputDecoration.collapsed` alone still
/// inherits the theme's enabled/focused borders.
InputDecoration bareDecoration({String? hintText, TextStyle? hintStyle}) =>
    InputDecoration(
      isCollapsed: true,
      hintText: hintText,
      hintStyle: hintStyle,
      filled: false,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );
