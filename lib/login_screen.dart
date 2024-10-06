import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mill_info/create_mill_screen.dart';
import 'package:mill_info/get_user_information.dart';
import 'package:mill_info/shared_value.dart';
import 'package:mill_info/singup_screen.dart';

import 'home_screen.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserInformation(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login our millInfo",
                style: TextStyle(fontSize: 17, height: 10),
              ),
              // Email field
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    await auth
                        .signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text)
                        .then((value) {
                      userId.$ = value.user!.uid;
                      userId.load();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MillScreen(id: value.user!.uid)));
                    }).catchError((error) {
                      Fluttertoast.showToast(msg: "$error");
                    });

                    print("isclicked");
                  }
                },
                child: Text('Login'),
              ),

              // Switch between login and signup modes
              TextButton(
                onPressed: () {
                  setState(() {
                    // _isLoginMode = !_isLoginMode;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  });
                },
                child: const Text('Signup'),
              )

              // ... other form fields as needed
            ],
          ),
        ),
      ),
    );
  }

  // ... other form fields and logic
}
