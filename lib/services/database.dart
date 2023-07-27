import "package:adams/models/student.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class DatabaseService {
  String? sid;
  
  final CollectionReference studentDataCollection = FirebaseFirestore.instance.collection("students");

  DatabaseService({required this.sid});

  StudentData _studentDataFromFirebase(Map data) {
    return StudentData(
      department: data["department"] ?? "",
      email: data["email"] ?? "",
      sid: data["sid"] ?? "",
      year: data["year"] ?? "",
      name: data["name"] ?? "",
    );
  }

  Future setStudentDetails(StudentData student) async {
      final stuRef = studentDataCollection.doc(sid);
      final studentData = {
        "department": student.department,
        "email": student.email,
        "name": student.name,
        "sid": student.sid,
        "year": student.year,
      };
      return await stuRef.set(studentData);
  }

  Stream<StudentData?> get studentData {
    return studentDataCollection.doc(sid).snapshots().map((snap) => _studentDataFromFirebase(snap.data()! as Map));
  }

}