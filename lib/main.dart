import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_signin_button/button_builder.dart';

Future<UserCredential> signInWithGoogle() async {
  try {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    print('GoogleSignIn credential: ' + credential.toString());
    return await FirebaseAuth.instance.signInWithCredential(credential);

  } on Exception catch (e) {
    print('Exception: ' + e.toString());
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.useEmulator('http://localhost:9099'); // to use the auth emulator for testing
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Web Explorer', theme: ThemeData(primarySwatch: Colors.blue), home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User _user;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _user = null;
    });
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in! ' + user.toString());
        print('User is signed in! user.uid: ' + user.uid);
      }

      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Web Explorer')),
      body: _user != null ? WebViewLayout() : AuthLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

/// Provides a UI to select a authentication type page
class AuthLayout extends StatelessWidget {
  final _googleSignIn = new GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: SignInButtonBuilder(
              icon: Icons.verified_user,
              backgroundColor: Colors.orange,
              text: 'Sign In',
              onPressed: () => signInWithGoogle(),
            ),
          ),
        ],
      ),
    );
  }
}

class WebViewLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WebView(
          initialUrl: 'https://www.google.com/',
        ),
      ),
    );
  }
}
