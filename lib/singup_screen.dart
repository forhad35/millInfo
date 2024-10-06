import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(" Our Mill",style: TextStyle(fontSize: 18,height: 10),),
              // Name field
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10,),



              // Email field
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10,),

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
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10,),

              // Signup button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var user = FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
                 //    FirebaseAuth auth = FirebaseAuth.instance;
                 // await   auth.createUserWithEmailAndPassword(
                 //            email: _emailController.text,
                 //            password: _passwordController.text)
                    if (kDebugMode) {
                      print("users data type :  ${user.runtimeType}");
                    }
                        user.then((value) {
                      // isLoading=false;
                      if (kDebugMode) {
                        print("this is print value : ${value.user!.uid}");
                      }
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
