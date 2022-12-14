import 'package:flutter/material.dart';

String loginUrlImage = 'https://wallpapercave.com/wp/wp2019259.jpg';
String signupUrlImage = 'https://wallpaperaccess.com/full/1393537.jpg';
const InputDecoration textInputStyle = InputDecoration(
    hintStyle: TextStyle(color: Colors.black54),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    errorBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)));

List<String> jobCategories = [
  'Architecture and Construction',
  'Education and Training',
  'Development and Programming',
  'Business',
  'Information Technology',
  'Human Resources',
  'Marketing',
  'Design'
];

String name = '';
String userImage = '';
String location = '';
