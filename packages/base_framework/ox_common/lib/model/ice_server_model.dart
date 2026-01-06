class ICEServerModel {
  String url;
  bool canDelete;
  int createTime;

  ICEServerModel({
    this.url = '',
    this.canDelete = true,
    this.createTime = 0,
  });

  List<Map<String, String>> get serverConfig {
    if(isTurnAddress){
      return [
        {
          'urls': 'turn:$domain',
          'username': this.username,
          'credential': this.credential
        },
        {
          'url': 'stun:$domain',
        },
      ];
    }else {
      return [{
        'url': this.url,
      }];
    }
  }

  bool get isTurnAddress => url.startsWith('turn');

  String get username{
    if(isTurnAddress){
      var credentialsPart = url.split('@')[0];
      return credentialsPart.split(':')[1];
    }else{
      return '';
    }
  }

  String get credential{
    if(isTurnAddress){
      var credentialsPart = url.split('@')[0];
      return credentialsPart.split(':')[2];
    }else{
      return '';
    }
  }

  String get host => isTurnAddress ? domain.split(':')[0] : url;

  /// Get display name for the server (e.g., rtc1, rtc3, rtc4 instead of IP)
  String get displayName {
    if (!isTurnAddress) return url;
    final hostPart = domain.split(':')[0];
    
    // Map IP addresses to friendly names
    switch (hostPart) {
      case '52.76.210.159':
        return 'rtc1.0xchat.com';
      case '13.213.17.140':
        return 'rtc3.0xchat.com';
      case '15.222.242.167':
        return 'rtc4.0xchat.com';
      default:
        return hostPart;
    }
  }

  String get domain => (isTurnAddress && url.contains('@')) ? url.split('@')[1] : url;

  factory ICEServerModel.fromJson(Map<String, dynamic> json) {
    return ICEServerModel(
      url: json['url'] ?? '',
      canDelete: json['canDelete'] ?? true,
      createTime: json['createTime'] ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ICEServerModel &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;

  Map<String, dynamic> toJson(ICEServerModel iceServerModel) =>
      <String, dynamic>{
        'url': iceServerModel.url,
        'canDelete': iceServerModel.canDelete,
        'createTime': iceServerModel.createTime,
      };

  static List<ICEServerModel> get defaultICEServers => [
    ICEServerModel(
      url: 'turn:0xchat:Prettyvs511@52.76.210.159:5349',
      createTime: DateTime.now().millisecondsSinceEpoch,
    ),
    // ICEServerModel(
    //   url: 'turn:0xchat:Prettyvs511@rtc2.0xchat.com:5349',
    //   createTime: DateTime.now().millisecondsSinceEpoch,
    // ),
    ICEServerModel(
      url: 'turn:0xchat:Prettyvs511@13.213.17.140:5349',
      createTime: DateTime.now().millisecondsSinceEpoch,
    ),
    ICEServerModel(
      url: 'turn:0xchat:Prettyvs511@15.222.242.167:5349',
      createTime: DateTime.now().millisecondsSinceEpoch,
    ),
    // ICEServerModel(
    //   url: 'turn:0xchat:Prettyvs511@rtc5.0xchat.com:5349',
    //   createTime: DateTime.now().millisecondsSinceEpoch,
    // ),
    // ICEServerModel(
    //   url: 'turn:0xchat:Prettyvs511@rtc6.0xchat.com:5349',
    //   createTime: DateTime.now().millisecondsSinceEpoch,
    // ),
  ];
}
