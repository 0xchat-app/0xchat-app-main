
import 'package:ox_localizable/ox_localizable.dart';
import 'package:intl/intl.dart';

class OXDateUtils {

  static String formatTimestamp(int timestamp,{String pattern = 'yyyy-MM-dd HH:mm'}){
    var format = new DateFormat(pattern);
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    return format.format(date);
  }

  /// Returned "Yesterday" Today "Just" "a minute ago" "an hour ago"
  static String convertTimeFormatString2(int timestamp, {String pattern = 'MM-dd HH:mm'}){
    var format = new DateFormat('yyyy-MM-dd');
    var curDateString = format.format(DateTime.now());
    var curDateLoose = format.parse(curDateString);
    int todayTimeStamp = curDateLoose.millisecondsSinceEpoch;
    double time = (todayTimeStamp - timestamp)/1000;
    if(time <= 0){

      int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
      double t = (nowTimeStamp - timestamp)/1000;
      if(t <= 60){
        return Localized.text('ox_common.now');
      }
      else if(t > 60 && t < 60*60){
        return (t~/60).toString() + Localized.text('ox_common.oneminute');
      }
      else if(t >= 60*60 && t < 60*60*24){
        return (t~/(60*60)).toString() + Localized.text('ox_common.onehour');
      }
      return Localized.text('ox_common.today') + ' ' + formatTimestamp(timestamp, pattern : 'HH:mm');
    }
    else if(time > 0 && time <= 3600 * 24){
      return Localized.text('ox_common.yesterday') + ' ' + formatTimestamp(timestamp, pattern : 'HH:mm');
    }
    else{
      return formatTimestamp(timestamp, pattern : pattern);
    }
  }

  /// Returned "Just" "x minutes ago" "x hours ago" "x days ago" "x months ago" "x years ago"
  static String convertTimeFormatString3(int timestamp) {

    final oneSecond = 1;
    final oneMinute = oneSecond * 60;
    final oneHour = oneMinute * 60;
    final oneDay = oneHour * 24;
    final oneMonth = oneDay * 30;
    final oneYear = oneMonth * 12;

    final int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
    final double t = (nowTimeStamp - timestamp)/1000;

    if(t <= oneMinute){
      return Localized.text('ox_common.now');
    }
    else if(t > oneMinute && t < oneHour){
      return (t~/oneMinute).toString() + Localized.text('ox_common.oneminute');
    }
    else if(t >= oneHour && t < oneDay){
      return (t~/oneHour).toString() + Localized.text('ox_common.onehour');
    }
    else if(t >= oneDay && t < oneMonth){
      return (t~/oneDay).toString() + Localized.text('ox_common.oneday');
    }
    else if(t >= oneMonth && t < oneYear){
      return (t~/oneMonth).toString() + Localized.text('ox_common.onemonth');
    } else {
      return (t~/oneYear).toString() + Localized.text('ox_common.oneyear');
    }
  }

  /// Get Monthly copy
  static String monthString(int month) {
    if (month < 1 || month > 12) return '';
    final enMonthList = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    if (localized.localeType == LocaleType.zh || localized.localeType == LocaleType.zh_tw) {
      return '$month';
    } else {
      return enMonthList[--month];
    }
  }

  /// Get Daily copy
  static String dayString(int day, {separator = false}) {
    if (day < 1 || day > 31) return '';
    if (localized.localeType == LocaleType.zh || localized.localeType == LocaleType.zh_tw) {
      return '$day';
    } else {
      return '${separator ? ' ' : ''}$day';
    }
  }

  ///Get the 'Daily, Month for short', and the month localized, eg '28 Sep'
  static String getLocalizedMonthAbbreviation(int timestamp, {String locale = 'en'}) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String formattedDate = DateFormat('d MMM', locale).format(date);
    return formattedDate;
  }
}

extension YLCommon on DateTime {
  int get secondsSinceEpoch =>(DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();
}