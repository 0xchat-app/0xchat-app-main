import 'dart:convert';

import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/model/file_storage_server_model.dart';
import 'package:ox_common/model/ice_server_model.dart';
import 'package:ox_common/utils/storage_key_tool.dart';

abstract mixin class OXServerObserver {
  void didAddICEServer(List<Map<String,String>> serverConfigList) {}

  void didDeleteICEServer(List<Map<String,String>> serverConfigList) {}

  void didAddFileStorageServer(FileStorageServer fileStorageServer) {}

  void didDeleteFileStorageServer() {}

  void didUpdateFileStorageServer() {}
}

class OXServerManager {
  static final OXServerManager sharedInstance = OXServerManager._internal();

  static final String iceServerKey = 'KEY_ICE_SERVER';
  static final String fileStorageServer = 'KEY_FILE_STORAGE_SERVER';
  static final String selectedFileStorageServerIndex = 'KEY_FILE_STORAGE_SERVER_INDEX';

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
  bool _openP2p = false;
  bool get openP2pValue => _openP2p;

  void loadConnectICEServer() async {
    List<ICEServerModel> connectICEServerList = await getICEServerList();
    if(connectICEServerList.isEmpty){
      connectICEServerList.addAll(ICEServerModel.defaultICEServers);
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
    _openP2p = await getOpenP2p();
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
    await OXCacheManager.defaultOXCacheManager.saveData(iceServerKey, jsonString);
  }

  Future<List<ICEServerModel>> getICEServerList() async{
    final String jsonString = await OXCacheManager.defaultOXCacheManager.getData(iceServerKey);

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
    await OXCacheManager.defaultOXCacheManager.saveForeverData(fileStorageServer, jsonString);
  }

  Future<bool> getOpenP2p() async {
    bool openP2p = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageSettingKey.KEY_OPEN_P2P.name, defaultValue: false);
    return openP2p;
  }

  Future<bool> saveOpenP2p(bool value) async {
    _openP2p = value;
    bool openP2p = await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageSettingKey.KEY_OPEN_P2P.name, value);
    return openP2p;
  }

  Future<List<FileStorageServer>> getFileStorageServers() async{
    final jsonString = await OXCacheManager.defaultOXCacheManager.getForeverData(fileStorageServer,defaultValue: '');

    if (jsonString.isEmpty) {
      return [];
    }

    final fileStorageServers = jsonDecode(jsonString);
    final fileStorageList = [
      for (var json in fileStorageServers) FileStorageServer.fromJson(json)
    ];

    return fileStorageList;
  }

  Future<bool> saveSelectedFileStorageServer() async {
    return await OXCacheManager.defaultOXCacheManager.saveForeverData(selectedFileStorageServerIndex, _selectedFileStorageIndex);
  }
  
  Future<int> getSelectedFileStorageServer() async {
    return await OXCacheManager.defaultOXCacheManager.getForeverData(selectedFileStorageServerIndex,defaultValue: 0);
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
    fileStorageServers.remove(fileStorageServer);
    await saveFileStorageServers(fileStorageServers);
    for (OXServerObserver observer in _observers) {
      observer.didDeleteFileStorageServer();
    }
  }
}
