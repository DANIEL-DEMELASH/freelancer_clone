import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_clone/screens/login_screen.dart';

import 'services/flutter_fire.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(
                    'Freelancer clone app is being initialized',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                        fontFamily: 'Signatra'),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                        fontFamily: 'Signatra'),
                  ),
                ),
              ),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Freelance Clone',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: Colors.black),
            home: const Root(),
          );
        }));
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Auth(auth: _auth).user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.uid == null) {
              return LoginScreen(auth: _auth);
            } else {
              // return Home(auth: _auth, firestore: _firebaseFirestore);
              return const Scaffold();
            }
          } else {
            return const Center(
              child: Text('loading...'),
            );
          }
        },
      ),
    );
  }
}
