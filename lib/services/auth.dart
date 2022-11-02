// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freelancer_clone/main.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String imageUrl = '';

  Future<void> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
      ));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createAccount({
    required String email,
    required String password,
    required File imageFile,
    required String name,
    required String location,
    required String phoneNumber,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final ref =
          FirebaseStorage.instance.ref().child('userImages').child('$uid.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'id': uid,
        'userImage': imageUrl,
        'name': name,
        'email': email,
        'phone': phoneNumber,
        'location': location,
        'createdAt': Timestamp.now()
      });
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgetPassword(
      {required String email, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: 'password reset email sent');
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => const Root())));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
