import 'overtime_record.dart';

class OvertimeRequestsPage {
  final List<OvertimeRecord> records;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;

  const OvertimeRequestsPage({
    required this.records,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasMore,
  });
}
