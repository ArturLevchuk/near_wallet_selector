import 'dart:convert';
import 'dart:js_interop';

import 'package:near_wallet_selector/new_wallet_selector_interface.dart';

@JS('initWalletSelector')
external JSPromise _initWalletSelector(String network, String contractId);

@JS('showSelector')
external JSPromise<JSString> _showSelector();

@JS('getAccount')
external JSPromise<JSString?> _getAccount();

@JS('clearNearWalletSelectorCredentials')
external void _clearNearWalletSelectorCredentials();

class NearWalletSelector implements NearWalletSelectorInterface {
  bool _inited = false;
  static NearWalletSelector? _instance;
  NearWalletSelector._();
  factory NearWalletSelector() {
    return _instance ??= NearWalletSelector._();
  }

  @override
  Future<void> init(String network, String contractId) async {
    try {
      await (_initWalletSelector(network, contractId).toDart);
      _inited = true;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<String> showSelector() async {
    if (!_inited) {
      throw Exception("Wallet selector not inited");
    }
    final hideReason = await _showSelector().toDart;
    return hideReason.toDart;
  }

  @override
  Future<({String accountId, String privateKey})?> getAccount() async {
    if (!_inited) {
      throw Exception("Wallet selector not inited");
    }
    final accountRaw = await (_getAccount().toDart);
    if (accountRaw == null) {
      return null;
    }
    final account = jsonDecode(accountRaw.toDart);
    return (
      accountId: account['accountId'] as String,
      privateKey: account['key'] as String
    );
  }

  @override
  void clearCredentials() {
    _clearNearWalletSelectorCredentials();
  }
}
