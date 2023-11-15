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

  static List<ICEServerModel> get defaultICEServers => List.from([
        // ICEServerModel(
        //   url: 'stun:stun.l.google.com:19302',
        //   createTime: DateTime.now().millisecondsSinceEpoch,
        // ),
        ICEServerModel(
          url: 'turn:0xchat:Prettyvs511@rtc.0xchat.com:5349',
          createTime: DateTime.now().millisecondsSinceEpoch,
        ),
        ICEServerModel(
          url: 'turn:0xchat:Prettyvs511@rtc2.0xchat.com:5349',
          createTime: DateTime.now().millisecondsSinceEpoch,
        ),ICEServerModel(
          url: 'turn:0xchat:Prettyvs511@rtc3.0xchat.com:5349',
          createTime: DateTime.now().millisecondsSinceEpoch,
        ),ICEServerModel(
          url: 'turn:0xchat:Prettyvs511@rtc4.0xchat.com:5349',
          createTime: DateTime.now().millisecondsSinceEpoch,
        ),ICEServerModel(
          url: 'turn:0xchat:Prettyvs511@rtc5.0xchat.com:5349',
          createTime: DateTime.now().millisecondsSinceEpoch,
        ),ICEServerModel(
          url: 'turn:0xchat:Prettyvs511@rtc6.0xchat.com:5349',
          createTime: DateTime.now().millisecondsSinceEpoch,
        ),
      ]);
}
