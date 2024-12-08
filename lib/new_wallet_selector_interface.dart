abstract interface class NearWalletSelectorInterface {
  Future<void> init(String network, String contractId);

  /// Returns type of hide reason, which can be `wallet-navigation` or `user-triggered`
  Future<String> showSelector();

  Future<({String accountId, String privateKey})?> getAccount();

  void clearCredentials();
}
