import 'package:intl/intl.dart';

class DateUtils {
  // Date formats
  static const String defaultDateFormat = 'MM/dd/yyyy';
  static const String defaultTimeFormat = 'hh:mm a';
  static const String defaultDateTimeFormat = 'MM/dd/yyyy hh:mm a';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ssZ';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy hh:mm a';

  // Format date to string
  static String formatDate(DateTime date, {String? format}) {
    final formatter = DateFormat(format ?? defaultDateFormat);
    return formatter.format(date);
  }

  // Format time to string
  static String formatTime(DateTime time, {String? format}) {
    final formatter = DateFormat(format ?? defaultTimeFormat);
    return formatter.format(time);
  }

  // Format datetime to string
  static String formatDateTime(DateTime dateTime, {String? format}) {
    final formatter = DateFormat(format ?? defaultDateTimeFormat);
    return formatter.format(dateTime);
  }

  // Format date for display
  static String formatDateForDisplay(DateTime date) {
    return formatDate(date, format: displayDateFormat);
  }

  // Format datetime for display
  static String formatDateTimeForDisplay(DateTime dateTime) {
    return formatDateTime(dateTime, format: displayDateTimeFormat);
  }

  // Format date for API
  static String formatDateForApi(DateTime dateTime) {
    return formatDateTime(dateTime, format: apiDateTimeFormat);
  }

  // Parse date from string
  static DateTime? parseDate(String dateString, {String? format}) {
    try {
      final formatter = DateFormat(format ?? defaultDateFormat);
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Parse datetime from string
  static DateTime? parseDateTime(String dateTimeString, {String? format}) {
    try {
      final formatter = DateFormat(format ?? defaultDateTimeFormat);
      return formatter.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  // Parse date from API response
  static DateTime? parseDateFromApi(String dateTimeString) {
    return parseDateTime(dateTimeString, format: apiDateTimeFormat);
  }

  // Get current date
  static DateTime getCurrentDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // Get current datetime
  static DateTime getCurrentDateTime() {
    return DateTime.now();
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final today = getCurrentDate();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  // Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(getCurrentDate());
  }

  // Check if date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(getCurrentDate());
  }

  // Get difference in days
  static int getDifferenceInDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }

  // Get difference in hours
  static int getDifferenceInHours(
    DateTime startDateTime,
    DateTime endDateTime,
  ) {
    return endDateTime.difference(startDateTime).inHours;
  }

  // Get difference in minutes
  static int getDifferenceInMinutes(
    DateTime startDateTime,
    DateTime endDateTime,
  ) {
    return endDateTime.difference(startDateTime).inMinutes;
  }

  // Add days to date
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  // Add hours to datetime
  static DateTime addHours(DateTime dateTime, int hours) {
    return dateTime.add(Duration(hours: hours));
  }

  // Add minutes to datetime
  static DateTime addMinutes(DateTime dateTime, int minutes) {
    return dateTime.add(Duration(minutes: minutes));
  }

  // Get start of day
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  // Get relative time string (e.g., "2 days ago", "in 3 hours")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds} second${difference.inSeconds == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 0) {
      final futureDays = -difference.inDays;
      return 'in $futureDays day${futureDays == 1 ? '' : 's'}';
    } else if (difference.inHours < 0) {
      final futureHours = -difference.inHours;
      return 'in $futureHours hour${futureHours == 1 ? '' : 's'}';
    } else if (difference.inMinutes < 0) {
      final futureMinutes = -difference.inMinutes;
      return 'in $futureMinutes minute${futureMinutes == 1 ? '' : 's'}';
    } else {
      return 'just now';
    }
  }

  // Validate date range
  static bool isValidDateRange(DateTime startDate, DateTime endDate) {
    return startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate);
  }

  // Get duration between dates in human readable format
  static String getDurationString(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'}';
    } else {
      return 'Less than a minute';
    }
  }
}
