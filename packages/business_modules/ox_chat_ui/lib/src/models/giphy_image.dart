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

  String get uniqueUrl {
    final index = this.url.indexOf('?');
    return index == -1 ? this.url : this.url.substring(0, index);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiphyImage &&
          runtimeType == other.runtimeType &&
          uniqueUrl == other.uniqueUrl;

  @override
  int get hashCode => url.hashCode;
}
