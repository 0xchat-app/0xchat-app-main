import 'dart:convert';

import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/model/ice_server_model.dart';

abstract class OXServerObserver {
  void didAddICEServer(List<Map<String,String>> serverConfigList) {}

  void didDeleteICEServer(List<Map<String,String>> serverConfigList) {}
}

class OXServerManager {
  static final OXServerManager sharedInstance = OXServerManager._internal();

  static final String iceServerKey = 'KEY_ICE_SERVER';

  OXServerManager._internal();

  factory OXServerManager() {
    return sharedInstance;
  }

  final List<OXServerObserver> _observers = <OXServerObserver>[];

  void addObserver(OXServerObserver observer) => _observers.add(observer);

  bool removeObserver(OXServerObserver observer) => _observers.remove(observer);

  List<ICEServerModel> iCESeverModelList = [];

  void loadConnectICEServer() async {
    List<ICEServerModel> connectICEServerList = await getICEServerList();
    if(connectICEServerList.isEmpty){
      connectICEServerList.addAll(ICEServerModel.defaultICEServers);
      await saveICEServerList(connectICEServerList);
    }
    iCESeverModelList = connectICEServerList;
  }

  Future<void> addServer(ICEServerModel iceServerModel) async {
    iCESeverModelList.add(iceServerModel);
    await saveICEServerList(iCESeverModelList);
    List<Map<String,String>> serverConfigList = iCESeverModelList.map((item) => item.serverConfig).toList();
    for (OXServerObserver observer in _observers) {
      observer.didAddICEServer(serverConfigList);
    }
  }

  Future<void> deleteServer(ICEServerModel iceServerModel) async {
    iCESeverModelList.remove(iceServerModel);
    await saveICEServerList(iCESeverModelList);
    List<Map<String,String>> serverConfigList = iCESeverModelList.map((item) => item.serverConfig).toList();
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
    List<Map<String, String>> serverConfigList = iCEServerList.map((item) => item.serverConfig).toList();
    return serverConfigList;
  }
}
