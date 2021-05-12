import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  void _logout() {
    Future<dynamic>.delayed(Duration.zero).then((dynamic _) => FirebaseAuth.instance.signOut());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser.photoURL)),
            title: const Text('Account'),
            subtitle: Text(FirebaseAuth.instance.currentUser.email),
            trailing: IconButton(icon: Icon(Icons.logout), onPressed: _logout),
          ),
        ),
      ],
    );
  }
}
