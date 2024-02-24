library datetime_helper;

import 'dart:convert';

import 'package:intl/intl.dart';

class DateTimeHelper {
  static var date = DateTime.now().toString();
  static var dateParse = DateTime.parse(date);

  static String dateTimeStamp() {
    var date = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd-HH:mm");
    String updatedDate = newFormat.format(date).toString();
    return updatedDate;
  }

}
