// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen(
      {super.key,
      required this.profileImage,
      required this.fullName,
      required this.phoneNumber,
      required this.emailAddress,
      required this.location});

  final String profileImage;
  final String fullName;
  final String phoneNumber;
  final String emailAddress;
  final String location;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? imageFile;
  final _emailText = TextEditingController();
  final _phoneText = TextEditingController();
  final _nameText = TextEditingController();
  final _locationText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailText.text = widget.emailAddress;
    _phoneText.text = widget.phoneNumber;
    _nameText.text = widget.fullName;
    _locationText.text = widget.location;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.red,
            )),
        actions: [
          IconButton(
              onPressed: () async {
                await Auth().updateProfile(
                    name: _nameText.text.trim(),
                    email: _emailText.text.trim(),
                    phone: _phoneText.text.trim(),
                    location: _locationText.text.trim(),
                    isImageChanged: imageFile == null ? false : true,
                    image: imageFile ?? File(''));
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              icon: const Icon(
                Icons.save,
                color: Colors.orange,
              ))
        ],
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _showImageDialog();
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Container(
                    width: size.width * 0.24,
                    height: size.width * 0.24,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.cyanAccent),
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: imageFile == null
                          ? Image.network(widget.profileImage)
                          : Image.file(
                              imageFile!,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text('Full name'),
            TextFormField(
              controller: _nameText,
            ),
            const Spacer(),
            const Text('Email Address'),
            TextFormField(
              controller: _emailText,
            ),
            const Spacer(),
            const Text('Phone number'),
            TextFormField(
              controller: _phoneText,
            ),
            const Spacer(),
            const Text('Address'),
            TextFormField(
              controller: _locationText,
            ),
            const Spacer(
              flex: 5,
            ),
          ],
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
}
