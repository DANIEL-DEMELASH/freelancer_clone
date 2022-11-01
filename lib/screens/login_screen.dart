import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_clone/screens/forget_password_screen.dart';
import 'package:freelancer_clone/screens/signup_screen.dart';
import 'package:freelancer_clone/services/flutter_fire.dart';
import 'package:freelancer_clone/services/global_variables.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.auth});

  final FirebaseAuth auth;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final FocusNode _passFocusNode = FocusNode();
  final TextEditingController _emailText = TextEditingController(text: '');
  final TextEditingController _passwordText = TextEditingController(text: '');

  bool _obscureText = true;
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: ((context, url, error) => const Icon(Icons.error)),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: Image.asset('assets/images/login.png'),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: (() => FocusScope.of(context)
                                .requestFocus(_passFocusNode)),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailText,
                            validator: (value) {
                              if (value!.contains('@') || value.isEmpty) {
                                return 'please enter a valid email address';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: textInputStyle.copyWith(
                              hintText: 'Email Address',
                            ),
                          ),
                          const SizedBox(
                            height: 5,
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
                            style: const TextStyle(color: Colors.white),
                            decoration: textInputStyle.copyWith(
                                hintText: 'Password',
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
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 15,
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
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (_loginFormKey.currentState!.validate()) {
                                final String result =
                                    await Auth(auth: widget.auth).signIn(
                                        email: _emailText.text
                                            .trim()
                                            .toLowerCase(),
                                        password: _passwordText.text
                                            .trim()
                                            .toLowerCase());
                                if (result == "Success") {
                                  _emailText.clear();
                                  _passwordText.clear();
                                } else {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(result),
                                  ));
                                }
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
                                    'Login',
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
                          Center(
                            child: RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: 'Don\'t have an account?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const TextSpan(text: '      '),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (() => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupScreen()))),
                                  text: 'Signup',
                                  style: const TextStyle(
                                      color: Colors.cyan,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                            ])),
                          )
                        ],
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
