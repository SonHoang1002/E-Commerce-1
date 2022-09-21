import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

String getTime() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
  return formattedDate;
}
