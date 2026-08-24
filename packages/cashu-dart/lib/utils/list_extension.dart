
extension ListEx<T> on List<T> {
  List<List<T>> toChunks(int size) {
    final arr = [...this];
    List<List<T>> chunks = [];
    for (int i = 0; i < arr.length; i += size) {
      int end = i + size < arr.length ? i + size : arr.length;
      chunks.add(arr.sublist(i, end));
    }
    return chunks;
  }

  Map<Key, List<T>> groupBy<Key>(Key Function(T item) keyBuilder) {
    return fold(<Key, List<T>>{}, (map, element) {
      final key = keyBuilder(element);
      map.putIfAbsent(key, () => []).add(element);
      return map;
    });
  }
}