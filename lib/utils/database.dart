import 'package:adams/utils/datetime.dart';

String getCurrentHour(String classDetails) {
  String currentHour = "/$classDetails/";
  currentHour += "${getFormattedDay()}/${getCurrentInterval()}";
  // currentHour += "${getFormattedDay()}/14:50:15:40";

  return currentHour;
}