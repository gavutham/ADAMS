import "package:intl/intl.dart";
import '../shared/constants.dart' as constants;

String getFormattedTime() {
  final hourFormat = DateFormat('Hm').format(DateTime.now());

  return hourFormat;
}

String getCurrentInterval() {
  String current = getFormattedTime();

  int i =0;
  while(i < constants.timePeriods.length) {
    final interval = constants.timePeriods[i];
    final [start, end] = interval.split("-");
    final [startHr, startMin] = start.split(":").map((s) => int.parse(s)).toList();
    final [endHr, endMin] = end.split(":").map((s) => int.parse(s)).toList();
    final [currentHr, currentMin] = current.split(":").map((s) => int.parse(s)).toList();

    if (currentHr >= startHr && currentHr <= endHr) {
      if (currentHr == startHr) {
        if (currentMin >= startMin) return constants.timePeriods[i];
      } else if (currentHr == endHr) {
        if (currentMin < endMin) return constants.timePeriods[i];
      } else {
        return constants.timePeriods[i];
      }
    }

    i+=1;
  }

  return "";
}

String getFormattedDate() {
  final now = DateTime.now();
  return "${now.day}-${now.month}-${now.year}";
}