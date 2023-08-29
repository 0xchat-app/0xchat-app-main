class GiphyImage {
  final String url;
  final String name;
  final String? width;
  final String? height;
  final String? size;

  GiphyImage({
    required this.url,
    required this.name,
    this.height,
    this.width,
    this.size
  });
}
