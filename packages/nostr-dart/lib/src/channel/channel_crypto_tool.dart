import 'package:nostr_core_dart/src/channel/core_method_channel.dart';
import 'package:hex/hex.dart';

///Title: channel_crypto_tool
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/5/24 18:50
class ChannelCryptoTool {


  static Future<bool> verifySignature( String eventPubKey, String eventId, String signature) async {
    final bool result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'verifySignature',
      {
        'signature': HEX.decode(signature),
        'hash': HEX.decode(eventId),
        'pubKey': HEX.decode(eventPubKey),
      },
    );
    return result;
  }

  static Future<bool> signSchnorr(String data, String eventPrivKey) async {
    final bool result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'signSchnorr',
      {
        'data': HEX.decode(data),
        'privKey': HEX.decode(eventPrivKey),
      },
    );
    return result;
  }
}

