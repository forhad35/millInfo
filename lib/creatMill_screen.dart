import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mill_info/homeScreen.dart';
import 'package:mill_info/screen_size.dart';
import 'package:mill_info/shared_value.dart';

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
    print("$screenHeight" + "   $screenWidth");
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
                            border: OutlineInputBorder(),
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
                            findUserEmail(context);

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const HomeScreen()));
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
                              findUserEmail(context);
                              // Fluttertoast.showToast(msg: "${value}");
                              // findUserInThiMill();

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             CheckUser(millId: _millController.text)));
                            } else {
                              print("this is not validated");
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

  findUserEmail(context) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('user');
    DocumentSnapshot snapshot = await usersCollection.doc(id).get();

    Map data = snapshot.data() as Map;
    searchByField(data["email"], context);
  }

  void searchByField(searchTerm, context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to your collection
    CollectionReference collectionRef = firestore.collection('millNames');
    QuerySnapshot snapshot = await collectionRef.get();

    // Query to search for the value
    // QuerySnapshot querySnapshot = await collectionRef.where('millManager', isEqualTo: searchTerm).get();

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // List millBoder = data['millBoder'] as List;

// print(data['millBoder'].where(searchTerm));
// print(millBoder);
        // print("this is mill boder check   ${data['borderName'].where("dd@gmail.com").isBlank}");
        if (searchTerm == data['millManager']) {
          print("millManager");
          millId.$ = doc.id;
          userCategory.$= "millManager";
          millId.load();
          userCategory.load();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const HomeScreen()));
        } else if (data['millBoder'].contains(searchTerm)) {
          print("millBoder");
          millId.$ = doc.id;
          userCategory.$="millBoder";
          millId.load();
          userCategory.load();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen()));
        } else {
          print(searchTerm);
        }

        print(data['millBoder']);
        print(doc.id);
      }
    } else {
      print('No matching documents found');
    }
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
                print(borderNames.first);

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
