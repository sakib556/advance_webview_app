import 'package:advance_webview_app/web_view_screen.dart';
import 'package:advance_webview_app/webview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart WebView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: WebViewScreen(
          loginUrl: 'https://easyisp24.com/login',
          title: "Google",
          homeUrl: 'https://easyisp24.com'),
    );
  }
}
// https://easyisp24.com/login/