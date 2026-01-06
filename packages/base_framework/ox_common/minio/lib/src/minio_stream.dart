import 'dart:async';

class MinioByteStream extends StreamView<List<int>> {
  MinioByteStream.fromStream({
    required Stream<List<int>> stream,
    required this.contentLength,
  }) : super(stream);

  final int? contentLength;
}
