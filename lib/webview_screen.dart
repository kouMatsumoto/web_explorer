import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  void _onPageStarted(String url) {
    print('_onPageStarted: $url');
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
        ),
      ),
    );
  }
}
