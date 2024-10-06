import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mill_info/get_user_information.dart';
import 'package:mill_info/screen_size.dart';
class MillScreen extends StatelessWidget {

  final dynamic id;

  MillScreen({super.key, this.id});
  final _formKey = GlobalKey<FormState>();
  final _millController = TextEditingController();
  final _borderController = TextEditingController();
  final _managerController = TextEditingController();

  var isNameValid = false.obs;
  var errorMsg = "".obs;
  List borderNames = [];

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("$screenHeight   $screenWidth");
    }
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
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
                          width: screenWidth(context) * 0.5,
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
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          // height: 200,
                          child: TextButton(
                              onPressed: () async {
                                if (_millController.text != "") {
                                  DocumentSnapshot snapshot =
                                      await FirebaseFirestore.instance
                                          .collection('millNames')
                                          .doc(_millController.text)
                                          .get();
                                  if (!snapshot.exists) {
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
                    TextFormField(
                      controller: _managerController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Border Email Address";
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(label: Text("Add Mill Manager")),
                    ),
                    isNameValid.value ? addUser(context) : const Text(""),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                            UserInformation(context);


                            },
                            child: const Text("Skip")),
                        TextButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                FirebaseFirestore.instance
                                    .collection('millNames')
                                    .doc(_millController.text)
                                    .set({
                                  'millBoder': borderNames,
                                  'millManager': _managerController.text,
                                });
                              UserInformation(context);

                              } else {
                                if (kDebugMode) {
                                  print("this is not validated");
                                }
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
                // if (snapShot == true) {

                borderNames.add(_borderController.text);
                if (kDebugMode) {
                  print(borderNames.first);
                }

                Fluttertoast.showToast(msg: "mill Border add successfully");

                // }else{
                //   Fluttertoast.showToast(msg: "Email address not match");
              }
              // }
            },
            child: const Text("Add")),
      ],
    );
  }
  // final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('user');
  //
  // Future<void> retrieveUsers() async {
  //   Future<QuerySnapshot> users = _usersCollection.get();
  //   users.then((QuerySnapshot querySnapshot) {
  //     for (var document in querySnapshot.docs) {
  //       Object? data = document.data();
  //       print('Document ID: ${document.id}');
  //       print('Data: $data');
  //     }
  //   });
  // }
}
