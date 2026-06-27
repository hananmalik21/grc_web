import 'package:intl/intl.dart';

String formatIsoDateToDisplay(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) return '—';
  try {
    final date = DateTime.parse(isoDate);
    return DateFormat('dd/MM/yyyy').format(date);
  } catch (_) {
    return isoDate;
  }
}

String formatKwd(double? value) {
  if (value == null) return '—';
  return '${NumberFormat('#,##0.000').format(value)} KWD';
}

String displayValue(String? value) => (value != null && value.trim().isNotEmpty) ? value.trim() : '—';
