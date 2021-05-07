import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  WebViewController _controller;

  Future<void> _onPageStarted(String url) async {
    final data = {
      'time': DateTime.now().toIso8601String(),
      'url': await _controller.currentUrl(),
      'title': await _controller.getTitle()
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('views')
        .add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WebView(
          initialUrl: 'https://www.google.com/',
          javascriptMode: JavascriptMode.unrestricted,
          debuggingEnabled: true,
          onPageStarted: _onPageStarted,
          onWebViewCreated: (controller) {
            _controller = controller;
          },
        ),
      ),
    );
  }
}
