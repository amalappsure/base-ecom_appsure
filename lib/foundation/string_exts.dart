extension StringExtension on String {
  String mask(String maskCharacter) {
    final List<String> maskedString = [];
    for (int i = 0; i < length; i++) {
      maskedString.add(maskCharacter);
    }

    return maskedString.join();
  }

  String? get capitalizeFirst {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension NullStringExtension on String? {
  String? get nullIfEmpty {
    if (this == null) {
      return null;
    }
    if (this!.isEmpty) {
      return null;
    }
    return this;
  }
}
