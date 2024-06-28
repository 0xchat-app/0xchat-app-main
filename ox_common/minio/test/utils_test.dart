import 'dart:typed_data';

import 'package:minio/src/utils.dart';
import 'package:test/test.dart';

void main() {
  testRfc7231Time();
  testBlockStream();
}

void testRfc7231Time() {
  final time = DateTime(2017, 8, 11, 19, 34, 18);
  final timeString = 'Fri, 11 Aug 2017 19:34:18';

  final timeUtc = DateTime.utc(2017, 8, 11, 19, 34, 18);
  final timeStringUtc = 'Fri, 11 Aug 2017 19:34:18 GMT';

  group('parseRfc7231Time', () {
    test('works', () {
      expect(parseRfc7231Time(timeString), equals(time));
      expect(parseRfc7231Time(timeString).isUtc, isFalse);
    });

    test('works for GMT time', () {
      expect(parseRfc7231Time(timeStringUtc), equals(timeUtc));
      expect(parseRfc7231Time(timeStringUtc).isUtc, isTrue);
    });
  });

  group('toRfc7231Time', () {
    test('works', () {
      expect(toRfc7231Time(time), equals(timeString));
    });

    test('works for GMT time', () {
      expect(toRfc7231Time(timeUtc), equals(timeStringUtc));
    });
  });
}

void testBlockStream() {
  test('MaxChunkSize works', () async {
    final streamData = [
      Uint8List.fromList([1, 2]),
      Uint8List.fromList([3, 4, 5, 6]),
      Uint8List.fromList([7, 8, 9]),
      Uint8List.fromList([10, 11, 12, 13]),
    ];

    final stream = Stream.fromIterable(streamData).transform(MaxChunkSize(3));

    expect(
      await stream.toList(),
      equals([
        Uint8List.fromList([1, 2]),
        Uint8List.fromList([3, 4, 5]),
        Uint8List.fromList([6]),
        Uint8List.fromList([7, 8, 9]),
        Uint8List.fromList([10, 11, 12]),
        Uint8List.fromList([13]),
      ]),
    );
  });

  test('MinChunkSize works', () async {
    final streamData = [
      Uint8List.fromList([1, 2]),
      Uint8List.fromList([3, 4, 5, 6]),
      Uint8List.fromList([7, 8, 9]),
      Uint8List.fromList([10, 11, 12, 13]),
    ];

    final stream = Stream.fromIterable(streamData).transform(MinChunkSize(5));

    expect(
      await stream.toList(),
      equals([
        Uint8List.fromList([1, 2, 3, 4, 5, 6]),
        Uint8List.fromList([7, 8, 9, 10, 11, 12, 13]),
      ]),
    );
  });

  test('MinChunkSize with empty stream', () async {
    final stream = Stream<Uint8List>.empty().transform(MinChunkSize(5));
    expect(await stream.toList(), equals([Uint8List.fromList([])]));
  });

  test('MinChunkSize with zero length stream', () async {
    final stream = Stream.value(Uint8List(0)).transform(MinChunkSize(5));
    expect(await stream.toList(), equals([Uint8List.fromList([])]));
  });
}
