List<T> shuffleNoAdjacentDuplicates<T>(List<T> items, String Function(T) key) {
  if (items.length < 2) return [...items];
  final list = [...items]..shuffle();
  for (int i = 0; i < list.length; i++) {
    final nextIdx = (i + 1) % list.length;
    if (key(list[i]) == key(list[nextIdx])) {
      for (int j = (nextIdx + 1) % list.length;
          j != i;
          j = (j + 1) % list.length) {
        final prevIdx = (nextIdx - 1 + list.length) % list.length;
        if (key(list[j]) != key(list[i]) &&
            key(list[j]) != key(list[prevIdx])) {
          final tmp = list[nextIdx];
          list[nextIdx] = list[j];
          list[j] = tmp;
          break;
        }
      }
    }
  }
  return list;
}
