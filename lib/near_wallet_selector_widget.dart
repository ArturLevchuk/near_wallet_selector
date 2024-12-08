import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class _WebViewConstants {
  static const String widgetWebviewUrl =
      "http://localhost:8091/near_wallet_selector/assets/wallet-selector/dist/index.html";

  static const String documentRoot = 'packages';
}

final InAppLocalhostServer _localhostServer = InAppLocalhostServer(
  port: 8091,
  documentRoot: _WebViewConstants.documentRoot,
);

class NearWalletSelectorWidgetController extends ChangeNotifier {
  void toggleSelector() {
    notifyListeners();
  }
}


/// mobile use only
class NearWalletSelectorWidget extends StatefulWidget {
  const NearWalletSelectorWidget(
      {super.key,
      required this.controller,
      this.onAccountFound,
      required this.network,
      required this.contractId,
      required this.redirectLink});

  final NearWalletSelectorWidgetController controller;
  final Function(({String accountId, String privateKey})? account)?
      onAccountFound;
  final String network;
  final String contractId;
  final String redirectLink;

  @override
  State<NearWalletSelectorWidget> createState() =>
      _NearWalletSelectorWidgetState();
}

class _NearWalletSelectorWidgetState extends State<NearWalletSelectorWidget> {
  late final StreamSubscription appLinksSubscription;
  InAppWebViewController? webViewController;
  final InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllowFullscreen: true,
    useWideViewPort: false,
    cacheEnabled: false,
    clearCache: true,
    transparentBackground: true,
  );
  final Completer<bool> webViewReadyCompleter = Completer();
  bool widgetShow = false;

  @override
  void initState() {
    super.initState();
    final appLinks = AppLinks();
    appLinksSubscription = appLinks.stringLinkStream.listen(
      (link) async {
        if (link.contains(widget.redirectLink)) {
          final queryParamsStr = Uri.parse(link).query;
          webViewController?.loadUrl(
              urlRequest: URLRequest(
            url:
                WebUri("${_WebViewConstants.widgetWebviewUrl}?$queryParamsStr"),
          ));
        }
      },
    );
    widget.controller.addListener(toggleSelector);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_localhostServer.isRunning() && !kIsWeb) {
      await _localhostServer.start();
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
    }
  }

  Future<void> toggleSelector() async {
    await webViewReadyCompleter.future;

    if (widgetShow) {
      setState(() {
        widgetShow = false;
      });
      return;
    }

    setState(() {
      widgetShow = true;
    });

    callJSAsync("window.showSelector()").then(
      (value) {
        setState(() {
          widgetShow = false;
        });
      },
    );
  }

  Future<void> tryToGetAccount() async {
    final foundedAccount = await callJSAsync("window.getAccount()");
    if (foundedAccount != null) {
      final account = jsonDecode(foundedAccount);
      widget.onAccountFound?.call((
        accountId: account['accountId'] as String,
        privateKey: account['key'] as String
      ));
      await webViewController?.webStorage.localStorage.clear();
      await webViewController?.evaluateJavascript(
          source: "window.clearNearWalletSelectorCredentials()");
    }
  }

  Future<dynamic> callJSAsync(String function) async {
    final String functionBody = """
      var output = $function;
      await output;
      return output;
    """;
    final res = await webViewController?.callAsyncJavaScript(
      functionBody: functionBody,
    );
    return Future.value(res?.value);
  }

  @override
  void dispose() {
    appLinksSubscription.cancel();
    _localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (widgetShow)
            ModalBarrier(
              color: Colors.black54,
              onDismiss: () {
                setState(() {
                  widgetShow = false;
                });
              },
            ),
          AnimatedSlide(
            duration: const Duration(milliseconds: 250),
            offset: widgetShow ? const Offset(0, 0) : const Offset(0, 1),
            child: SizedBox(
              height: constraints.maxHeight * 0.58,
              child: InAppWebView(
                initialUrlRequest:
                    URLRequest(url: WebUri(_WebViewConstants.widgetWebviewUrl)),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onPermissionRequest: (controller, request) async {
                  return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                },
                onLoadStart: (controller, url) async {},
                onLoadStop: (controller, url) async {
                  await controller.callAsyncJavaScript(
                      functionBody:
                          """window.initWalletSelector("${widget.network}", "${widget.contractId}", "${widget.redirectLink}")""");
                  await tryToGetAccount();
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;

                  if ([
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    if (await canLaunchUrl(uri)) {
                      launchUrl(
                        uri,
                      );
                      setState(() {
                        widgetShow = false;
                      });

                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {},
                onLoadError: (controller, url, code, message) {
                  controller.reload();
                },
                onConsoleMessage: (controller, consoleMessage) {
                  if (consoleMessage.message
                      .contains("Wallet selector initialized")) {
                    webViewReadyCompleter.complete(true);
                  }
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
