// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
          future: users.doc(uid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  Stack(children: [
                    Center(
                      child: Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image:
                                CachedNetworkImageProvider(data['userImage']),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        right: size.width / 2,
                        bottom: 0,
                        child: const CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ]),
                  const Spacer(),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(data['name']),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(data['email']),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(data['phone']),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () => _showConfirmDialog(),
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                  ),
                  const Divider(),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  void _showConfirmDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure to logout?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('cancel')),
              TextButton(
                  onPressed: () async {
                    await Auth().signOut(context);
                    Navigator.pop(context);
                  },
                  child: const Text('yes'))
            ],
          );
        }));
  }
}
