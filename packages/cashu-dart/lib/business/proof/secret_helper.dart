
import '../../core/nuts/v1/nut.dart';

class SecretHelper {
  static Nut10Secret? createSecretEntry(String secret) {
    final nut10Data = Nut10Secret.dataFromSecretString(secret);
    if (nut10Data == null) return null;

    final (ConditionType kind, _, _, _) = nut10Data;
    switch (kind) {
      case ConditionType.p2pk: return P2PKSecret.fromNut10Data(nut10Data);
      case ConditionType.htlc: return HTLCSecret.fromNut10Data(nut10Data);
    }
  }
}