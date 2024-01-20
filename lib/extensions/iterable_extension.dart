extension IterableX<T> on Iterable<T> {
  Iterable<T> intersperse(T e) sync* {
    final iterator = this.iterator;

    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield e;
        yield iterator.current;
      }
    }
  }
}
