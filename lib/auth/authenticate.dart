import 'package:chat_app/auth/sign_in.dart';
import 'package:chat_app/auth/sign_up.dart';
import 'package:chat_app/models/authtype.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  AuthType _authType = AuthType.signin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: _authType == AuthType.signin
              ? SignIn(
                  authType: (val) {
                    setState(() {
                      _authType = val;
                    });
                  },
                )
              : SignUp(authType: (val) {
                  setState(() {
                    _authType = val;
                  });
                }),
        ),
      ),
    );
  }
}
