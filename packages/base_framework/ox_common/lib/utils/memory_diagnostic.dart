// Memory diagnostic for locating Linux memory leak (e.g. 4GB spike).
// In debug mode, logs current page + cache sizes every 60s so that when user
// reports high memory, logs show which page and cache sizes at that time.

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/widgets/common_network_image.dart';

class MemoryDiagnostic {
  MemoryDiagnostic._();

  /// Current page/route name; set by key pages (e.g. ChatMessagePage, ChatSessionListPage).
  static String? currentPage;

  static Timer? _timer;

  /// Start periodic log (currentPage + sizeCache length + sessionMap length). Debug only.
  static void startPeriodicLog() {
    if (!kDebugMode) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      final sizeCacheLen = OXCachedImageProviderEx.sizeCacheLength;
      final sessionMapLen = OXChatBinding.sharedInstance.sessionMap.length;
      debugPrint(
          'MEMORY_DIAG currentPage=$currentPage sizeCacheLen=$sizeCacheLen sessionMapLen=$sessionMapLen');
    });
  }

  static void stopPeriodicLog() {
    _timer?.cancel();
    _timer = null;
  }
}
