import 'dart:convert';
import 'dart:js_interop';

@JS('window.initWalletSelector')
external JSPromise _initWalletSelector(String network, String contractId);

@JS('window.showSelector')
external void _showSelector();

@JS('window.getAccount')
external JSPromise<JSString?> _getAccount();

@JS('window.clearNearWalletSelectorCredentials')
external void _clearNearWalletSelectorCredentials();

class NearWalletSelector {
  bool _inited = false;
  static NearWalletSelector? _instance;
  NearWalletSelector._();
  factory NearWalletSelector() {
    return _instance ??= NearWalletSelector._();
  }

  Future<void> init(String network, String contractId) async {
    try {
      await (_initWalletSelector(network, contractId).toDart);
      _inited = true;
    } catch (_) {
      rethrow;
    }
  }

  void showSelector() {
    if (!_inited) {
      throw Exception("Wallet selector not inited");
    }
    _showSelector();
  }

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

  void clearCredentials() {
    _clearNearWalletSelectorCredentials();
  }
}
