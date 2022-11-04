// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../services/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Auth().currentUser!.email.toString()),
            TextButton(
                onPressed: () async {
                  _showConfirmDialog();
                },
                child: const Text('logout')),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure to exit?'),
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
                  child: const Text('logout'))
            ],
          );
        }));
  }
}
