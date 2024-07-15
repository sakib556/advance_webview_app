import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String loginUrl;
  final String homeUrl;
  final String title;

  const WebViewScreen(
      {super.key,
      required this.loginUrl,
      required this.title,
      required this.homeUrl});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  int loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    _controller = WebViewController();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('document.body.innerText',
          onMessageReceived: (message) async {
        // Save the token to SharedPreferences
        print("mesage from req is : ");
        print(message.message);
        print("endingggggggggggg");
        // await prefs.setString('token', message.message);
        // await prefs.setBool('isLoggedIn', true);
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              loadingPercentage = 100;
            });
            final response = await _controller
                .runJavaScriptReturningResult('document.body.innerText');
            // Save the token to SharedPreferences
            print("response from req is : ");
            print(response.toString());
            print("endingggggggggggg");
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              loadingPercentage = 0;
            });
          },
        ),
      );
    !isLoggedIn
        ? _controller.loadRequest(Uri.parse(widget.loginUrl))
        : _controller.loadRequest(Uri.parse(widget.homeUrl));
  }

  @override
  Widget build(BuildContext context) {
    print("loadingPercentage");
    print(loadingPercentage);
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              loadingPercentage != 100
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.red,
                      color: Colors.blue,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blueAccent,
                      ),
                      value: loadingPercentage.toDouble(),
                    )
                  : const SizedBox(),
              Expanded(child: WebViewWidget(controller: _controller)),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;
  final VoidCallback onReloadPressed;

  const CustomAppBar({
    required this.title,
    required this.onBackPressed,
    required this.onReloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onReloadPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
