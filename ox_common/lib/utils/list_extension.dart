
extension IterableExtensions<T> on Iterable<T?> {
  Iterable<T> whereNotNull() {
    return this.where((element) => element != null).cast<T>();
  }
}

extension ListEx<T> on List<T> {
  /// Inserts an element into the list at every N-th position.
  ///
  /// This method takes an integer `n` and an element `element`, and inserts `element`
  /// into the list at every N-th position. Note that this method does not insert
  /// the element after the last element of the list.
  ///
  /// ```dart
  /// List<int> originalList = [1, 2, 3, 4, 5, 6];
  /// List<int> modifiedList = originalList.insertEveryN(2, 99);
  /// // modifiedList: [1, 2, 99, 3, 4, 99, 5, 6]
  /// ```
  ///
  /// Parameters:
  /// - [n]: An integer representing the interval at which to insert [element].
  /// - [element]: The element to be inserted.
  ///
  /// Returns:
  /// - A new list with the elements inserted at every N-th position.
  List<T> insertEveryN(int n, T element) {
    List<T> result = [];
    for (int i = 0; i < this.length; i++) {
      result.add(this[i]);
      if ((i + 1) % n == 0 && i != this.length - 1) {
        result.add(element);
      }
    }
    return result;
  }

  List<T> removeDuplicates(dynamic Function(T) keySelector) {
    List<T> uniqueList = [];
    Set<dynamic> seenKeys = {};

    for (var item in this) {
      var key = keySelector(item);
      if (!seenKeys.contains(key)) {
        seenKeys.add(key);
        uniqueList.add(item);
      }
    }

    return uniqueList;
  }
}