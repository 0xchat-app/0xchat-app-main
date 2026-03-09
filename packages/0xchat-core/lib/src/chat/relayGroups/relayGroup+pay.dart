import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

extension PayRelayGroup on RelayGroup {
  Future<PaymentResponse?> createLightningPayment(String groupId, int level, String levelPeriod) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return null;
    final paymentRequest = PaymentRequest(
      baseUrl: groupDB.relay,
    );
    final lightningPayment = await paymentRequest.createPayment(
        groupId: groupId, type: 'lightning', level: level, levelPeriod: levelPeriod);
    final paymentResponse = PaymentResponse.fromJson(lightningPayment['payment']);
    return paymentResponse;
  }

  Future<PaymentResponse?> checkPaymentStatus(String groupId, String paymentHash) async {
    RelayGroupDBISAR? groupDB = myGroups[groupId]?.value;
    if (groupDB == null) return null;
    final paymentRequest = PaymentRequest(
      baseUrl: groupDB.relay,
    );
    final payment = await paymentRequest.checkPayment(groupId: groupId, paymentid: paymentHash);
    final paymentResponse = PaymentResponse.fromJson(payment['payment']);
    return paymentResponse;
  }
}

class PaymentRequest {
  final String baseUrl;

  PaymentRequest({
    required this.baseUrl,
  });

  String convertWsToHttp(String url) {
    if (url.startsWith('ws://')) {
      return url.replaceFirst('ws://', 'http://');
    } else if (url.startsWith('wss://')) {
      return url.replaceFirst('wss://', 'https://');
    } else {
      return url;
    }
  }

  Future<Map<String, dynamic>> createPayment({
    required String groupId,
    required String type,
    required int level,
    required String levelPeriod,
    int? amount,
    String? receipt,
    String? status,
    DateTime? settledAt,
  }) async {
    final httpbaseUrl = convertWsToHttp(baseUrl);
    final url = Uri.parse('$httpbaseUrl/createPayment');

    final body = {
      'group_id': groupId,
      'type': type,
      'amount': amount ?? 0,
      'level': level,
      'level_period': levelPeriod,
      'receipt': receipt,
      'status': status ?? 'pending',
      'settled_at': settledAt?.toIso8601String(),
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create payment: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> checkPayment({
    required String groupId,
    required String paymentid,
  }) async {
    final httpbaseUrl = convertWsToHttp(baseUrl);
    final url = Uri.parse('$httpbaseUrl/checkpayment');

    final body = {
      'group_id': groupId,
      'paymentid': paymentid,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check payment: ${response.body}');
    }
  }
}

class PaymentResponse {
  final String id; // Payment hash
  final String groupId;
  final String type; // PaymentType should be a String or Enum
  final int amount; // USD
  final String status; // pending, settled, expired, canceled
  final DateTime createdAt;
  final DateTime? settledAt;
  final int level;
  final String levelPeriod; // in seconds
  final String? receipt; // Lightning invoice or App Store/Google Play receipt

  PaymentResponse({
    required this.id,
    required this.groupId,
    required this.type,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.settledAt,
    required this.level,
    required this.levelPeriod,
    this.receipt,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      id: json['id'] as String? ?? '',
      groupId: json['group_id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      amount: (json['amount'] as int?) ?? 0,
      status: json['status'] as String? ?? 'pending',
      createdAt:
          json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime(1970, 1, 1),
      settledAt: json['settled_at'] != null ? DateTime.parse(json['settled_at']) : null,
      level: (json['level'] as int?) ?? 0,
      levelPeriod: json['level_period'] as String? ?? '',
      receipt: json['receipt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'type': type,
      'amount': amount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'settled_at': settledAt?.toIso8601String(),
      'level': level,
      'level_period': levelPeriod,
      'receipt': receipt,
    };
  }
}
