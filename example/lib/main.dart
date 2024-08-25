import 'package:flutter/material.dart';
import 'package:near_wallet_selector/near_wallet_selector.dart';

void main() {
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
    NearWalletSelector().init("testnet", "test.testnet");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () async {
                  NearWalletSelector().showSelector();
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
          ),
        ),
      ),
    );
  }
}
