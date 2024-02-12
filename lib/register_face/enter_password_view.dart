// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:adams/common/utils/custom_text_field.dart';
// import 'package:adams/common/views/custom_button.dart';
// import 'package:adams/common/utils/custom_snackbar.dart';
// import 'package:adams/constants/theme.dart';
// import 'package:adams/model/password_model.dart';
// import 'package:adams/register_face/register_face_view.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// class EnterPasswordView extends StatelessWidget {
//   EnterPasswordView({Key? key}) : super(key: key);
//
//   final TextEditingController _controller = TextEditingController();
//   final _formFieldKey = GlobalKey<FormFieldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     // print("STEP1");
//     return Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: appBarColor,
//           title: const Text("Enter Password"),
//           elevation: 0,
//         ),
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 scaffoldTopGradientClr,
//                 scaffoldBottomGradientClr,
//               ],
//             ),
//           ),
//           child: Center(
//             child: SingleChildScrollView(
//               physics: const NeverScrollableScrollPhysics(),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CustomTextField(
//                     formFieldKey: _formFieldKey,
//                     controller: _controller,
//                     hintText: "Password",
//                     validatorText: "Enter password to proceed",
//                   ),
//                   CustomButton(
//                     text: "Continue",
//                     onTap: () async {
//                       if (_formFieldKey.currentState!.validate()) {
//                         FocusScope.of(context).unfocus();
//                         FirebaseFirestore.instance
//                             .collection("password")
//                             .doc("PG0eZfMW5FfkOy5JCXuS")
//                             .get()
//                             .then((snap) {
//                           Password password = Password.fromJson(snap.data()!);
//                           if (password.password == _controller.text.trim()) {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => const RegisterFaceView(user: null),
//                               ),
//                             );
//                           } else {
//                             CustomSnackBar.errorSnackBar("Wrong Password :( ");
//                           }
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//   }
// }
