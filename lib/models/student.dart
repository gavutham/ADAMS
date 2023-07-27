class StudentUser {
  String sid;
  StudentUser({required this.sid});
}

class StudentData {
  String department;
  String email;
  String name;
  String section;
  String sid;
  String year;

  StudentData({
    required this.department,
    required this.email,
    required this.section,
    required this.sid,
    required this.year,
    required this.name
  });
}
