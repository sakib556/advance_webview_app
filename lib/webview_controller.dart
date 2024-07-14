import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebController extends GetxController {
  late final WebViewController _webViewController;
  var _currentUrl = ''.obs;
  var _currentTitle = ''.obs;
  var _navigationDelegate = NavigationDecision.navigate.obs;

  WebController() {
    _webViewController = WebViewController();
  }

  // WebController get webViewController => _webViewController;
  RxString get currentUrl => _currentUrl;
  RxString get currentTitle => _currentTitle;
  Rx<NavigationDecision> get navigationDelegate => _navigationDelegate;

  void loadUrl(String url) {
    _webViewController.loadRequest(Uri.parse(url));
  }

  void reload() {
    _webViewController.reload();
  }

  void goBack() {
    _webViewController.goBack();
  }

  void setJavaScriptMode(JavaScriptMode mode) {
    _webViewController.setJavaScriptMode(mode);
  }

  // void setInitialUrl(String url) {
  //   _webViewController.setInitialUrl(Uri.parse(url).toString());
  // }

  void setNavigationDelegate(NavigationDelegate delegate) {
    _webViewController.setNavigationDelegate(delegate);
  }

  @override
  void onInit() {
    super.onInit();
    // Additional initialization if needed
  }

  @override
  void onClose() {
    //_webViewController.can();
    super.onClose();
  }
}
