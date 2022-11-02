import 'package:flutter/material.dart';
import 'package:freelancer_clone/services/auth.dart';

import '../services/global_variables.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailText = TextEditingController();
  final _resetFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.cyan,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _resetFormKey,
          child: Column(
            children: [
              const Text(
                'Forget password',
                style: TextStyle(
                    fontFamily: 'Signatra',
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                textInputAction: TextInputAction.done,
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
                  hintText: 'Email Address',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: () async {
                  if (_resetFormKey.currentState!.validate()) {
                    await Auth().forgetPassword(
                        email: _emailText.text.trim().toLowerCase(),
                        context: context);
                  }
                },
                color: Colors.cyan,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Reset',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
