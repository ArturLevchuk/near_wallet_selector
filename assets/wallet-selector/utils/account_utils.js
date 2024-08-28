import ls from "local-storage";
import * as nearAPI from "near-api-js";

export async function getAccount() {
  const network = window.selector.options.network.networkId;
  const accountId = window.selector.store.getState().accounts[0]?.accountId;

  if (!accountId || !network) {
    return null;
  }

  const keyPair = await getKeyPair(network, accountId);

  // const { selectedWalletId } = window.selector.store.getState();

  if (!keyPair) {
    return null;
  }
  return JSON.stringify({
    accountId,
    key: keyPair.toString(),
  });
}

export function clearNearWalletSelectorCredentials() {
  for (let i = localStorage.length - 1; i >= 0; i--) {
    const key = localStorage.key(i);
    if (key.startsWith("near") || key.startsWith("_meteor_wallet") || key.startsWith("herewallet") || key.startsWith("mintbase")) {
      localStorage.removeItem(key);
    }
  }
}

async function getKeyPair(network, accountId) {
  const keyStore = new nearAPI.keyStores.BrowserLocalStorageKeyStore();
  const keyPair = await keyStore.getKey(network, accountId);
  if (keyPair) {
    return keyPair;
  }

  try {
    const hereKeystore = ls.get("herewallet:keystore");
    if (hereKeystore) {
      return nearAPI.KeyPair.fromString(
        hereKeystore[network].accounts[accountId]
      );
    }
  } catch {}

  try {
    const meteorKey = ls.get(`_meteor_wallet${accountId}:${network}`);
    if (meteorKey) {
      return nearAPI.KeyPair.fromString(meteorKey);
    }
  } catch {}

  return null;
}
