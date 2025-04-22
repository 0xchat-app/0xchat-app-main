import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../navigator/navigator.dart';
import '../widgets/common_hint_dialog.dart';

extension NIP46ConnectionStatusEx on NIP46ConnectionStatus {
  String get text {
    switch (this) {
      case NIP46ConnectionStatus.connected:
        return 'Signer connected';
      case NIP46ConnectionStatus.disconnected:
        return 'Signer disconnected. Please make sure the signer app is open.';
      case NIP46ConnectionStatus.connecting:
        return 'Connecting to signer...';
      case NIP46ConnectionStatus.waitingForSigning:
        return 'Waiting for signature approval...';
      case NIP46ConnectionStatus.approvedSigning:
        return 'Signature approved.';
    }
  }
}

class NIP46StatusNotifier {
  factory NIP46StatusNotifier() => sharedInstance;
  static final NIP46StatusNotifier sharedInstance = NIP46StatusNotifier._internal();

  NIP46StatusNotifier._internal();

  NIP46ConnectionStatus? _lastStatus;
  NIP46ConnectionStatus? _previousStatus;

  bool _isDialogShowing = false;
  Timer? _debounceTimer;

  String? _currentUserPubkey;

  void notify(NIP46ConnectionStatus status, UserDBISAR user) {
    if (_currentUserPubkey != null && _currentUserPubkey != user.pubKey) {
      _lastStatus = null;
      _previousStatus = null;
    }
    _currentUserPubkey = user.pubKey;

    if (user.remoteSignerURI == null) return;

    bool isSigningState = status == NIP46ConnectionStatus.approvedSigning || status == NIP46ConnectionStatus.waitingForSigning;
    if (!isSigningState && _lastStatus == status) return;

    _lastStatus = status;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _showStatusDialog(status);
    });
  }

  Future<void> _showStatusDialog(NIP46ConnectionStatus status) async {
    if (status == NIP46ConnectionStatus.connected &&
        _previousStatus != NIP46ConnectionStatus.disconnected) {
      _previousStatus = status;
      return;
    }

    _previousStatus = status;

    if (_isDialogShowing) {
      OXNavigator.pop(OXNavigator.navigatorKey.currentContext!);
      _isDialogShowing = false;
    }

    _isDialogShowing = true;

    await OXCommonHintDialog.show(
      OXNavigator.navigatorKey.currentContext!,
      title: Localized.text('ox_common.tips'),
      content: status.text,
      actionList: [
        OXCommonHintAction.sure(
          text: Localized.text('ox_common.confirm'),
          onTap: () {
            _isDialogShowing = false;
            OXNavigator.pop(OXNavigator.navigatorKey.currentContext!, true);
          },
        ),
      ],
      isRowAction: true,
      barrierDismissible: false,
    );

    _isDialogShowing = false;
  }

  void dispose() {
    _debounceTimer?.cancel();
    _lastStatus = null;
    _isDialogShowing = false;
  }

  static Future<bool> remoteSignerTips(String content) async {
    return await OXCommonHintDialog.show(
      OXNavigator.navigatorKey.currentContext!,
      title: Localized.text('ox_common.tips'),
      content: content,
      actionList: [
        OXCommonHintAction.cancel(
          onTap: () => OXNavigator.pop(OXNavigator.navigatorKey.currentContext!, false),
        ),
        OXCommonHintAction.sure(
          text: Localized.text('ox_common.confirm'),
          onTap: () => OXNavigator.pop(OXNavigator.navigatorKey.currentContext!, true),
        ),
      ],
      isRowAction: true,
      barrierDismissible: false,
    );
  }
}
