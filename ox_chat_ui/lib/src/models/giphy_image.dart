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

  factory GiphyImage.fromJson(Map<String, dynamic> json) => GiphyImage(
        url: json['url'] ?? '',
        name: json['name'] ?? '',
        height: json['width'] ?? '',
        width: json['height'] ?? '',
        size: json['size'] ?? '',
      );

  Map<String, dynamic> toJson(GiphyImage giphyImage) => <String, dynamic>{
        'url': giphyImage.url,
        'name': giphyImage.name,
        'width': giphyImage.width,
        'height': giphyImage.height,
        'size': giphyImage.size,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiphyImage &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;
}
