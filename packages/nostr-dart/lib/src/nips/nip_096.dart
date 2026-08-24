import 'dart:convert';

/// HTTP File Storage Integration
class Nip96 {
  static ServerAdaptation decodeServerAdaptation(String json) {
    Map<String, dynamic> map = jsonDecode(json);

    String? apiUrl = map['api_url']?.toString();
    String? downloadUrl = map['download_url']?.toString();
    String? delegatedToUrl = map['delegated_to_url']?.toString();

    List<int>? supportedNips = map['supported_nips'] != null
        ? List<int>.from(map['supported_nips'])
        : null;
    String? tosUrl = map['tos_url']?.toString();
    List<String>? contentTypes = map['content_types'] != null
        ? List<String>.from(map['content_types'])
        : null;
    Map<String, dynamic>? freePlans = map['plans']?['free'];

    ServerAdaptationFreePlan? serverAdaptationFreePlan;
    if (freePlans != null) {
      String? name = freePlans['name']?.toString();
      bool? isNip98Required = freePlans['is_nip98_required'];
      String? url = freePlans['url']?.toString();
      int? maxByteSize = freePlans['max_byte_size'];
      List<int>? fileExpiration = freePlans['file_expiration'] != null
          ? List<int>.from(freePlans['file_expiration'])
          : null;
      serverAdaptationFreePlan = ServerAdaptationFreePlan(
          name, isNip98Required, url, maxByteSize, fileExpiration);
    }
    List<ServerAdaptationFreePlan> plans = [];
    if (serverAdaptationFreePlan != null) plans.add(serverAdaptationFreePlan);
    return ServerAdaptation(apiUrl, downloadUrl, delegatedToUrl, supportedNips,
        tosUrl, contentTypes, plans);
  }
}

class ServerAdaptationFreePlan {
  String? name;
  bool? isNip98Required;
  String? url;
  int? maxByteSize;
  List<int>? fileExpiration;

  ServerAdaptationFreePlan(this.name, this.isNip98Required, this.url,
      this.maxByteSize, this.fileExpiration);
}

class ServerAdaptation {
  String? apiURL;
  String? downloadURL;
  String? delegatedToURL;
  List<int>? supportedNips;
  String? tosURL;
  List<String>? contentTypes;
  List<ServerAdaptationFreePlan>? plans;

  ServerAdaptation(this.apiURL, this.downloadURL, this.delegatedToURL,
      this.supportedNips, this.tosURL, this.contentTypes, this.plans);
}
