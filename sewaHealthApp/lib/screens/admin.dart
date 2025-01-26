
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminWidget extends StatefulWidget {
  const AdminWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AdminWidgetState();

}

class AdminWidgetState<StatefulWidget> extends State<AdminWidget>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: Column(
              children: [
                const Text("Admin"),
                const SizedBox(height: 24.0),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: const Text("Back")),
              ],
            ),
          ),
        ),
      )
    );
  }
}