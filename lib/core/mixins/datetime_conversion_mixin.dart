import 'package:intl/intl.dart';

mixin DateTimeConversionMixin {
  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  String formatDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  String formatDateTimeWithSeconds(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  String formatDateFromDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    try {
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  String formatDateTimeFromDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    try {
      return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  String formatDateCustom(String? dateString, String pattern) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat(pattern).format(dateTime);
    } catch (e) {
      return dateString;
    }
  }
}
