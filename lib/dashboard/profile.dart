import 'dart:io';

import 'package:chat_app/misc/pick_image.dart';
import 'package:chat_app/widgets/custom_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _imageUrl = _auth.currentUser!.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Update Profile'),
        ),
        SliverList(
            delegate: SliverChildListDelegate(
          [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blueGrey,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() async {
                          _imageFile = await pickImage();
                        });
                      },
                      child: _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              fit: BoxFit.fill,
                            )
                          : _imageUrl != null
                              ? Image.network(
                                  _imageUrl!,
                                  fit: BoxFit.fill,
                                )
                              : const Icon(Icons.image),
                    ),
                  ),
                  CustomTextFormField(
                    title: 'Full Name',
                    controller: null,
                    validator: (val) {
                      return null;
                    },
                  )
                ],
              ),
            )
          ],
        ))
      ],
    );
  }
}
