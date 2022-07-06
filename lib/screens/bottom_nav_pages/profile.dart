import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _ageController;

  void logout() async {
    FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  setDataToTextField(data) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController =
              TextEditingController(text: data['name']),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: _phoneController =
              TextEditingController(text: data['phone']),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: _ageController = TextEditingController(text: data['age']),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () => updateData(),
          child: const Text("Update"),
        ),
        ElevatedButton(
          onPressed: () {
            logout();
          },
          child: const Text("LogOut"),
        ),
      ],
    );
  }

  updateData() {
    // ignore: no_leading_underscores_for_local_identifiers
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _nameController!.text,
      "phone": _phoneController!.text,
      "age": _ageController!.text,
      // ignore: avoid_print
    }).then((value) => Fluttertoast.showToast(msg: "Update Successfully."));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users-form-data")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var data = snapshot.data;
            if (data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return setDataToTextField(data);
          },
        ),
      )),
    );
  }
}
