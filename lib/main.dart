import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './auth_screen.dart';
import './config.dart';
import './main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (isDevelopment) {
    await FirebaseAuth.instance.useEmulator('http://$hostToEmulator:9099');
    FirebaseFirestore.instance.settings = Settings(
      host: '$hostToEmulator:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );
  }
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Explorer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return MainScreen(user: snapshot.data);
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}
