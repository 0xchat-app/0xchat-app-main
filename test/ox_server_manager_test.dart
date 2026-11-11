// Default servers after 0xchat's own servers were shut down.
//
// Up to 1.5.6 the selected upload server was saved only as a position in a
// list that began with originless.besoeasy.com, which no longer exists.
// Dropping it from the defaults moves every other server up one place, so
// the saved position has to be translated rather than reused.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ox_common/model/file_storage_server_model.dart';
import 'package:ox_common/model/ice_server_model.dart';
import 'package:ox_common/utils/ox_server_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

void main() {
  final manager = OXServerManager.sharedInstance;
  final settings = OXUserInfoManager.sharedInstance.settingsMap;

  final originless = OriginlessServer(
      url: 'https://originless.besoeasy.com', name: 'originless.besoeasy.com', canEdit: false);
  final oxchat = OXChatServer(url: 'https://www.0xchat.com', name: '0xchat', canEdit: false);
  final own = BlossomServer(url: 'https://blossom.example.com', name: 'mine');

  // The list as 1.5.6 saved it: its defaults, then servers the user added.
  void save156List(List<FileStorageServer> added) {
    final servers = [originless, ...FileStorageServer.defaultFileStorageServers, ...added];
    settings[OXServerManager.fileStorageServer] =
        jsonEncode([for (final s in servers) s.toJson(s)]);
  }

  String selectedUrl() {
    manager.fileStorageServers = manager.getFileStorageServers();
    return manager.fileStorageServers[manager.getSelectedFileStorageServer()].url;
  }

  setUp(settings.clear);

  test('a fresh install starts on the first default', () {
    expect(selectedUrl(), 'https://blossom.band');
  });

  test('1.5.6 users on originless move to the first default', () {
    save156List([]);
    settings[OXServerManager.selectedFileStorageServerIndex] = 0;
    expect(selectedUrl(), 'https://blossom.band');
    expect(manager.fileStorageServers.map((s) => s.url), isNot(contains(originless.url)));
  });

  test('1.5.6 users keep the default they picked', () {
    save156List([]);
    settings[OXServerManager.selectedFileStorageServerIndex] = 5;
    expect(selectedUrl(), 'https://nostr.build');
  });

  test('1.5.6 users keep their own server, past a retired 0xchat one', () {
    save156List([oxchat, own]);
    settings[OXServerManager.selectedFileStorageServerIndex] = 7;
    expect(selectedUrl(), own.url);
    expect(manager.fileStorageServers.map((s) => s.url), isNot(contains(oxchat.url)));
  });

  test('a selection saved by URL survives changes to the list', () async {
    save156List([own]);
    manager.fileStorageServers = manager.getFileStorageServers();
    await manager.updateSelectedFileStorageServer(
        manager.fileStorageServers.indexWhere((s) => s.url == own.url));
    expect(settings[OXServerManager.selectedFileStorageServerUrl], own.url);
    settings[OXServerManager.selectedFileStorageServerIndex] = 0;
    expect(selectedUrl(), own.url);
  });

  test('a selected server that is gone falls back to the first', () {
    settings[OXServerManager.selectedFileStorageServerUrl] = 'https://gone.example.com';
    expect(selectedUrl(), 'https://blossom.band');
  });

  test("0xchat's TURN servers are retired, others are not", () {
    expect(ICEServerModel(url: 'turn:0xchat:Prettyvs511@52.76.210.159:5349').isRetired, isTrue);
    expect(ICEServerModel(url: 'turn:0xchat:Prettyvs511@rtc2.0xchat.com:5349').isRetired, isTrue);
    expect(ICEServerModel(url: 'turn:me:secret@turn.example.com:3478').isRetired, isFalse);
    for (final server in ICEServerModel.defaultICEServers) {
      expect(server.isRetired, isFalse, reason: server.url);
    }
  });
}
