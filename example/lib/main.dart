import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:near_wallet_selector/near_wallet_selector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kIsWeb) {
      NearWalletSelector().init("testnet", "test.testnet");
    }
  }

  final controller = NearWalletSelectorWidgetController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: kIsWeb
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () async {
                        NearWalletSelector().showSelector().then(
                          (value) {
                            print("Hide reason: $value");
                          },
                        );
                      },
                      child: const Text(
                        "Open Near Wallet Selector!",
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        final account = await NearWalletSelector().getAccount();
                        if (account == null) {
                          print("Account not found");
                          return;
                        }
                        print("Account: $account");
                      },
                      child: const Text(
                        "Get Account!",
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        NearWalletSelector().clearCredentials();
                      },
                      child: const Text(
                        "Clear Credentials!",
                      ),
                    ),
                  ],
                )
              : LayoutBuilder(builder: (context, constraints) {
                  return Stack(
                    children: [
                      FilledButton(
                        onPressed: () {
                          controller.toggleSelector();
                        },
                        child: const Text("Show Selector"),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          child: NearWalletSelectorWidget(
                            controller: controller,
                            network: "testnet",
                            contractId: "test.testnet",
                            redirectLink: "nearwalletselector://open.my.app",
                            modalHeight: constraints.maxHeight * 0.58,
                            onAccountFound: (account) {
                              print("onAccountFound: $account");
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }),
        ),
      ),
    );
  }
}
