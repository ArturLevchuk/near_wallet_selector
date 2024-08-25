class NearWalletSelector {
  static NearWalletSelector? _instance;
  NearWalletSelector._();
  factory NearWalletSelector() {
    return _instance ??= NearWalletSelector._();
  }

  Future<void> init(String network, String contractId) async {
    throw Exception("Unimplemented");
  }

  void showSelector() {
    throw Exception("Unimplemented");
  }

  Future<({String accountId, String privateKey})> getAccount() async {
    throw Exception("Unimplemented");
  }

  void clearCredentials() {
    throw Exception("Unimplemented");
  }
}
