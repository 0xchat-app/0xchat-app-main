import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'common_webview.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'nostr_permission_bottom_sheet.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:chatcore/chat-core.dart';
import 'package:webview_flutter/webview_flutter.dart';

extension Nostr on CommonWebViewState {
  String get windowNostrJavaScript => """
window.nostr = {
  _call(channel, message) {
    return new Promise((resolve, reject) => {
      var resultId = "callbackResult_" + Math.floor(Math.random() * 100000000);
      var arg = { resultId: resultId };
      if (message) {
        arg["msg"] = message;
      }
      var argStr = JSON.stringify(arg);
      channel.postMessage(argStr);
      window.nostr._requests[resultId] = { resolve, reject };
    });
  },
  _requests: {},
  resolve(resultId, message) {
    window.nostr._requests[resultId].resolve(message);
  },
  reject(resultId, message) {
    window.nostr._requests[resultId].reject(message);
  },
  async getPublicKey() {
    return window.nostr._call(JS_getPublicKey);
  },
  async signEvent(event) {
    return window.nostr._call(JS_signEvent, JSON.stringify(event));
  },
  async getRelays() {
    return window.nostr._call(JS_getRelays);
  },
  nip04: {
    async encrypt(pubkey, plaintext) {
      return window.nostr._call(JS_nip04_encrypt, {
        pubkey: pubkey,
        plaintext: plaintext,
      });
    },
    async decrypt(pubkey, ciphertext) {
      return window.nostr._call(JS_nip04_decrypt, {
        pubkey: pubkey,
        ciphertext: ciphertext,
      });
    },
  },
  nip44: {
    async encrypt(pubkey, plaintext) {
      return window.nostr._call(JS_nip44_encrypt, {
        pubkey: pubkey,
        plaintext: plaintext,
      });
    },
    async decrypt(pubkey, ciphertext) {
      return window.nostr._call(JS_nip44_decrypt, {
        pubkey: pubkey,
        ciphertext: ciphertext,
      });
    },
  },
};   
         """;

  Set<JavascriptChannel>? get nostrChannels => <JavascriptChannel>{
        getPublicKeyChannel(context),
        signEventChannel(context),
        getRelaysChannel(context),
        encryptNIP04Channel(context),
        decryptNIP04Channel(context),
        encryptNIP44Channel(context),
        decryptNIP44Channel(context),
      };

  JavascriptChannel getPublicKeyChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_getPublicKey',
        onMessageReceived: (JavaScriptMessage message) async {
          var jsonObj = jsonDecode(message.message);
          var resultId = jsonObj["resultId"];
          bool result = await getAgreement(
              'get_request_title'.commonLocalized(),
              'get_publicKey_request_content'.commonLocalized(),
              'getPublicKey');
          if (result) {
            String pubkey = Account.sharedInstance.currentPubkey;
            var script = "window.nostr.resolve(\"$resultId\", \"$pubkey\");";
            await currentController.runJavaScript(script);
          } else {
            var resultStr = 'User Rejected';
            var script = "window.nostr.reject(\"$resultId\", \"$resultStr\");";
            await currentController.runJavaScript(script);
          }
        });
  }

  JavascriptChannel signEventChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_signEvent',
        onMessageReceived: (JavaScriptMessage message) async {
          var jsonObj = jsonDecode(message.message);
          var resultId = jsonObj["resultId"];
          var content = jsonObj["msg"];
          var eventObj = jsonDecode(content);
          var signedEvent = await Account.sharedInstance.signEvent(eventObj);
          var eventResultStr = jsonEncode(signedEvent);
          String base64Json = base64.encode(utf8.encode(eventResultStr));
          var script =
              "window.nostr.resolve(\"$resultId\", JSON.parse(atob(\"$base64Json\")));";
          await currentController.runJavaScript(script);
        });
  }

  JavascriptChannel encryptNIP04Channel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_nip04_encrypt',
        onMessageReceived: (JavaScriptMessage message) async {
          var jsonObj = jsonDecode(message.message);
          var resultId = jsonObj["resultId"];
          bool result = await getAgreement(
              'get_request_title'.commonLocalized(),
              'get_encryptNip04_request_content'.commonLocalized(),
              'encryptNIP04');
          if (result) {
            var msg = jsonObj["msg"];
            if (msg != null && msg is Map) {
              var pubkey = msg["pubkey"];
              var plaintext = msg["plaintext"];
              var resultStr =
                  await Account.sharedInstance.encryptNip04(plaintext, pubkey);
              var script =
                  "window.nostr.resolve(\"$resultId\", \"$resultStr\");";
              await currentController.runJavaScript(script);
            }
          } else {
            var resultStr = 'User Rejected';
            var script = "window.nostr.reject(\"$resultId\", \"$resultStr\");";
            await currentController.runJavaScript(script);
          }
        });
  }

  JavascriptChannel decryptNIP04Channel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_nip04_decrypt',
        onMessageReceived: (JavaScriptMessage message) async {
          var jsonObj = jsonDecode(message.message);
          var resultId = jsonObj["resultId"];
          bool result = await getAgreement(
              'get_request_title'.commonLocalized(),
              'get_encryptNip04_request_content'.commonLocalized(),
              'encryptNIP04');
          if (result) {
            var msg = jsonObj["msg"];
            if (msg != null && msg is Map) {
              var pubkey = msg["pubkey"];
              var ciphertext = msg["ciphertext"];
              var resultStr =
                  await Account.sharedInstance.decryptNip04(ciphertext, pubkey);
              var script =
                  "window.nostr.resolve(\"$resultId\", \"$resultStr\");";
              await currentController.runJavaScript(script);
            }
          } else {
            var resultStr = 'User Rejected';
            var script = "window.nostr.reject(\"$resultId\", \"$resultStr\");";
            await currentController.runJavaScript(script);
          }
        });
  }

  JavascriptChannel getRelaysChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_getRelays',
        onMessageReceived: (JavaScriptMessage message) async {
          var jsonObj = jsonDecode(message.message);
          var resultId = jsonObj["resultId"];
          var relayMaps = {};
          var relayAddrs = Connect.sharedInstance.relays();
          for (var relayAddr in relayAddrs) {
            relayMaps[relayAddr] = {"read": true, "write": true};
          }
          var resultStr = jsonEncode(relayMaps);
          resultStr = resultStr.replaceAll("\"", "\\\"");
          var script =
              "window.nostr.resolve(\"$resultId\", JSON.parse(\"$resultStr\"));";
          await currentController.runJavaScript(script);
        });
  }

  JavascriptChannel encryptNIP44Channel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_nip44_encrypt',
        onMessageReceived: (JavaScriptMessage message) async {
          var jsonObj = jsonDecode(message.message);
          var resultId = jsonObj["resultId"];
          bool result = await getAgreement(
              'get_request_title'.commonLocalized(),
              'get_encryptNip04_request_content'.commonLocalized(),
              'encryptNIP44');
          if (result) {
            var msg = jsonObj["msg"];
            if (msg != null && msg is Map) {
              var pubkey = msg["pubkey"];
              var plaintext = msg["plaintext"];
              var resultStr =
                  await Account.sharedInstance.encryptNip44(plaintext, pubkey);
              var script =
                  "window.nostr.resolve(\"$resultId\", \"$resultStr\");";
              await currentController.runJavaScript(script);
            }
          } else {
            var resultStr = 'User Rejected';
            var script = "window.nostr.reject(\"$resultId\", \"$resultStr\");";
            await currentController.runJavaScript(script);
          }
        });
  }

  JavascriptChannel decryptNIP44Channel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_nip44_decrypt',
        onMessageReceived: (JavaScriptMessage message) async {
          var jsonObj = jsonDecode(message.message);
          var resultId = jsonObj["resultId"];
          bool result = await getAgreement(
              'get_request_title'.commonLocalized(),
              'get_encryptNip04_request_content'.commonLocalized(),
              'decryptNIP44');
          if (result) {
            var msg = jsonObj["msg"];
            if (msg != null && msg is Map) {
              var pubkey = msg["pubkey"];
              var ciphertext = msg["ciphertext"];
              var resultStr =
                  await Account.sharedInstance.decryptNip44(ciphertext, pubkey);
              var script =
                  "window.nostr.resolve(\"$resultId\", \"$resultStr\");";
              await currentController.runJavaScript(script);
            }
          } else {
            var resultStr = 'User Rejected';
            var script = "window.nostr.reject(\"$resultId\", \"$resultStr\");";
            await currentController.runJavaScript(script);
          }
        });
  }

  Future<bool> getAgreement(String title, String content, String key) async {
    Completer<bool> completer = Completer<bool>();
    var uri = Uri.parse(widget.url);
    var host = uri.host;
    // Get current user's pubKey for account-specific authorization
    String currentPubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    if (currentPubKey.isEmpty) {
      completer.complete(false);
      return completer.future;
    }
    // Use account-specific cache key: pubKey.host.key
    String cacheKey = '$currentPubKey.$host.$key';
    bool agree = await OXCacheManager.defaultOXCacheManager
            .getForeverData(cacheKey) ??
        false;
    if (!agree) {
      bool result = await NostrPermissionBottomSheet.show(
        context,
        title: title,
        content: content,
      );
      if (result) {
        await OXCacheManager.defaultOXCacheManager
            .saveForeverData(cacheKey, true);
        completer.complete(true);
      } else {
        completer.complete(false);
      }
    } else {
      completer.complete(true);
    }
    return completer.future;
  }
}
