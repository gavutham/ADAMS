import 'package:adams/utils/datetime.dart';

String getCurrentHour(String classDetails) {
  String currentHour = "/$classDetails/";
  String timeInterval = getCurrentInterval();

  if (timeInterval == "") return "";

  currentHour += "${getFormattedDay()}/$timeInterval";
  return currentHour;
}