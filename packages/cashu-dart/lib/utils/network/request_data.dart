
enum RequestMethod {
  get,
  post,
}

extension RequestMethodEx on RequestMethod {
  String get text {
    switch (this) {
      case RequestMethod.get: return 'GET';
      case RequestMethod.post: return 'POST';
    }
  }
}

class RequestData {
  RequestData({
    required this.url,
    required this.method,
    required this.headers,
    this.queryParams,
    this.body,
  }) : uri = _buildUri(url, queryParams);

  final String url;
  final RequestMethod method;
  final Map<String, String> headers;
  final Map<String, dynamic>? queryParams;
  final dynamic body;
  final Uri uri;

  static Uri _buildUri(String url, Map<String, dynamic>? queryParams) {
    var uri = Uri.parse(url);

    if (queryParams == null || queryParams.isEmpty) {
      return uri;
    }

    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        ...queryParams,
      },
    );
  }

  @override
  String toString() {
    return uri.toString();
  }

  RequestData copyWith({
    String? url,
    RequestMethod? method,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    dynamic body,
  }) => RequestData(
    url: url ?? this.url,
    method: method ?? this.method,
    headers: headers ?? this.headers,
    queryParams: queryParams ?? this.queryParams,
    body: body ?? this.body,
  );
}