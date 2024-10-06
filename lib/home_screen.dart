import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mill_info/balance_screen.dart';
import 'package:mill_info/input_screen.dart';
import 'package:mill_info/login_screen.dart';
import 'package:mill_info/shared_value.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic expencesPrice = 0, amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Our Mill"),
        centerTitle: true,
        // leading: const Text(""),
        actions: [
          TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BalanceScreen())),
              child: const Text("Balance")),
          if (userCategory.$ == "millManager")
            IconButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddData()),
                    ),
                icon: const Icon(Icons.add))
        ],
      ),
      drawer:  NavigationDrawer(

        children: [
          TextButton.icon(
            onPressed: () {
              userId.$ = "";
              userId.load();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) =>  const LoginSignupScreen()),
                      (Route route) => false);
            },
            label: const Text("Logout",style: TextStyle(fontSize: 17),),
            icon: const Icon(Icons.logout_outlined,size: 20,),
          )
        ],
      ),
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Date",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                "Details",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                "Price",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          //amount row

          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('millNames')
                  .doc(millId.$)
                  .collection('millNames')
                  .doc(millId.$)
                  .collection('millData')
                  .orderBy('dateTime', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Display a loading indicator while waiting for data
                } else if (snapshot.hasError) {
                  return const Center(child: Text("error")); // Handle errors
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text("data nai"),
                  ); // Handle the case when there's no data
                }
                return SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.80,
                  child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                    return Container(
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide())),
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        leading: Text(
                          document['time'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        title: Text(
                          document['details'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: Text(
                          " ${document['price']} TK",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  }).toList()),
                );
              })
        ],
      ),
      bottomSheet: Container(
        color: Colors.lightGreenAccent,
        height: 60,
        padding: const EdgeInsets.all(10),
        child: setAmount(),
      ),
    );
  }

  getReserveBalance() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('millNames')
          .doc(millId.$)
          .collection('balance')
          .get(),
      builder: (ctx, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            var balance = snapshot.data!.docs
                .map((e) => int.parse(e.data()['balance']))
                .toList();
            return Text("${getSum(balance) - getSum(amount)} TK",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
          }
        }
        // Displaying LoadingSpinner to indicate waiting state
        return const Center(
          child: SizedBox(
              width: 10, height: 10, child: CircularProgressIndicator()),
        );
      },
      // Future that needs to be resolved
      // inorder to display something on the Canvas
    );
  }

  setAmount() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('millNames')
          .doc(millId.$)
          .collection('millData')
          .get(),
      builder: (ctx, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            amount =
                snapshot.data!.docs.map((e) => int.parse(e.data()['price']));
            return Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Total Amount",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Text("Expenses Amount",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Text("Reserve Amount",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    getTotalAmount(),
                    Text("${getSum(amount)} TK",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    getReserveBalance()
                  ],
                ),
              ],
            );
          }
        }
        return const Center(
          child: SizedBox(
              width: 10, height: 10, child: CircularProgressIndicator()),
        );
      },
    );
  }
}

getTotalAmount() {
  return FutureBuilder(
    future: FirebaseFirestore.instance
        .collection('millNames')
        .doc(millId.$)
        .collection('balance')
        .get(),
    builder: (ctx, snapshot) {
      // Checking if future is resolved or not
      if (snapshot.connectionState == ConnectionState.done) {
        // If we got an error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              '${snapshot.error} occurred',
              style: const TextStyle(fontSize: 18),
            ),
          );
          // if we got our data
        } else if (snapshot.hasData) {
          // Extracting data from snapshot object
          var balance = snapshot.data!.docs
              .map((e) => int.parse(e.data()['balance']))
              .toList();
          return Text("${getSum(balance)} TK",
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
        }
      }

      // Displaying LoadingSpinner to indicate waiting state
      return const Center(
        child:
            SizedBox(width: 10, height: 10, child: CircularProgressIndicator()),
      );
    },

    // Future that needs to be resolved
    // inorder to display something on the Canvas
  );
}

getSum(amountB) {
  int sum = amountB.fold(0, (a, b) => a + b);
  return sum;
}
