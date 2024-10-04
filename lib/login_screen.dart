import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mill_info/creatMill_screen.dart';
import 'package:mill_info/singup_screen.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoginMode = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  FirebaseAuth auth = FirebaseAuth.instance;
                 await auth
                      .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MillScreen(id: value.user!.uid)));
                  }).catchError((error){
                    Fluttertoast.showToast(msg: "$error");
                   });
                  // isLoading=false;
                  // // toastMessage('Sing up success');
                  // if(isChecked.$){
                  // sharedEmail.$ = _EmailController.text;
                  // sharedEmail.save();
                  // sharedPass.$ = _PassController.text;
                  // sharedPass.save();
                  //
                  //
                  // }

                  print("isclicked");
                }
              },
              child: Text(_isLoginMode ? 'Login' : 'Signup'),
            ),

            // Switch between login and signup modes
            TextButton(
              onPressed: () {
                setState(() {
                  // _isLoginMode = !_isLoginMode;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                });
              },
              child: const Text('Signup'),
            )

            // ... other form fields as needed
          ],
        ),
      ),
    );
  }

  // ... other form fields and logic
}
