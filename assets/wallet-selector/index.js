import "@near-wallet-selector/modal-ui-js/styles.css";
import { setupWalletSelector } from "@near-wallet-selector/core";
import { setupMyNearWallet } from "@near-wallet-selector/my-near-wallet";
import { setupHereWallet } from "@near-wallet-selector/here-wallet";
import { setupMintbaseWallet } from "@near-wallet-selector/mintbase-wallet";
import { setupMeteorWallet } from "@near-wallet-selector/meteor-wallet";
import { setupModal } from "@near-wallet-selector/modal-ui-js";
import { clearNearWalletSelectorCredentials, getAccount } from "./utils/account_utils";

window.clearNearWalletSelectorCredentials = clearNearWalletSelectorCredentials;

window.initWalletSelector = async (network, contractId) => {
  const selector = await setupWalletSelector({
    network,
    modules: [
      setupMintbaseWallet(
        {
          networkId: network,
          contractId,
        }
      ),
      setupMyNearWallet(),
      setupHereWallet(),
      setupMeteorWallet(),
    ],
  });

  const modal = setupModal(selector, {
    contractId,
  });

  window.selector = selector;

  window.showSelector = () => {
    modal.show();
  };

  window.getAccount = getAccount;

  console.log("Wallet selector initialized");
}



