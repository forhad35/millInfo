import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mill_info/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
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
            // Name field
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
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

            // Signup button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var user = FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
               //    FirebaseAuth auth = FirebaseAuth.instance;
               // await   auth.createUserWithEmailAndPassword(
               //            email: _emailController.text,
               //            password: _passwordController.text)
                  print("users data type :  ${user.runtimeType}");
                      user.then((value) {
                    // isLoading=false;
                    print("this is print value : ${value.user!.uid}");
                    addUserData(value.user!.uid);
                    // toastMessage('Sing up success');
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginSignupScreen()),
                        (route) => false);
                    // setState(() {});
                  }).catchError((error) {
                    // isLoading = false;
                    Fluttertoast.showToast( msg: error.toString());

                    setState(() {});
                  });
                  // Perform signup logic here

                  // _nameController.clear();
                  // _emailController.clear();
                  // _passwordController.clear();
                }
              },
              child: const Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }

  addUserData(String uid)  {
    var firebase =  FirebaseFirestore.instance;
    firebase.collection('user').doc(uid).set({
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'dateTime': FieldValue.serverTimestamp()
    }).then((value) => Fluttertoast.showToast(msg: 'Successfully Added'));
  }
  // ... other form fields and logic
}
