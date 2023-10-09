class ICEServerModel {
  String url;
  bool canDelete;
  int createTime;

  ICEServerModel({
    this.url = '',
    this.canDelete = false,
    this.createTime = 0,
  });

  Map<String, String> get serverConfig => <String, String>{
        'url': this.url,
      };

  factory ICEServerModel.fromJson(Map<String, dynamic> json) {
    return ICEServerModel(
      url: json['url'] ?? '',
      canDelete: json['canDelete'] ?? false,
      createTime: json['createTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(ICEServerModel iceServerModel) =>
      <String, dynamic>{
        'url': iceServerModel.url,
        'canDelete': iceServerModel.canDelete,
        'createTime': iceServerModel.createTime,
      };

  static List<ICEServerModel> get defaultICEServers => List.from([
        ICEServerModel(
          url: 'turn:0xchat:Prettyvs511@rtc.0xchat.com:5349',
          createTime: DateTime.now().millisecondsSinceEpoch,
        ),
        ICEServerModel(
          url: 'turn:0xchat:Prettyvs511@rtc2.0xchat.com:5349',
          createTime: DateTime.now().millisecondsSinceEpoch,
        ),
      ]);
}
