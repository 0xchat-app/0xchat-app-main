import 'package:intl/intl.dart';

class DiscoveryUtils {
  static String formatTimeAgo(int timestamp) {
    DateTime givenTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime currentTime = DateTime.now();
    Duration diff = currentTime.difference(givenTime);

    if (diff.inDays >= 1) {
      return 'a day ago';
    } else if (diff.inHours >= 12) {
      return '12 hours ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes >= 30) {
      return '30 minutes ago';
    } else if (diff.inMinutes >= 15) {
      return '15 minutes ago';
    } else {
      return formatTimestamp(timestamp);
    }
  }

  static String formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(date);
    return formattedDate;
  }
}
