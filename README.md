## Package for the ability to use Near Wallet Selector in Flutter for Web.

## Features

- Calling modal window to select wallet
- Extracting account data

## Getting started

To use the package, add the following to index.html:

```html
<script
  type="module"
  src="/assets/packages/near_wallet_selector/assets/wallet-selector/dist/bundle.js"
  defer
></script>
```

## Usage

Before using methods to show selector and get account, wallet selector must be initialized with network type and smart contract id.

```dart
NearWalletSelector().init("testnet", "test.testnet");
```

To show selector, use `showSelector` method:

```dart
NearWalletSelector().showSelector();
```

After selecting wallet and logging in, you will return to your app. You need to initialize wallet selector again and after that you can use `getAccount` method to get account data.

```dart
NearWalletSelector().init("testnet", "test.testnet");
final account = await NearWalletSelector().getAccount();
```
