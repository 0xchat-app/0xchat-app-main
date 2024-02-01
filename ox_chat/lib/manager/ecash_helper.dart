
import 'package:cashu_dart/cashu_dart.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/page/ecash/ecash_info.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EcashHelper {

  static Future<EcashPackage> createPackageFromMessage(types.CustomMessage message) async {

    final totalAmount = EcashMessageEx(message).amount;
    final memo = EcashMessageEx(message).description;
    final senderPubKey = message.author.id;
    final tokenList = EcashMessageEx(message).tokenList;

    final tokenInfoList = <EcashTokenInfo>[];
    final historyMap = await getHistoryForTokenList(tokenList);
    for (final token in tokenList) {
      final info = Cashu.infoOfToken(token);
      if (info == null) continue;
      final (_, amount) = info;
      final tokenInfo = EcashTokenInfo(
        token: token,
        amount: amount,
        redeemHistory: historyMap[token],
      );
      tokenInfoList.add(tokenInfo);
    }

    return EcashPackage(
      messageId: message.id,
      totalAmount: totalAmount,
      tokenInfoList: tokenInfoList,
      memo: memo,
      senderPubKey: senderPubKey,
    );
  }

  static Future<Map<String, EcashReceiptHistory>> getHistoryForTokenList(List<String> tokenList) async {
    final historyByOther = (await DB.sharedInstance.objects<EcashReceiptHistory>(
      where: 'token in (${tokenList.map((e) => '"$e"').join(',')})',
    ));

    final historyByMe = await Cashu.getHistory(value: tokenList);

    final Map<String, EcashReceiptHistory> result = {};
    historyByOther.forEach((entry) {
      result[entry.token] = entry;
    });
    historyByMe.forEach((entry) {
      if (entry.amount > 0) {
        result[entry.value] = entry.toReceiptHistory();
      }
    });

    return result;
  }

  static Future<EcashReceiptHistory> addReceiptHistoryForToken(String token) async {
    final history = EcashReceiptHistory(
      token: token,
      isMe: false,
    );
    await DB.sharedInstance.insert<EcashReceiptHistory>(history);
    return history;
  }

  static updateReceiptHistoryForPackage(EcashPackage package) async {
    final unreceivedToken = package.tokenInfoList
        .where((info) => info.redeemHistory == null)
        .toList();
    for (final tokenInfo in unreceivedToken) {
      final token = tokenInfo.token;
      final spendable = await Cashu.isEcashTokenSpendableFromToken(token);
      if (spendable == false) {
        final history = await addReceiptHistoryForToken(token);
        tokenInfo.redeemHistory = history;
      }
    }
  }

  static Future<bool?> tryRedeemTokenList(EcashPackage package) async {
    final unreceivedToken = package.tokenInfoList
        .where((info) => info.redeemHistory == null)
        .toList()
        ..shuffle();

    var hasRedeemError = false;
    for (final tokenInfo in unreceivedToken) {
      final token = tokenInfo.token;
      final response = await Cashu.redeemEcash(token);
      if (response.code == ResponseCode.tokenAlreadySpentError) {
        final history = await addReceiptHistoryForToken(token);
        tokenInfo.redeemHistory = history;
        continue ;
      }

      if (response.isSuccess) {
        final history = (await Cashu.getHistory(value: [token])).firstOrNull;
        tokenInfo.redeemHistory = history?.toReceiptHistory();
        return true;
      }

      hasRedeemError = true;
    }

    if (hasRedeemError) return null;

    return false;
  }
}

extension IHistoryEntryEcashEx on IHistoryEntry {
  EcashReceiptHistory toReceiptHistory() =>
    EcashReceiptHistory(
      token: value,
      isMe: true,
      timestamp: timestamp.toInt(),
    );
}