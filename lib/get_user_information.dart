import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mill_info/shared_value.dart';

import 'home_screen.dart';

class UserInformation {
  UserInformation(BuildContext context) {
    findUserEmail(context);
  }
  findUserEmail(context) async {
    userId.load();
    if (userId.$ != "") {
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('user');
      DocumentSnapshot snapshot = await usersCollection.doc(userId.$).get();

      Map data = snapshot.data() as Map;
      searchByField(data["email"], context);
    }
  }

  searchByField(searchTerm, context) async {
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
          userCategory.$ = "millManager";
          millId.load();
          userCategory.load();
          // isComplete.value =true;

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else if (data['millBoder'].contains(searchTerm)) {
          print("millBoder");
          millId.$ = doc.id;
          userCategory.$ = "millBoder";
          millId.load();
          userCategory.load();
          // isComplete.value =true;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          // isComplete.value =true;
          print(searchTerm);
        }

        print(data['millBoder']);
        print(doc.id);
      }
    } else {
      print('No matching documents found');
    }
  }
}
