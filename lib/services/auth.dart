import "package:adams/models/student.dart";
import "package:adams/services/database.dart";
import "package:firebase_auth/firebase_auth.dart";

class AuthService {
  final _auth = FirebaseAuth.instance;

  StudentUser? _studentUserFromFirebase(User? user) {
    return user != null ? StudentUser(sid: user.uid) : null;
  }

  Stream<StudentUser?> get user {
    return _auth.authStateChanges().map(_studentUserFromFirebase);
  }


  //sign in email/password
  Future studentSignIn(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _studentUserFromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  //register in email/password
  Future studentSignUp(String email, String password, String department, String year, String name) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await DatabaseService(sid: user!.uid).setStudentDetails(
        StudentData(department: department, email: email, name: name, sid: user.uid, year: year)
      );
      return _studentUserFromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch (err){
      print(err.toString());
      return null;
    }
  }
}

