
import '../../core/nuts/v0/nut.dart' as v0;
import '../../core/nuts/v1/nut.dart' as v1;
import '../model/invoice_isar.dart';
import '../model/mint_info_isar.dart';
import '../model/mint_model_isar.dart';
import '../utils/network/response.dart';
import 'nuts/define.dart';
import 'nuts/nut_00.dart';
import 'nuts/token/proof_isar.dart';

typedef RequestKeysAction = Future<CashuResponse<List<MintKeysPayload>>> Function({
  required String mintURL,
  String? keysetId,
});

typedef RequestMintInfoAction = Future<CashuResponse<MintInfoIsar>> Function({
  required String mintURL,
});

typedef TokenCheckAction = Future<CashuResponse<List<TokenState>>> Function({
  required String mintURL,
  required List<ProofIsar> proofs,
});

typedef TokenSwapAction = Future<CashuResponse<List<BlindedSignature>>> Function({
  required String mintURL,
  required List<ProofIsar> proofs,
  required List<BlindedMessage> outputs,
});

typedef CreateQuoteAction = Future<CashuResponse<Receipt>> Function({
  required String mintURL,
  required int amount,
});

typedef RequestTokensAction = Future<CashuResponse<List<BlindedSignature>>> Function({
  required String mintURL,
  required String quote,
  required List<BlindedMessage> blindedMessages,
});

extension ActionEx on IMintIsar {

  RequestKeysAction get requestKeysAction => maxNutsVersion >= 1
      ? v1.Nut1.requestKeys
      : v0.Nut1.requestKeys;

  RequestMintInfoAction get requestMintInfoAction => maxNutsVersion >= 1
      ? v1.Nut6.requestMintInfo
      : v0.Nut9.requestMintInfo;

  TokenCheckAction get tokenCheckAction => maxNutsVersion >= 1
      ? v1.Nut7.requestTokenState
      : v0.Nut7.requestTokenState;

  TokenSwapAction get swapAction => maxNutsVersion >= 1
      ? v1.Nut3.swap
      : v0.Nut6.split;

  CreateQuoteAction get createQuoteAction => (maxNutsVersion >= 1
      ? v1.Nut4.requestMintQuote
      : v0.Nut3.requestMintInvoice);

  RequestTokensAction get requestTokensAction => maxNutsVersion >= 1
      ? v1.Nut4.requestTokensFromMint
      : v0.Nut4.requestTokensFromMint;
}