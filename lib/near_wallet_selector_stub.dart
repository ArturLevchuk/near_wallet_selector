import 'package:near_wallet_selector/new_wallet_selector_inteface.dart';

class NearWalletSelector implements NearWalletSelectorInterface {
  @override
  Future<void> init(String network, String contractId) async {
    throw Exception("Unimplemented");
  }

  @override
  Future<String> showSelector() {
    throw Exception("Unimplemented");
  }

  @override
  Future<({String accountId, String privateKey})> getAccount() async {
    throw Exception("Unimplemented");
  }

  @override
  void clearCredentials() {
    throw Exception("Unimplemented");
  }
}
