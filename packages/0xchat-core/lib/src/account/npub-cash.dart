import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';

class ClaimResult {
  final String? token;
  final String? errorMessage;
  
  ClaimResult.success(this.token) : errorMessage = null;
  ClaimResult.error(this.errorMessage) : token = null;
  
  bool get isSuccess => token != null;
}

class NpubCash {
  static String address(String pubkey) {
    return '${Nip19.encodePubkey(pubkey)}@npub.cash';
  }

  static Future<int?> balance() async {
    String url = 'https://npub.cash/api/v1/balance';
    String authToken = await Nip98.base64Event(
        url, Account.sharedInstance.currentPubkey, Account.sharedInstance.currentPrivkey);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Nostr $authToken',
      },
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body['error'] == false) {
        var data = body['data'];
        if (data != null) {
          if (data is String) {
            return int.tryParse(data) ?? 0;
          } else if (data is int) {
            return data;
          }
        }
      }
    } else {
      LogUtils.v(() => 'Request failed with status: ${response.statusCode}');
    }
    return null;
  }

  static Future<ClaimResult> claim() async {
    String url = 'https://npub.cash/api/v1/claim';
    String? authToken;
    try {
      authToken = await Nip98.base64Event(
          url, Account.sharedInstance.currentPubkey, Account.sharedInstance.currentPrivkey);
    } catch (e) {
      LogUtils.e(() => 'Nip98.base64Event exception: $e');
      return ClaimResult.error('Failed to generate authentication token: $e');
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Nostr $authToken',
      },
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body['error'] == false) {
        var data = body['data'];
        if (data != null && data is Map) {
          var token = data['token'];
          if (token != null && token is String) {
            return ClaimResult.success(token);
          } else {
            LogUtils.e(() => '[npub.cash claim] Missing or invalid token in response data: $data');
            return ClaimResult.error('Missing or invalid token in response');
          }
        } else {
          LogUtils.e(() => '[npub.cash claim] Missing or invalid data in response: $data');
          return ClaimResult.error('Missing or invalid data in response');
        }
      } else {
        var errorMsg = body['message'] ?? body['error'] ?? 'Unknown error';
        LogUtils.e(() => '[npub.cash claim] API error: $errorMsg, full response: ${response.body}');
        return ClaimResult.error(errorMsg.toString());
      }
    } else {
      var errorBody = '';
      try {
        var body = json.decode(response.body);
        errorBody = body['message'] ?? body['error'] ?? response.body;
      } catch (e) {
        errorBody = response.body;
      }
      LogUtils.e(() => '[npub.cash claim] Request failed with status: ${response.statusCode}, error: $errorBody');
      return ClaimResult.error(errorBody);
    }
  }
}
