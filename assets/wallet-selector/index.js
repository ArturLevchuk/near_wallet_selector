import "@near-wallet-selector/modal-ui-js/styles.css";
import { setupWalletSelector } from "@near-wallet-selector/core";
import { setupMyNearWallet } from "@near-wallet-selector/my-near-wallet";
import { setupSender } from "@near-wallet-selector/sender";
import { setupHereWallet } from "@near-wallet-selector/here-wallet";
import { setupMintbaseWallet } from "@near-wallet-selector/mintbase-wallet";
import { setupMeteorWallet } from "@near-wallet-selector/meteor-wallet";
import { setupNightly } from "@near-wallet-selector/nightly";
import { setupModal } from "@near-wallet-selector/modal-ui-js";
import { clearNearWalletSelectorCredentials, getAccount } from "./utils/account_utils";

window.clearNearWalletSelectorCredentials = clearNearWalletSelectorCredentials;

window.initWalletSelector = async (network, contractId) => {
  const selector = await setupWalletSelector({
    network,
    modules: [
      setupMintbaseWallet(),
      setupMyNearWallet(),
      setupSender(),
      setupHereWallet(),
      setupMeteorWallet(),
      setupNightly(),
    ],
  });

  const modal = setupModal(selector, {
    contractId,
  });

  window.showSelector = () => {
    modal.show();
  };

  window.getAccount = getAccount;

  console.log("Wallet selector initialized");
}



