import 'package:chat_app/models/authtype.dart';
import 'package:chat_app/widgets/custom_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:string_validator/string_validator.dart';

class SignUp extends StatefulWidget {
  final Function(AuthType) authType;
  const SignUp({Key? key, required this.authType}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await auth.signInWithCredential(credential);
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      UserCredential _userCred = await auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await _userCred.user!.updateDisplayName(_nameController.text);

      _userCred.additionalUserInfo!.username;
      print(_userCred.additionalUserInfo!.username);
      print(_userCred.user!.displayName);
      print(_userCred.user);
    } on FirebaseAuthException catch (e) {
      print('This is Firebase E: ${e.credential}');
    } catch (e) {
      print('Second error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate(
            [
              Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
              CustomTextFormField(
                title: 'Name',
                keyboardType: TextInputType.name,
                controller: _nameController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter full name';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                title: 'Email',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter your email Address';
                  }
                  if (!isEmail(val)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                title: 'Phone Number',
                keyboardType: TextInputType.phone,
                controller: _phoneNumberController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter your Phone Number';
                  }
                  if (!isNumeric(val)) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                title: 'Password',
                obscureText: true,
                controller: _passwordController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter your password';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                title: 'Confirm Password',
                validator: (val) {
                  if (val != _passwordController.text) {
                    return 'Password Mismatch';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _signUp,
                child: const Text('Sign Up'),
              ),
              SignInButton(
                Buttons.Google,
                onPressed: _signInWithGoogle,
              ),
              TextButton(
                onPressed: () {
                  widget.authType(AuthType.signin);
                },
                child: const Text('Sign In'),
              )
            ],
          ))
        ],
      ),
    );
  }
}
