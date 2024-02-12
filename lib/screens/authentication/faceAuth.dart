
import 'package:flutter/cupertino.dart';
import 'package:adams/services/auth.dart';
import 'package:adams/register_face/register_face_view.dart';
import "package:firebase_auth/firebase_auth.dart";
class FaceAuth extends StatefulWidget{
  final String email, password, department, year, name, section;
  const FaceAuth({Key? key,
    required this.email,
    required this.password,
    required this.department,
    required this.year,
    required this.name,
    required this.section}):super(key: key);
  @override
  State<FaceAuth> createState() => _FaceAuth();
}

class _FaceAuth extends State<FaceAuth>{
  final _auth = AuthService();

  late dynamic user;

  @override
  void initState() {
    super.initState();
    _registerUser();
  }

  Future<User> _registerUser() async {
    user = await _auth.studentSignUp(
      widget.email,
      widget.password,
      widget.department,
      widget.year,
      widget.name,
      widget.section,
    );
    setState(() {}); // Update the UI after user registration
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return (user == Null ? Text("Something went wrong! ") : RegisterFaceView(user: user));
  }

}