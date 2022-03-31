import 'package:chat_app/models/authtype.dart';
import 'package:chat_app/widgets/custom_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  final Function(AuthType) authType;
  const SignIn({Key? key, required this.authType}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      //
    }
  }

  Future<void> _signIn() async {
    try {
      await auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate(
          [
            Text(
              'Sign In',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
            ),
            CustomTextFormField(
              title: 'Email',
              controller: _emailController,
            ),
            CustomTextFormField(
              title: 'Password',
              controller: _passwordController,
            ),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign in'),
            ),
            SignInButton(
              Buttons.Google,
              onPressed: _signInWithGoogle,
            ),
            TextButton(
              onPressed: () {
                widget.authType(AuthType.signup);
              },
              child: const Text('Sign Up'),
            )
          ],
        ))
      ],
    );
  }
}
