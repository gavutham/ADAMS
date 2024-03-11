import 'package:adams/models/student.dart';
import 'package:adams/screens/wrapper.dart';
import 'package:adams/services/auth.dart';
import 'package:adams/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/utils/custom_snackbar.dart';
import 'common/utils/screen_size_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

void initializeUtilContexts(BuildContext context) {
  ScreenSizeUtil.context = context;
  CustomSnackBar.context = context;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    initializeUtilContexts(context);
    return StreamBuilder<StudentUser?>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        final user = snapshot.hasData ? snapshot.data : null;
        return StreamBuilder<StudentData?>(
          initialData: null,
          stream: DatabaseService(sid: user?.sid).studentData,
          builder: (context, snapshot) {
            return MultiProvider(
              providers: [
                StreamProvider<StudentUser?>.value(
                  value: AuthService().user,
                  initialData: null,
                ),
                StreamProvider<StudentData?>.value(
                  initialData: null,
                  value: DatabaseService(sid: user?.sid).studentData,
                )
              ],
              child: const MaterialApp(
                home: Wrapper(),
                debugShowCheckedModeBanner: false,
              ),
            );
          }
        );
      },
    );
  }
}

