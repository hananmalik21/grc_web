import 'history_entry_data.dart';

class RequisitionHistoryTabConfig {
  RequisitionHistoryTabConfig._();

  static List<HistoryEntryData> get mockHistory => [
    HistoryEntryData(
      action: 'CREATED',
      timestamp: '2026-04-01 09:30 AM',
      description: 'Requisition created',
      performedBy: 'Sarah Chen',
    ),
    HistoryEntryData(
      action: 'SUBMITTED',
      timestamp: '2026-04-01 10:15 AM',
      description: 'Submitted for approval',
      performedBy: 'Sarah Chen',
    ),
    HistoryEntryData(
      action: 'APPROVED',
      timestamp: '2026-04-02 02:20 PM',
      description: 'Level 1 approval - Hiring Manager',
      performedBy: 'Sarah Chen',
    ),
    HistoryEntryData(
      action: 'APPROVED',
      timestamp: '2026-04-03 11:45 AM',
      description: 'Level 2 approval - Department Head',
      performedBy: 'Tom Wilson',
    ),
    HistoryEntryData(
      action: 'APPROVED',
      timestamp: '2026-04-04 03:10 PM',
      description: 'Level 3 approval - HR Manager',
      performedBy: 'Lisa Anderson',
    ),
    HistoryEntryData(
      action: 'APPROVED',
      timestamp: '2026-04-05 09:00 AM',
      description: 'Level 4 approval - Finance Manager',
      performedBy: 'Michael Roberts',
    ),
    HistoryEntryData(
      action: 'OPENED',
      timestamp: '2026-04-05 02:30 PM',
      description: 'Requisition opened for applications',
      performedBy: 'Mike Johnson',
    ),
    HistoryEntryData(
      action: 'POSTED',
      timestamp: '2026-04-06 10:00 AM',
      description: 'Posted to Internal Career Site, External Career Site',
      performedBy: 'Mike Johnson',
    ),
    HistoryEntryData(
      action: 'POSTED',
      timestamp: '2026-04-07 01:00 PM',
      description: 'Posted to LinkedIn',
      performedBy: 'Mike Johnson',
    ),
  ];

  static const int pageSize = 10;
}
