import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'common_webview.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'common_hint_dialog.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:chatcore/chat-core.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_localizable/ox_localizable.dart';

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
};   
         """;

  Set<JavascriptChannel>? get nostrChannels => <JavascriptChannel>{
        getPublicKeyChannel(context),
        signEventChannel(context),
        getRelaysChannel(context),
        encryptNIP04Channel(context),
        decryptNIP04Channel(context),
      };

  JavascriptChannel getPublicKeyChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_getPublicKey',
        onMessageReceived: (JavascriptMessage message) async {
          var jsonObj = jsonDecode(message.message);
          var resultId = jsonObj["resultId"];
          bool result = await getAgreement(
              'get_request_title'.commonLocalized(),
              'get_publicKey_request_content'.commonLocalized(),
              'getPublicKey');
          if (result) {
            String pubkey = Account.sharedInstance.currentPubkey;
            var script = "window.nostr.resolve(\"$resultId\", \"$pubkey\");";
            await currentController.runJavascript(script);
          } else {
            var resultStr = 'User Rejected';
            var script = "window.nostr.reject(\"$resultId\", \"$resultStr\");";
            await currentController.runJavascript(script);
          }
        });
  }

  JavascriptChannel signEventChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_signEvent',
        onMessageReceived: (JavascriptMessage message) async {
          var jsonObj = jsonDecode(message.message);
          var resultId = jsonObj["resultId"];
          var content = jsonObj["msg"];
          var eventObj = jsonDecode(content);
          var signedEvent = await Account.sharedInstance.signEvent(eventObj);
          var eventResultStr = jsonEncode(signedEvent);
          String base64Json = base64.encode(utf8.encode(eventResultStr));
          var script =
              "window.nostr.resolve(\"$resultId\", JSON.parse(atob(\"$base64Json\")));";
          await currentController.runJavascript(script);
        });
  }

  JavascriptChannel encryptNIP04Channel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_nip04_encrypt',
        onMessageReceived: (JavascriptMessage message) async {
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
              await currentController.runJavascript(script);
            }
          } else {
            var resultStr = 'User Rejected';
            var script = "window.nostr.reject(\"$resultId\", \"$resultStr\");";
            await currentController.runJavascript(script);
          }
        });
  }

  JavascriptChannel decryptNIP04Channel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_nip04_decrypt',
        onMessageReceived: (JavascriptMessage message) async {
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
              await currentController.runJavascript(script);
            }
          } else {
            var resultStr = 'User Rejected';
            var script = "window.nostr.reject(\"$resultId\", \"$resultStr\");";
            await currentController.runJavascript(script);
          }
        });
  }

  JavascriptChannel getRelaysChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'JS_getRelays',
        onMessageReceived: (JavascriptMessage message) async {
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
          await currentController.runJavascript(script);
        });
  }

  Future<bool> getAgreement(String title, String content, String key) async {
    Completer<bool> completer = Completer<bool>();
    var uri = Uri.parse((widget as CommonWebView).url);
    var host = uri.host;
    bool agree = await OXCacheManager.defaultOXCacheManager
            .getForeverData('$host.$key') ??
        false;
    if (!agree) {
      OXCommonHintDialog.show(context,
          title: title,
          content: content,
          isRowAction: true,
          actionList: [
            OXCommonHintAction.cancel(onTap: () {
              OXNavigator.pop(context);
              completer.complete(false);
            }),
            OXCommonHintAction.sure(
                text: Localized.text('ox_common.confirm'),
                onTap: () async {
                  await OXCacheManager.defaultOXCacheManager
                      .saveForeverData('$host.$key', true);
                  OXNavigator.pop(context);
                  completer.complete(true);
                }),
          ]);
    } else {
      completer.complete(true);
    }
    return completer.future;
  }
}
