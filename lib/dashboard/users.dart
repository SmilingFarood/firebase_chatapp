import 'package:chat_app/models/single_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').limit(20).snapshots();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<SingleUser> _users = [];
          snapshot.data!.docs.map((element) {
            if (_auth.currentUser!.uid != element['uid']) {
              _users.add(SingleUser(
                fullName: element['fullName'],
                email: element['email'],
                imageUrl: element['photoUrl'],
                uid: element['uid'],
              ));
            }
          }).toList();

          return ListView.builder(
            itemCount: _users.length,
            itemBuilder: (ctx, i) {
              return myUserListTile(
                  fullName: _users[i].fullName,
                  email: _users[i].email,
                  photoUrl: _users[i].imageUrl);
            },
          );
        }),
      ),
    );
  }

  Widget myUserListTile(
      {required String fullName,
      required String email,
      required String? photoUrl}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(),
            ),
            child: photoUrl == null
                ? const Icon(Icons.person)
                : Image.network(
                    photoUrl,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullName),
                Text(email),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
      ),
    );
  }
}
