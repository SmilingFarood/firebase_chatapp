import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chats extends StatelessWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
              FirebaseAuth.instance.currentUser!.displayName ?? 'Null Name'),
        ),
        Center(
          child: Text(FirebaseAuth.instance.currentUser!.email ?? 'Null email'),
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          child: const Text('Logout'),
        )
      ],
    );
  }
}
