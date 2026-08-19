


import '../../utils/tools.dart';
import 'nut_00.dart';

const nutProtocolVersion = 'v1';

String nutURLJoin(String mint, String path, {String version = '$nutProtocolVersion/'}) {
  final result = '$mint/$version$path';
  return result;
}

typedef MintKeys = Map<String, String>;

class MintKeysPayload {
  MintKeysPayload(this.id, this.unit, this.keys);
  final String id;
  final String unit;
  final MintKeys keys;

  static MintKeysPayload? fromServerMap(json) {
    final id = Tools.getValueAs(json, 'id', '');
    final unit = Tools.getValueAs(json, 'unit', '');
    final keys = Tools.getValueAs<Map>(json, 'keys', {})
        .map((key, value) => MapEntry(key.toString(), value.toString()));
    if (id.isEmpty || unit.isEmpty || keys.isEmpty) return null;
    return MintKeysPayload(id, unit, keys);
  }

  @override
  String toString() {
    return '${super.toString()}, id: $id, unit: $unit';
  }
}

enum TokenState {
  live,
  burned,
  inFlight,
}

typedef NutsResponse<T> = (
  T data,
  String? errorMsg,
);

typedef BlindedMessageData = (
  /// Blinded messages sent to the mint for signing.
  List<BlindedMessage> blindedMessages,

  /// secrets, kept client side for constructing proofs later.
  List<String> secrets,

  /// Blinding factor used for blinding messages and unblinding signatures after they are received from the mint.
  List<BigInt> rs,

  List<num>? amounts,
);

typedef BlindMessageResult = (
  String B_,
  BigInt r
);

typedef QuoteState = (
  String quote,
  String request,
  bool paid,
  int expiry,
);

typedef MeltResponse = (
  bool paid,
  String preimage,
  List<BlindedSignature> change,
);

