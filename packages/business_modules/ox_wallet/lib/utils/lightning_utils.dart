import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bech32/bech32.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:ox_common/log_util.dart';

class LightningUtils {
  static Future<String> getLnurlFromLnaddr(String lnaddr) async {
    try {
      List<dynamic> parts = lnaddr.split('@');
      String name = parts[0];
      String domain = parts[1];
      if (name.isEmpty || domain.isEmpty) {
        throw Exception('invalid lnaddr');
      }
      String url = 'https://$domain/.well-known/lnurlp/$name';
      List<int> bytes = utf8.encode(url);
      String hex = bytesToHex(Uint8List.fromList(bytes));
      return bech32Encode('lnurl', hex, maxLength: 200);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> getCallbackFromLnurl(String lnurl) async {
    String callback = '';
    Map map = bech32Decode(lnurl, maxLength: lnurl.length);
    if (map['prefix'] == 'lnurl') {
      String hexURL = map['data'];
      String url = utf8.decode(hexToBytes(hexURL));
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        callback = result['callback'] ?? '';
      } else {
        throw Exception(response.toString());
      }
    } else {
      LogUtil.e('message');
    }
    return callback;
  }

  static Future<String> getInvoice(int sats, String lnaddr) async {
    String invoice = '';
    String lnurl = await LightningUtils.getLnurlFromLnaddr(lnaddr);
    String callback = await LightningUtils.getCallbackFromLnurl(lnurl);
    String url = '$callback?amount=${sats * 1000}&lnurl=$lnurl';
    final result = await http.get(Uri.parse(url));
    if (result.statusCode == 200) {
      try {
        invoice = jsonDecode(result.body)['pr'];
      } catch (e,s) {
        LogUtil.e('get invoice failed: $e\r\n$s');
      }
    } else {}

    return invoice;
  }

  static String bytesToHex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  static String bech32Encode(String prefix, String hexData, {int? maxLength}) {
    final data = hex.decode(hexData);
    final convertedData = convertBits(data, 8, 5, true);
    final bech32Data = Bech32(prefix, convertedData);
    if (maxLength != null) return bech32.encode(bech32Data, maxLength);
    return bech32.encode(bech32Data);
  }

  static List<int> convertBits(List<int> data, int fromBits, int toBits, bool pad) {
    var acc = 0;
    var bits = 0;
    final maxv = (1 << toBits) - 1;
    final result = <int>[];

    for (final value in data) {
      if (value < 0 || value >> fromBits != 0) {
        throw Exception('Invalid value: $value');
      }
      acc = (acc << fromBits) | value;
      bits += fromBits;

      while (bits >= toBits) {
        bits -= toBits;
        result.add((acc >> bits) & maxv);
      }
    }

    if (pad) {
      if (bits > 0) {
        result.add((acc << (toBits - bits)) & maxv);
      }
    } else if (bits >= fromBits || ((acc << (toBits - bits)) & maxv) != 0) {
      throw Exception('Invalid data');
    }

    return result;
  }

  static Map<String, String> bech32Decode(String bech32Data, {int? maxLength}) {
    final decodedData = maxLength != null
        ? bech32.decode(bech32Data, maxLength)
        : bech32.decode(bech32Data);
    final convertedData = convertBits(decodedData.data, 5, 8, false);
    final hexData = hex.encode(convertedData);

    return {'prefix': decodedData.hrp, 'data': hexData};
  }

  static Uint8List hexToBytes(String hex) {
    List<int> bytes = [];
    for (int i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(bytes);
  }
}
