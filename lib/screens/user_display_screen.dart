import 'package:flutter/material.dart';

import '../services/auth.dart';

class Display extends StatelessWidget {
  const Display({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Auth().currentUser!.email.toString()),
              TextButton(
                  onPressed: () async {
                    await Auth().signOut(context);
                  },
                  child: const Text('logout'))
            ],
          ),
        ));
  }
}
