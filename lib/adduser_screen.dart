import 'package:flutter/material.dart';

class AddUser extends StatelessWidget {
  final dynamic id;

  const AddUser( {super.key,this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("$id"),
      ),
    );
  }
}
