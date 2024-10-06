import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mill_info/home_screen.dart';
import 'package:mill_info/shared_value.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("View Balance"),
      ),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('millNames').doc(millId.$).collection('balance').orderBy('dateTime',descending: true).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Display a loading indicator while waiting for data
              } else if (snapshot.hasError) {
                return const Center(child:Text("error")); // Handle errors
              } else if (!snapshot.hasData) {
                return const Center(child: Text("data nai"),); // Handle the case when there's no data
              }
              return SizedBox(
                height: MediaQuery.sizeOf(context).height*0.80,
                child: ListView(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                      return  Container(
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          leading: Text(document['time'],style: const TextStyle(fontSize: 14
                          ),),
                          title:Text(document['details'],textAlign: TextAlign.center,style: const TextStyle(fontSize: 14
                          ),),
                          trailing : Text(" ${document['balance']} TK",style: const TextStyle(fontSize: 14
                          ),),

                        ),
                      );

                    }).toList()
                ),
              );

            }
        ),
      ),
      bottomSheet: Container(
        color: Colors.lightGreenAccent,
        height: 60,
        padding:EdgeInsets.all(10),
        child:  setAmount(),
      ),
    );
  }
  setAmount(){
    return  FutureBuilder(
      future:FirebaseFirestore.instance.collection('millNames').doc(millId.$).collection('balance').get(),
      builder: (ctx, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
          var  balance = snapshot.data!.docs.map((e) => int.parse(e.data()['balance'])).toList();
            return  Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Total Amount",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                Text("${getSum(balance)} TK",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),

              ],
            );
          }
        }

        // Displaying LoadingSpinner to indicate waiting state
        return Center(
          child: CircularProgressIndicator(),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
    );

  }
}
