import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatelessWidget {
  Future<void> _loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser.authentication;
      final credential =
          GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final auth = await FirebaseAuth.instance.signInWithCredential(credential);
      final data = {'email': auth.user.email};
      await FirebaseFirestore.instance.collection('users').doc(auth.user.uid).set(data);
    } catch (e) {
      print('Exception: ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Web Explorer')),
      body: Center(
        child: Container(
          height: 48,
          child: SignInButtonBuilder(
            icon: Icons.verified_user,
            backgroundColor: Colors.blue,
            text: 'Google Login',
            onPressed: () => _loginWithGoogle(),
          ),
        ),
      ),
    );
  }
}
