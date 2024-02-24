library datetime_helper;

import 'dart:convert';

import 'package:intl/intl.dart';

class DateTimeHelper {
  static const String MARKETING_ACTIVITY_DATE_FORMAT = "yyyy-M-d";
  static var date = new DateTime.now().toString();
  static var dateParse = DateTime.parse(date);
  static String dateFormatter(DateTime date) {
    dynamic dayData =
        '{ "1" : "Mon", "2" : "Tue", "3" : "Wed", "4" : "Thur", "5" : "Fri", "6" : "Sat", "7" : "Sun" }';

    dynamic monthData =
        '{ "1" : "Jan", "2" : "Feb", "3" : "Mar", "4" : "Apr", "5" : "May", "6" : "June", "7" : "Jul", "8" : "Aug", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" }';

    return json.decode(dayData)['${date.weekday}'] +
        ", " +
        date.day.toString() +
        " " +
        json.decode(monthData)['${date.month}'] +
        " " +
        date.year.toString();
  }

  static int getWeekDay(String week) {
    dynamic dayData =
        '{ "1" : "Mon", "2" : "Tue", "3" : "Wed", "4" : "Thur", "5" : "Fri", "6" : "Sat", "7" : "Sun" }';
    return json.decode(dayData)['$week'];
  }

  static String getMonthName(int month) {
    dynamic monthData =
        '{ "1" : "January", "2" : "February", "3" : "March", "4" : "April", "5" : "May", "6" : "June", "7" : "July", "8" : "August", "9" : "September", "10" : "October", "11" : "November", "12" : "December" }';
    return json.decode(monthData)['${month}'];
  }

  static String getPreviousYear() {
    var prevYear = dateParse.year - 1;
    return prevYear.toString();
  }

  static String getCurrentYear() {
    var year = dateParse.year;
    return year.toString();
  }

  static String getNextYear() {
    var year = dateParse.year + 1;
    return year.toString();
  }

  static int getCurrentMonth() {
    return dateParse.month;
  }

  static int monthForDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return dateTime.month;
  }

  static String dateTimeStamp() {
    var date = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd-HH:mm:ss");
    String updatedDate = newFormat.format(date).toString();
    print(updatedDate);
    return updatedDate;
  }

  static String dateTimeStampMin() {
    var date = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd-HH:mm");
    String updatedDate = newFormat.format(date).toString();
    print(updatedDate);
    return updatedDate;
  }

  static String timeStamp() {
    var date = DateTime.now();
    var newFormat = DateFormat("HH:mm");
    String updatedDate = newFormat.format(date).toString();
    return updatedDate;
  }

  static String convertFormat(String date) {
    DateTime _date = DateTime.parse(date);
    var outputFormat = DateFormat('yyyy-d-M');
    String outputDate = outputFormat.format(_date);
    return outputDate;
  }

  static String convertToTime(String? date) {
    DateTime _date = DateTime.parse(date!);
    String outputFormat = DateFormat.jm().format(_date);
    return outputFormat;
  }

  static DateTime convertFormatMonth(String date) {
    DateTime tempDate = new DateFormat("yyyy-M-dd").parse(date);
    // var outputFormat = DateFormat('yyyy-MM-dd');
    // String outputDate = outputFormat.format(tempDate);
    return tempDate;
  }

  static String convertFormatMonthString(String date) {
    DateTime tempDate = new DateFormat("yyyy-M-dd").parse(date);
    var outputFormat = DateFormat('yyyy-M-d');
    String outputDate = outputFormat.format(tempDate);
    return outputDate;
  }

  static String convertDateFormat(String? date) {
    DateTime tempDate = new DateFormat("yyyy-M-dd").parse(date!);
    var outputFormat = DateFormat('yyyy-MM-dd');
    String outputDate = outputFormat.format(tempDate);
    return outputDate;
  }

  static String stringFromDate(DateTime date, {String format = "yyyy-MM-dd"}) {
    var newFormat = DateFormat(format, 'en');
    String updatedDt = newFormat.format(date);
    return updatedDt;
  }

  static bool checkIfCurrentDate(DateTime date) {
    String selectedDate = stringFromDate(date);
    String currentDate = stringFromDate(DateTime.now());
    if (selectedDate == currentDate) {
      return true;
    } else {
      return false;
    }
  }

  static String formDateFromComponents(int year, int month, String day) {
    String _month = month < 10 ? "0" + month.toString() : month.toString();
    String date = year.toString() + "-" + _month + "-" + day;
    return date;
  }

  static int getNumberOfDaysFromMonth(int month, int year) {
    DateTime dateTime = DateTime(year, month, 0).toUtc();
    return DateTime(year, month + 1, 0).toUtc().difference(dateTime).inDays;
  }

  int getWeekOfMonth(DateTime weekDate, int month, int year) {
    int weekDay = DateTime(year, month, 1).weekday;
    int weekOfMonth;
//  If your calender starts from Monday
    weekDay--;
    weekOfMonth = ((weekDate.day + weekDay) / 7).ceil();
    print('Week of the month: $weekOfMonth');
    weekDay++;
    // If your calender starts from sunday
//     if (weekDay == 7) {
//       weekDay = 0;
//     }
//     weekOfMonth = ((testDate.day + weekDay) / 7).ceil();
    return weekOfMonth;
  }

  List<DateTime> getAllDatesForMonth(int month, int year) {
    List<DateTime> dateList = [];
    int noOfDays = DateTimeHelper.getNumberOfDaysFromMonth(month, year);
    for (int days = 1; days <= noOfDays; days++) {
      dateList.add(DateTime(year, month, days));
    }
    return dateList;
  }

  static String convertFormatSingleDay(String date) {
    DateTime tempDate = new DateFormat("yyyy-M-dd").parse(date);
    var outputFormat = DateFormat('yyyy-M-d');
    String outputDate = outputFormat.format(tempDate);
    return outputDate;
  }

  static String convertDateFormatToString(String date) {
    DateTime tempDate = new DateFormat("yyyy-M-dd").parse(date);
    var outputFormat = DateFormat('yyyy-MM-dd');
    String outputDate = outputFormat.format(tempDate);
    return outputDate;
  }
}
