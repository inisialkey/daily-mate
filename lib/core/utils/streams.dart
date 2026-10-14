import 'dart:async';

/// Emits [combine] of the latest values once both streams have emitted.
Stream<R> combineLatest2<A, B, R>(
  Stream<A> first,
  Stream<B> second,
  R Function(A a, B b) combine,
) {
  late final StreamController<R> controller;
  StreamSubscription<A>? subA;
  StreamSubscription<B>? subB;
  (A,)? lastA;
  (B,)? lastB;

  void emit() {
    if (lastA case (final a,)) {
      if (lastB case (final b,)) controller.add(combine(a, b));
    }
  }

  controller = StreamController<R>(
    onListen: () {
      subA = first.listen((value) {
        lastA = (value,);
        emit();
      }, onError: controller.addError);
      subB = second.listen((value) {
        lastB = (value,);
        emit();
      }, onError: controller.addError);
    },
    onCancel: () async {
      await subA?.cancel();
      await subB?.cancel();
    },
  );
  return controller.stream;
}

/// Re-subscribes to [select]'s stream for every value of [source]
/// (`switchMap`): the previous inner subscription is cancelled first.
Stream<R> switchMap<T, R>(Stream<T> source, Stream<R> Function(T) select) {
  late final StreamController<R> controller;
  StreamSubscription<T>? outer;
  StreamSubscription<R>? inner;
  controller = StreamController<R>(
    onListen: () {
      outer = source.listen((value) async {
        await inner?.cancel();
        inner = select(value).listen(
          controller.add,
          onError: controller.addError,
        );
      }, onError: controller.addError);
    },
    onCancel: () async {
      await inner?.cancel();
      await outer?.cancel();
    },
  );
  return controller.stream;
}

/// Emits every event of every stream in [streams].
Stream<T> mergeStreams<T>(List<Stream<T>> streams) {
  late final StreamController<T> controller;
  final subscriptions = <StreamSubscription<T>>[];
  controller = StreamController<T>(
    onListen: () {
      for (final stream in streams) {
        subscriptions.add(
          stream.listen(controller.add, onError: controller.addError),
        );
      }
    },
    onCancel: () => Future.wait([for (final s in subscriptions) s.cancel()]),
  );
  return controller.stream;
}
