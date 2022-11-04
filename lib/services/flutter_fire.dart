import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import 'global_variables.dart';

Future uploadTask(
    {required String jobCategory,
    required String jobTitle,
    required String jobDescription,
    required String jobDeadlineDate,
    required BuildContext context}) async {
  final jobId = const Uuid().v4();
  User? user = FirebaseAuth.instance.currentUser;
  final uid = user!.uid;

  try {
    await FirebaseFirestore.instance.collection('jobs').doc(jobId).set({
      'jobId': jobId,
      'uploadedBy': uid,
      'email': user.email,
      'jobCategory': jobCategory,
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
      'jobDeadlineDate': jobDeadlineDate,
      'jobComments': [],
      'recruitment': true,
      'createdAt': Timestamp.now(),
      'name': name,
      'userImage': userImage,
      'location': location,
      'applicants': 0
    });
    await Fluttertoast.showToast(
        msg: 'The task has been uploaded',
        backgroundColor: Colors.green,
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG);
  } catch (e) {
    debugPrint(e.toString());
    await Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.green,
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG);
  }
}
