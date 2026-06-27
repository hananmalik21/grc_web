import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Common date and time utilities used across the app.
@immutable
class DateTimeUtils {
  const DateTimeUtils._();

  static DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime? utcStringToLocal(String? s) {
    if (s == null || s.isEmpty) return null;
    try {
      final trimmed = s.trim();
      final hasTimezone = trimmed.endsWith('Z') || RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(trimmed);
      final toParse = hasTimezone ? trimmed : '$trimmed${trimmed.contains('T') ? '' : 'T00:00:00'}Z';
      return DateTime.parse(toParse).toLocal();
    } catch (_) {
      return null;
    }
  }

  static String localToUtcIso8601(DateTime local) {
    final wallClock = local.isUtc ? local.toLocal() : local;
    final utc = DateTime(
      wallClock.year,
      wallClock.month,
      wallClock.day,
      wallClock.hour,
      wallClock.minute,
      wallClock.second,
    ).toUtc();
    return utc.toIso8601String().replaceFirst(RegExp(r'\.\d+'), '');
  }

  /// Combines a local calendar date with a local time picker value.
  static DateTime combineLocalDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// Extracts the local calendar date from a stored instant.
  static DateTime? localDateFrom(DateTime? dateTime) {
    if (dateTime == null) return null;
    final local = dateTime.isUtc ? dateTime.toLocal() : dateTime;
    return DateTime(local.year, local.month, local.day);
  }

  /// Extracts local wall-clock time from a stored instant.
  static TimeOfDay? timeOfDayFrom(DateTime? dateTime) {
    if (dateTime == null) return null;
    final local = dateTime.isUtc ? dateTime.toLocal() : dateTime;
    return TimeOfDay(hour: local.hour, minute: local.minute);
  }

  static String localToIso8601WithOffset(DateTime local) {
    final offset = local.timeZoneOffset;
    final offsetHours = offset.inHours;
    final offsetMins = offset.inMinutes.remainder(60).abs();
    final sign = offsetHours >= 0 ? '+' : '-';
    final offsetStr = '$sign${offsetHours.abs().toString().padLeft(2, '0')}:${offsetMins.toString().padLeft(2, '0')}';
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    final sec = local.second.toString().padLeft(2, '0');
    return '$y-$m-${d}T$h:$min:$sec$offsetStr';
  }

  static String formatYmd(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static DateTime getWeekStart(DateTime date) {
    final normalized = normalizeDate(date);
    final weekday = normalized.weekday;
    return normalized.subtract(Duration(days: weekday - 1));
  }

  static DateTime getWeekEnd(DateTime date) {
    final startOfWeek = getWeekStart(date);
    return startOfWeek.add(const Duration(days: 6));
  }

  static bool isDateInRange({required DateTime start, required DateTime end, DateTime? today}) {
    final target = normalizeDate(today ?? DateTime.now());
    final normalizedStart = normalizeDate(start);
    final normalizedEnd = normalizeDate(end);

    return !target.isBefore(normalizedStart) && !target.isAfter(normalizedEnd);
  }

  static DateTime? parseLocalTimeString(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return null;
    try {
      return DateTime.parse(dateTimeStr);
    } catch (_) {
      return null;
    }
  }

  static DateTime? parseFlexibleDate(String? raw) {
    if (raw == null) return null;

    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final ymd = parseYmd(trimmed);
    if (ymd != null) return ymd;

    final direct = DateTime.tryParse(trimmed);
    if (direct != null) {
      return normalizeDate(direct.toLocal());
    }

    if (trimmed.length >= 10) {
      final fromDatePart = parseYmd(trimmed.substring(0, 10)) ?? DateTime.tryParse(trimmed.substring(0, 10));
      if (fromDatePart != null) {
        return normalizeDate(fromDatePart.toLocal());
      }
    }

    final fromUtc = utcStringToLocal(trimmed);
    if (fromUtc != null) {
      return normalizeDate(fromUtc);
    }

    const patterns = <String>['yyyy-MM-dd', 'dd/MM/yyyy', 'dd-MM-yyyy', 'MM/dd/yyyy', 'dd MMM yyyy', 'MMM dd, yyyy'];

    for (final pattern in patterns) {
      try {
        return normalizeDate(DateFormat(pattern).parseStrict(trimmed));
      } catch (_) {
        continue;
      }
    }

    return null;
  }

  static DateTime? parseYmd(String? raw) {
    if (raw == null) return null;

    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(raw.trim());
    if (match == null) return null;

    return DateTime(int.parse(match.group(1)!), int.parse(match.group(2)!), int.parse(match.group(3)!));
  }
}
