
import 'dart:async';

extension FutureOrExtension<T> on FutureOr<T> {
  void handle(void action(T value)) {
    final obj = this;
    if (obj is T) {
      action(obj);
    } else {
      obj.then(action);
    }
  }

  FutureOr<R> filter<R>(FutureOr<R> action(T value)) {
    final obj = this;
    if (obj is T) {
      return action(obj);
    } else {
      return obj.then((value) => action(value));
    }
  }
}