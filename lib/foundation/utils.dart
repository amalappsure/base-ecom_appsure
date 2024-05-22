List<List<num>> generatePairsWithInterval(num min, num max, int interval) {
  if (max <= 0) {
    return [];
  }
  List<List<num>> pairs = [];

  for (num i = min; i <= max; i += interval) {
    if (i + interval <= max) {
      pairs.add([i, i + interval]);
    } else {
      pairs.add([i, max]);
    }
  }

  return pairs;
}

String rot13(String input) {
  return input.replaceAllMapped(
    RegExp(r'[a-zA-Z]'),
        (match) {
      String char = match.group(0)!;
      String start = 'a';
      if (char.toUpperCase() == char) {
        start = 'A';
      }
      int offset = char.codeUnitAt(0) - start.codeUnitAt(0);
      int rotated = (offset + 13) % 26;
      return String.fromCharCode(start.codeUnitAt(0) + rotated);
    },
  );
}

String capitalizeFirstLetterOfEachWord(String input) {
  if (input.isEmpty) {
    return input;
  }

  List<String> words = input.split(' ');

  for (int i = 0; i < words.length; i++) {
    if (words[i].isNotEmpty) {
      words[i] = words[i].toLowerCase();
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }
  }

  return words.join(' ');
}
