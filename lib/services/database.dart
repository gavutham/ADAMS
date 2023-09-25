import "package:adams/models/student.dart";
import "package:adams/utils/database.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class DatabaseService {
  String? sid;
  
  final CollectionReference studentDataCollection = FirebaseFirestore.instance.collection("students");
  final CollectionReference attendanceCollection = FirebaseFirestore.instance.collection("attendance");
  final CollectionReference timetableCollection = FirebaseFirestore.instance.collection("timetable");

  DatabaseService({required this.sid});

  StudentData _studentDataFromFirebase(Map data) {
    return StudentData(
      department: data["department"] ?? "",
      email: data["email"] ?? "",
      section: data["section"] ?? "",
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
        "section": student.section,
        "sid": student.sid,
        "year": student.year,
      };
      return await stuRef.set(studentData);
  }

  Future<bool> markAttendance(StudentData student,String date, String time) async {
    try{
      final attendanceRef = attendanceCollection
          .doc(student.department)
          .collection(student.section)
          .doc(student.sid)
          .collection(date)
          .doc(time);
      await attendanceRef.update({"present": true});
      return true;
    }catch (err){
      print(err);
      return false;
    }
  }

  Future getCurrentHourDetails(String classDetails) async {
    try {
      final docRef = timetableCollection
          .doc(getCurrentHour(classDetails));
      final snapshot = await docRef.get();
      return snapshot.data();
    }catch (err) {
      print(err);
      return null;
    }
  }

  Stream<StudentData?> get studentData {
    return studentDataCollection.doc(sid).snapshots().map((snap) => _studentDataFromFirebase(snap.data()! as Map));
  }

}