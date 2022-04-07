import 'dart:io';

import 'package:chat_app/dashboard/chats.dart';
import 'package:chat_app/dashboard/groups.dart';
import 'package:chat_app/dashboard/profile.dart';
import 'package:chat_app/dashboard/users.dart';
import 'package:chat_app/misc/pick_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance.ref();
  bool _hasChecked = false;

  void _requestNotificationpermision() async {
    _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    RemoteMessage? _initialMessage = await _messaging.getInitialMessage();
  }

  Future<void> _setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(
        context, '/chat',
        // arguments: ChatArguments(message),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _requestNotificationpermision();
    _setupInteractedMessage();
  }

  @override
  void didChangeDependencies() async {
    if (!_hasChecked) {
      String? _imageUrl;

      if (auth.currentUser!.photoURL == null) {
        File? _userDisplayPhoto = await pickImage();
        final _imageRef =
            _storage.child('user_display_image/${auth.currentUser!.uid}.jpg');
        if (_userDisplayPhoto != null) {
          await _imageRef.putFile(_userDisplayPhoto);
          _imageUrl = await _imageRef.getDownloadURL();
        }
        auth.currentUser!.updatePhotoURL(_imageUrl);
      }
      setState(() {
        _hasChecked = true;
      });
    }
    super.didChangeDependencies();
  }

  int _index = 0;
  final List<Widget> _screens = const [
    Chats(),
    Groups(),
    Users(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (val) {
          setState(() {
            _index = val;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.green,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
