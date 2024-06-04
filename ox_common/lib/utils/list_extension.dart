
extension ListEx on List {
  List<T> insertEveryN<T>(int n, T element) {
    List<T> result = [];
    for (int i = 0; i < this.length; i++) {
      result.add(this[i]);
      if ((i + 1) % n == 0 && i != this.length - 1) {
        result.add(element);
      }
    }
    return result;
  }
}