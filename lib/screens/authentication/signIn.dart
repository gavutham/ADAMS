import 'package:adams/services/auth.dart';
import 'package:adams/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final void Function() toggleView;

  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey =GlobalKey<FormState>();

  final _auth = AuthService();

  //form values
  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        actions: [
          ElevatedButton(
            onPressed: widget.toggleView,
            child: const Text("Sign Up"),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 75),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: "Email"),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(hintText: "Password"),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                    error = "";
                  });
                  dynamic user = await _auth.studentSignIn(email, password);
                  if (user == null) {
                    setState(() {
                      loading = false;
                      error = "Can't sign in with given Credentials";
                    });
                  }
                },
                child: const Text("Sign In"),
              ),
              const SizedBox(height: 20,),
              Text(
                  error,
                  style: const TextStyle(
                      color: Colors.red
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
