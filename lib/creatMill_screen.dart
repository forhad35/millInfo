import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:mill_info/homeScreen.dart';
import 'package:mill_info/screen_size.dart';

import 'adduser_screen.dart';

class MillScreen extends StatelessWidget {
  final dynamic id;

  MillScreen({super.key, this.id});
  final _formKey = GlobalKey<FormState>();
  final _millController = TextEditingController();
  final _borderController = TextEditingController();
  var isNameValid = false.obs;
  var errorMsg = "".obs;

  @override
  Widget build(BuildContext context) {
    print("$screenHeight"+"   $screenWidth");
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Obx(() => SizedBox(
              width: screenWidth(context),
              height: screenHeight(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: screenWidth(context)*0.5,
                        // height: 200,
                        child: TextFormField(
                          controller: _millController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Mill name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Mill Name',
                            errorText: errorMsg.value,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        // height: 200,
                        child: TextButton(
                            onPressed: () {
                              if (_millController.text != "") {
                                final snapShot = FirebaseFirestore.instance
                                    .collection('millNames')
                                    .doc(_millController.text)
                                    .isBlank;
                                if (snapShot == false) {
                                  isNameValid.value = true;
                                } else {
                                  errorMsg.value = "Name already exist";
                                }
                              }
                            },
                            child: const Text("Add")),
                      ),
                    ],
                  ),
                  isNameValid.value ? addUser(context) : const Text(""),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          },
                          child: const Text("Skip")),
                      TextButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddUser(id: _millController.text)));
                            }
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Next"))
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  addUser(context) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth(context) * 0.6,
          child: TextFormField(
            controller: _borderController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter Border Email Address";
              }
              return null;
            },
            decoration: const InputDecoration(label: Text("Add Mill Border")),
          ),
        ),
        TextButton(
            onPressed: () {
              if (_borderController.text != "") {
                final snapShot = FirebaseFirestore.instance
                    .collection('user')
                    .where('email', isEqualTo: _borderController.text)
                    .isBlank;
                // if (snapShot == true) {
                  var borderNames = [];
                  borderNames.add(_borderController.text);
                  print(borderNames.first);
                  FirebaseFirestore.instance
                      .collection('millNames')
                      .doc(_millController.text)
                      .set(({
                        'milBorder': _borderController.text,
                        'dateTime': FieldValue.serverTimestamp()
                      }))
                      .then((value) {
                    Fluttertoast.showToast(msg: "mill Border add successfully");
                  });
                // }else{
                  Fluttertoast.showToast(msg: "Email address not match");
                }
              // }
            },
            child: const Text("Add")),
      ],
    );
  }
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('user');

  Future<void> retrieveUsers() async {
    Future<QuerySnapshot> users = _usersCollection.get();
    users.then((QuerySnapshot querySnapshot) {
      for (var document in querySnapshot.docs) {
        Object? data = document.data();
        print('Document ID: ${document.id}');
        print('Data: $data');
      }
    });
  }
}
