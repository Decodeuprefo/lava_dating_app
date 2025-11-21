import 'dart:math' as math;

import 'package:flutter/services.dart';

class NoEmojisFormatter extends TextInputFormatter {
  // Regular expression to match emojis
  static final RegExp _emojiRegExp = RegExp(
    r'[^\p{L}\p{N}\p{P}\p{Zs}]',
    unicode: true,
  );

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove emojis from the input
    final String newText = newValue.text.replaceAll(_emojiRegExp, '');
    return newValue.copyWith(
      text: newText,
      selection: newValue.selection.copyWith(
        baseOffset: newText.length,
        extentOffset: newText.length,
      ),
    );
  }
}

class CustomFormatterForSpaceAndEmoji extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // A more comprehensive regex for emojis
    final RegExp emojiRegex = RegExp(
        r'[\u{1F600}-\u{1F64F}' // Emoticons
        r'\u{1F300}-\u{1F5FF}' // Symbols & Pictographs
        r'\u{1F680}-\u{1F6FF}' // Transport & Map Symbols
        r'\u{1F1E0}-\u{1F1FF}' // Flags (iOS)
        r'\u{2600}-\u{26FF}' // Miscellaneous Symbols
        r'\u{2700}-\u{27BF}' // Dingbats
        r'\u{FE0F}' // Variation Selectors
        r'\u{1F900}-\u{1F9FF}' // Supplemental Symbols and Pictographs
        r'\u{1FA70}-\u{1FAFF}' // Symbols and Pictographs Extended-A
        r'\u{200D}' // Zero Width Joiner
        r'\u{1F004}' // Mahjong Tile Red Dragon
        r'\u{1F0CF}' // Playing Card Black Joker
        ']+',
        unicode: true,
        dotAll: true);

    // Remove spaces and emojis from the input text
    String newText = newValue.text.replaceAll(' ', '').replaceAll(emojiRegex, '');

    // Calculate the cursor's new offset
    int newOffset = newValue.selection.end - (newValue.text.length - newText.length);

    // Return the modified value while preserving the calculated cursor position
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: math.min(newText.length, newOffset),
      ),
    );
  }
}
