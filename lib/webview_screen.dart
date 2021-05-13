import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> saveView({String url, String title, String time}) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('views')
      .add(<String, String>{'time': time, 'url': url, 'title': title});
}

class WebViewScreen extends StatefulWidget {
  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebViewScreen> {
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  Future<bool> _onBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }

    // NOTE: if true application can be closed
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () => _onBack(context),
          child: Center(
            child: WebView(
              initialUrl: 'https://www.google.com/',
              javascriptMode: JavascriptMode.unrestricted,
              debuggingEnabled: true,
              gestureNavigationEnabled: true,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onPageFinished: (url) async {
                await saveView(url: url, title: await _controller.getTitle(), time: DateTime.now().toIso8601String());
              },
            ),
          )),
    );
  }
}
