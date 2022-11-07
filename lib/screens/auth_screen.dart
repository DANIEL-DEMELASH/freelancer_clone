// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freelancer_clone/services/auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../services/global_variables.dart';
import 'forget_password_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final FocusNode _passFocusNode = FocusNode();
  final TextEditingController _emailText = TextEditingController(text: '');
  final TextEditingController _passwordText = TextEditingController(text: '');
  final _signupFormKey = GlobalKey<FormState>();

  File? imageFile;

  final TextEditingController _signupNameText = TextEditingController(text: '');
  final TextEditingController _signupEmailText =
      TextEditingController(text: '');
  final TextEditingController _signupPasswordText =
      TextEditingController(text: '');
  final TextEditingController _signupAddressText =
      TextEditingController(text: '');
  final TextEditingController _signupPhoneText =
      TextEditingController(text: '');

  final FocusNode _signupEmailFocusNode = FocusNode();
  final FocusNode _signupPassFocusNode = FocusNode();
  final FocusNode _signupPhoneFocusNode = FocusNode();
  final FocusNode _signupLocationFocusNode = FocusNode();

  bool _obscureText = true;
  late TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _emailText.dispose();
    _passwordText.dispose();

    _signupAddressText.dispose();
    _signupEmailText.dispose();
    _signupNameText.dispose();
    _signupPasswordText.dispose();
    _signupPhoneText.dispose();

    _signupEmailFocusNode.dispose();
    _signupLocationFocusNode.dispose();
    _signupPassFocusNode.dispose();
    _signupPhoneFocusNode.dispose();

    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: 45,
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'Login',
                    ),
                    Tab(
                      text: 'Signup',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_loginWidget(), _signupWidget()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(children: const [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.camera,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ]),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(children: const [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.image,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ]),
                ),
              ],
            ),
          );
        }));
  }

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  Widget _loginWidget() {
    return Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'WELCOME BACK.',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Email: ',
              style: TextStyle(fontSize: 15),
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              onEditingComplete: (() =>
                  FocusScope.of(context).requestFocus(_passFocusNode)),
              keyboardType: TextInputType.emailAddress,
              controller: _emailText,
              validator: (value) {
                if (!value!.contains('@') || value.isEmpty) {
                  return 'please enter a valid email address';
                }
                return null;
              },
              style: const TextStyle(color: Colors.black),
              decoration: textInputStyle.copyWith(
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(letterSpacing: 2)),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Password: ',
                  style: TextStyle(fontSize: 15),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgetPasswordScreen()));
                    },
                    child: const Text(
                      'Forget password?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              focusNode: _passFocusNode,
              obscureText: _obscureText,
              controller: _passwordText,
              validator: (value) {
                if (value!.isEmpty || value.length < 7) {
                  return 'password length must be at least 7';
                }
                return null;
              },
              style: const TextStyle(color: Colors.black),
              decoration: textInputStyle.copyWith(
                  hintText: 'Your password',
                  hintStyle: const TextStyle(letterSpacing: 2),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () async {
                if (_loginFormKey.currentState!.validate()) {
                  await Auth().signIn(
                      email: _emailText.text.trim().toLowerCase(),
                      password: _passwordText.text.trim(),
                      context: context);
                }
              },
              color: Colors.orange,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'LOG IN',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ));
  }

  Widget _signupWidget() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
      child: ListView(
        children: [
          Form(
              key: _signupFormKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showImageDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        width: size.width * 0.24,
                        height: size.width * 0.24,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Colors.cyanAccent),
                            shape: BoxShape.circle),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: imageFile == null
                              ? const Icon(
                                  Icons.camera_enhance_sharp,
                                  color: Colors.cyan,
                                  size: 30,
                                )
                              : Image.file(
                                  imageFile!,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onEditingComplete: (() => FocusScope.of(context)
                        .requestFocus(_signupEmailFocusNode)),
                    keyboardType: TextInputType.name,
                    controller: _signupNameText,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter a valid full name';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: textInputStyle.copyWith(
                        hintText: 'Full name/ Company name',
                        hintStyle: const TextStyle(letterSpacing: 2)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: _signupEmailFocusNode,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: (() => FocusScope.of(context)
                        .requestFocus(_signupPassFocusNode)),
                    keyboardType: TextInputType.emailAddress,
                    controller: _signupEmailText,
                    validator: (value) {
                      if (!value!.contains('@') || value.isEmpty) {
                        return 'please enter a valid email address';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: textInputStyle.copyWith(
                        hintText: 'Email Address',
                        hintStyle: const TextStyle(letterSpacing: 2)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    focusNode: _signupPassFocusNode,
                    obscureText: _obscureText,
                    controller: _signupPasswordText,
                    keyboardType: TextInputType.visiblePassword,
                    onEditingComplete: (() => FocusScope.of(context)
                        .requestFocus(_signupPhoneFocusNode)),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'password length must be at least 7';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: textInputStyle.copyWith(
                        hintText: 'Password',
                        hintStyle: const TextStyle(letterSpacing: 2),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: _signupPhoneFocusNode,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: (() => FocusScope.of(context)
                        .requestFocus(_signupLocationFocusNode)),
                    keyboardType: TextInputType.phone,
                    controller: _signupPhoneText,
                    validator: (value) {
                      if (value!.length < 9 || value.isEmpty) {
                        return 'please enter a valid phone number';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: textInputStyle.copyWith(
                        hintText: 'Phone number',
                        hintStyle: const TextStyle(letterSpacing: 2)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: _signupLocationFocusNode,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    controller: _signupAddressText,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter a valid location';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: textInputStyle.copyWith(
                        hintText: 'Company Address',
                        hintStyle: const TextStyle(letterSpacing: 2)),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (_signupFormKey.currentState!.validate() &&
                          imageFile != null) {
                        await Auth().createAccount(
                          email: _signupEmailText.text.trim().toLowerCase(),
                          password:
                              _signupPasswordText.text.trim().toLowerCase(),
                          imageFile: imageFile!,
                          name: _signupNameText.text.trim(),
                          phoneNumber: _signupPhoneText.text.trim(),
                          location: _signupAddressText.text,
                        );
                      }
                    },
                    color: Colors.orange,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'SIGN UP',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
