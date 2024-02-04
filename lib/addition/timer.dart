import 'package:intl/intl.dart';

String getTime() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
  return formattedDate;
}
