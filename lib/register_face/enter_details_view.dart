import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adams/common/utils/custom_snackbar.dart';
import 'package:adams/common/utils/custom_text_field.dart';
import 'package:adams/common/views/custom_button.dart';
import 'package:adams/constants/theme.dart';
import 'package:adams/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import "package:firebase_auth/firebase_auth.dart";

class EnterDetailsView extends StatefulWidget {
  final String image;
  final dynamic user;
  final FaceFeatures faceFeatures;
  const EnterDetailsView({
    Key? key,
    required this.user,
    required this.image,
    required this.faceFeatures,
  }) : super(key: key);

  @override
  State<EnterDetailsView> createState() => _EnterDetailsViewState();
}

class _EnterDetailsViewState extends State<EnterDetailsView> {
  bool isRegistering = false;
  // final _formFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Add Details"),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scaffoldTopGradientClr,
              scaffoldBottomGradientClr,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: "Register Now",
                  onTap: () {
                    dynamic id = FirebaseFirestore.instance.collection("students").doc(widget.user.sid).id;
                    if(id!=null) {
                      UserModel userModel = UserModel(
                        id: id,
                        image: widget.image,
                        registeredOn: DateTime
                            .now()
                            .millisecondsSinceEpoch,
                        faceFeatures: widget.faceFeatures,
                      );

                      FirebaseFirestore.instance
                          .collection("faces")
                          .doc(widget.user.sid)
                          .set(userModel.toJson())
                          .catchError((e) {
                        log("Registration Error: $e");
                        Navigator.of(context).pop();
                        CustomSnackBar.errorSnackBar(
                            "Registration Failed! Try Again.");
                      }).whenComplete(() {
                        Navigator.of(context).pop();
                        CustomSnackBar.successSnackBar("Registration Success!");
                        Future.delayed(const Duration(seconds: 1), () {
                          //Reaches HomePage
                          Navigator.of(context)
                            ..pop()..pop()..pop();
                        });
                      });
                    }
                    else{
                      print("User Null");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
