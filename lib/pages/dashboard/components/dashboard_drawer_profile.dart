import 'dart:io';
import 'dart:typed_data';

import 'package:aski/models/posts_model.dart';
import 'package:aski/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DashboardDrawerProfile extends StatefulWidget {
  final UserModel? user;

  const DashboardDrawerProfile({super.key, this.user});

  //const DashboardDrawerProfile({super.key});

  @override
  State<DashboardDrawerProfile> createState() => _DashboardDrawerProfileState();
}

class _DashboardDrawerProfileState extends State<DashboardDrawerProfile> {
  bool _isLoadLogout = false;
  Uint8List? _selectedImage;

  ImageProvider? renderProfilePicture() {
    return _selectedImage != null
        ? MemoryImage(_selectedImage!)
        : const AssetImage('images/profile_image.jpg') as ImageProvider;
  }

  Future<void> pickingImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      final Uint8List imageFinal = await image!.readAsBytes();

      /// Taking as Uint8List because MemoryImage takes this data type. SO
      /// I used readAsBytes() to cast image which is XFile as Uint8List
      setState(() {
        _selectedImage = imageFinal;
      });
      final uid = FirebaseAuth.instance.currentUser!.uid;

      /// Now upload the image to Firebase storage.
      final storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child("images/profile/$uid");
      await fileRef.putData(_selectedImage!);
      // String link = await fileRef.getDownloadURL();
      // return link;
    } catch (err) {
      // String e = err.toString();
      const snackBar = SnackBar(
        content: Text("Image is erring!"),
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> logout(BuildContext context) async {
    setState(() {
      _isLoadLogout = true;
    });
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.popUntil(
        context,
        ModalRoute.withName("/"),
      );
    }
    setState(() {
      _isLoadLogout = false;
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: MediaQuery.of(context).orientation == Orientation.portrait
                ? 2
                : 6,
            child: DrawerHeader(
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: CircleAvatar(
                      minRadius: MediaQuery.of(context).size.width / 8,
                      maxRadius: MediaQuery.of(context).size.width / 4,
                      backgroundColor: const Color.fromARGB(255, 178, 175, 175),
                      backgroundImage: renderProfilePicture(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.user == null
                          ? "Username"
                          : '${widget.user!.firstName} ${widget.user!.lastName}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 30,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: MediaQuery.of(context).orientation == Orientation.portrait
                ? 3
                : 4,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              children: [
                ExpansionTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Settings"),
                    ],
                  ),
                  children: [
                    ListTile(
                      title: TextButton(
                        onPressed: pickingImage,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Change Profile"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    logout(context);
                  },
                  child: _isLoadLogout
                      ? const CircularProgressIndicator()
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Icon(Icons.logout_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Logout"),
                            ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
