import 'dart:convert';

import 'package:ox_common/model/file_storage_server_model.dart';
import 'package:ox_common/model/ice_server_model.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/user_config_tool.dart';

abstract mixin class OXServerObserver {
  void didAddICEServer(List<Map<String,String>> serverConfigList) {}

  void didDeleteICEServer(List<Map<String,String>> serverConfigList) {}

  void didAddFileStorageServer(FileStorageServer fileStorageServer) {}

  void didDeleteFileStorageServer() {}

  void didUpdateFileStorageServer() {}
}

class OXServerManager {
  static final OXServerManager sharedInstance = OXServerManager._internal();

  static final String iceServerKey = StorageSettingKey.KEY_ICE_SERVER.name;
  static final String fileStorageServer = StorageSettingKey.KEY_FILE_STORAGE_SERVER.name;
  static final String selectedFileStorageServerIndex = StorageSettingKey.KEY_FILE_STORAGE_SERVER_INDEX.name;
  static final String selectedFileStorageServerUrl = StorageSettingKey.KEY_FILE_STORAGE_SERVER_URL.name;

  OXServerManager._internal();

  factory OXServerManager() {
    return sharedInstance;
  }

  final List<OXServerObserver> _observers = <OXServerObserver>[];

  void addObserver(OXServerObserver observer) => _observers.add(observer);

  bool removeObserver(OXServerObserver observer) => _observers.remove(observer);

  List<ICEServerModel> iCESeverModelList = [];

  List<FileStorageServer> fileStorageServers = [];
  late FileStorageServer selectedFileStorageServer;
  int _selectedFileStorageIndex = 0;

  List<Map<String, String>> get iCEServerConfigList => iCESeverModelList.expand((item) => item.serverConfig).toList();
  int get selectedFileStorageIndex  => _selectedFileStorageIndex;
  bool _openP2PAndRelay = true;
  bool get openP2PAndRelay => _openP2PAndRelay;

  void loadConnectICEServer() async {
    List<ICEServerModel> connectICEServerList = await getICEServerList();

    // Filter out old servers
    connectICEServerList = connectICEServerList.where((server) => !server.isRetired).toList();

    // Ensure all default servers are in the list
    final defaultServers = ICEServerModel.defaultICEServers;
    final existingUrls = connectICEServerList.map((s) => s.url).toSet();
    
    for (var defaultServer in defaultServers) {
      if (!existingUrls.contains(defaultServer.url)) {
        connectICEServerList.add(defaultServer);
      }
    }
    
    // Save if list changed
    if (connectICEServerList.isNotEmpty) {
      await saveICEServerList(connectICEServerList);
    }
    
    iCESeverModelList = connectICEServerList;
    List<FileStorageServer> tempFileStorageServers = await getFileStorageServers();
    if(tempFileStorageServers.isEmpty) {
      fileStorageServers = FileStorageServer.defaultFileStorageServers;
      await saveFileStorageServers(fileStorageServers);
    } else {
      fileStorageServers = tempFileStorageServers;
    }
    _selectedFileStorageIndex = await getSelectedFileStorageServer();
    selectedFileStorageServer = fileStorageServers[_selectedFileStorageIndex];
    _openP2PAndRelay = await getOpenP2PAndRelay();
  }

  Future<void> addServer(ICEServerModel iceServerModel) async {
    iCESeverModelList.add(iceServerModel);
    await saveICEServerList(iCESeverModelList);
    List<Map<String,String>> serverConfigList = iCESeverModelList.expand((item) => item.serverConfig).toList();
    for (OXServerObserver observer in _observers) {
      observer.didAddICEServer(serverConfigList);
    }
  }

  Future<void> deleteServer(ICEServerModel iceServerModel) async {
    iCESeverModelList.remove(iceServerModel);
    await saveICEServerList(iCESeverModelList);
    List<Map<String,String>> serverConfigList = iCESeverModelList.expand((item) => item.serverConfig).toList();
    for (OXServerObserver observer in _observers) {
      observer.didDeleteICEServer(serverConfigList);
    }
  }

  Future<void> saveICEServerList(List<ICEServerModel> iceServerList) async {
    final jsonString = jsonEncode(iceServerList.map((iceServerModel) => iceServerModel.toJson(iceServerModel)).toList());
    await UserConfigTool.saveSetting(iceServerKey, jsonString);
  }

  List<ICEServerModel> getICEServerList() {
    final String jsonString = UserConfigTool.getSetting(iceServerKey, defaultValue: '');

    if(jsonString.isEmpty){
      return [];
    }

    final iCEServerJsonList = jsonDecode(jsonString);
    final iCEServerList = [
      for (var json in iCEServerJsonList) ICEServerModel.fromJson(json)
    ];

    return iCEServerList;
  }

  Future<List<Map<String, String>>> getICEServerConfigList() async {
    List<ICEServerModel>  iCEServerList = await getICEServerList();
    List<Map<String, String>> serverConfigList = iCEServerList.expand((item) => item.serverConfig).toList();
    return serverConfigList;
  }

  Future<void> saveFileStorageServers(List<FileStorageServer> fileStorageServers) async {
    final jsonString = jsonEncode(fileStorageServers.map((fileStorageServer) => fileStorageServer.toJson(fileStorageServer)).toList());
    await UserConfigTool.saveSetting(fileStorageServer, jsonString);
  }

  Future<bool> getOpenP2PAndRelay() async {
    bool openP2p = UserConfigTool.getSetting(StorageSettingKey.KEY_OPEN_P2P_AND_RELAY.name, defaultValue: true);
    return openP2p;
  }

  Future<void> saveOpenP2PAndRelay(bool value) async {
    _openP2PAndRelay = value;
    await UserConfigTool.saveSetting(StorageSettingKey.KEY_OPEN_P2P_AND_RELAY.name, value);
  }

  List<FileStorageServer> getFileStorageServers() {
    var fileStorageServers = FileStorageServer.defaultFileStorageServers;
    for (var server in _savedFileStorageServers()) {
      var exists = fileStorageServers.any((s) => s.url == server.url);
      if (!exists && !server.isRetired) {
        fileStorageServers.add(server);
      }
    }
    return fileStorageServers;
  }

  List<FileStorageServer> _savedFileStorageServers() {
    final jsonString = UserConfigTool.getSetting(fileStorageServer, defaultValue: '');
    if (jsonString.isEmpty) return [];
    return [for (var json in jsonDecode(jsonString)) FileStorageServer.fromJson(json)];
  }

  Future<void> saveSelectedFileStorageServer() async {
    await UserConfigTool.saveSetting(selectedFileStorageServerUrl, selectedFileStorageServer.url);
    return await UserConfigTool.saveSetting(selectedFileStorageServerIndex, _selectedFileStorageIndex);
  }

  /// The selected server's position in [fileStorageServers], or 0 when it is
  /// gone. Looked up by URL, so the list can change around it.
  int getSelectedFileStorageServer() {
    String url = UserConfigTool.getSetting(selectedFileStorageServerUrl, defaultValue: '');
    if (url.isEmpty) {
      url = _legacySelectedUrl(UserConfigTool.getSetting(selectedFileStorageServerIndex, defaultValue: 0));
    }
    final index = fileStorageServers.indexWhere((s) => s.url == url);
    return index < 0 ? 0 : index;
  }

  /// Up to 1.5.6 only the position was saved. It counted over that version's
  /// defaults, which began with originless.besoeasy.com, then the saved extras.
  String _legacySelectedUrl(int index) {
    final legacy = [
      'https://originless.besoeasy.com',
      'https://blossom.band',
      'https://blossom.azzamo.media',
      'https://blossom.primal.net',
      'https://24242.io',
      'https://nostr.build',
    ];
    for (var server in _savedFileStorageServers()) {
      if (!legacy.contains(server.url)) legacy.add(server.url);
    }
    return index >= 0 && index < legacy.length ? legacy[index] : '';
  }

  updateSelectedFileStorageServer(int selectedIndex) async {
    _selectedFileStorageIndex = selectedIndex;
    selectedFileStorageServer = fileStorageServers[_selectedFileStorageIndex];
    await saveSelectedFileStorageServer();
  }

  Future<void> addFileStorageServer(FileStorageServer fileStorageServer) async {
    fileStorageServers.add(fileStorageServer);
    await saveFileStorageServers(fileStorageServers);
    for (OXServerObserver observer in _observers) {
      observer.didAddFileStorageServer(fileStorageServer);
    }
  }

  Future<void> updateFileStorageServer(FileStorageServer fileStorageServer) async {
    int index = fileStorageServers.indexOf(fileStorageServer);
    if(index != -1) {
      fileStorageServers[index] = fileStorageServer;
    }
    await saveFileStorageServers(fileStorageServers);
    for (OXServerObserver observer in _observers) {
      observer.didUpdateFileStorageServer();
    }
  }

  Future<void> deleteFileStorageServer(FileStorageServer fileStorageServer) async {
    fileStorageServers.removeWhere((element) => element.url == fileStorageServer.url);
    await saveFileStorageServers(fileStorageServers);
    for (OXServerObserver observer in _observers) {
      observer.didDeleteFileStorageServer();
    }
  }
}
