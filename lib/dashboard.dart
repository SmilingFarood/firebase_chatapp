import 'package:chat_app/dashboard/chats.dart';
import 'package:chat_app/dashboard/groups.dart';
import 'package:chat_app/dashboard/profile.dart';
import 'package:chat_app/dashboard/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  void _requestNotificationpermision() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  Future lalala() async {
    print(auth.currentUser!.displayName);
    auth.currentUser!.getIdToken().then((value) {
      print('This is ID token: $value');
    });
  }

  @override
  void initState() {
    super.initState();
    _requestNotificationpermision();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a notification');
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _screens[_index],
          ElevatedButton(
            onPressed: lalala,
            child: const Text('press'),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (val) {
          setState(() {
            _index = val;
          });
        },
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
