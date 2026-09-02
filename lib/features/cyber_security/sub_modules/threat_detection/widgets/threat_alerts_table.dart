import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/dialogs/threat_investigation_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/models/threat_alert_model.dart';

enum ThreatFilterTab {
  all,
  new_,
  investigating,
  closed,
}

class ThreatAlertsTable extends StatefulWidget {
  final List<ThreatAlertModel> alerts;
  final ValueChanged<ThreatAlertModel>? onInvestigate;

  const ThreatAlertsTable({
    super.key,
    required this.alerts,
    this.onInvestigate,
  });

  @override
  State<ThreatAlertsTable> createState() => _ThreatAlertsTableState();
}

class _ThreatAlertsTableState extends State<ThreatAlertsTable> {
  ThreatFilterTab _selectedTab = ThreatFilterTab.all;

  List<ThreatAlertModel> get _filteredAlerts {
    switch (_selectedTab) {
      case ThreatFilterTab.all:
        return widget.alerts;
      case ThreatFilterTab.new_:
        return widget.alerts
            .where((a) => a.status == ThreatStatus.new_)
            .toList();
      case ThreatFilterTab.investigating:
        return widget.alerts
            .where((a) => a.status == ThreatStatus.investigating)
            .toList();
      case ThreatFilterTab.closed:
        return widget.alerts
            .where((a) => a.status == ThreatStatus.closed)
            .toList();
    }
  }

  void _openInvestigation(ThreatAlertModel alert) {
    if (widget.onInvestigate != null) {
      widget.onInvestigate!(alert);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => ThreatInvestigationDialog(
          alert: alert,
          onStatusChanged: (newStatus) {
            setState(() {
              // Status updated
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAlerts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Tabs
        Row(
          children: [
            _buildTabButton('ALL', ThreatFilterTab.all),
            const Gap(8),
            _buildTabButton('NEW', ThreatFilterTab.new_),
            const Gap(8),
            _buildTabButton('INVESTIGATING', ThreatFilterTab.investigating),
            const Gap(8),
            _buildTabButton('CLOSED', ThreatFilterTab.closed),
          ],
        ),
        const Gap(16),

        // Table Container
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: [
              // Header Row
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B132B).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                  border: const Border(
                    bottom: BorderSide(color: Color(0xFF1E293B)),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: _buildHeaderLabel('ALERT ID'),
                    ),
                    Expanded(
                      flex: 4,
                      child: _buildHeaderLabel('TITLE'),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: _buildHeaderLabel('SEVERITY'),
                    ),
                    SizedBox(
                      width: 90.w,
                      child: _buildHeaderLabel('SOURCE'),
                    ),
                    SizedBox(
                      width: 90.w,
                      child: _buildHeaderLabel('TIME'),
                    ),
                    SizedBox(
                      width: 110.w,
                      child: _buildHeaderLabel('STATUS'),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              // Data Rows
              if (filtered.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 36.h),
                  child: Center(
                    child: Text(
                      'No threat alerts in this category.',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Color(0xFF1E293B),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final alert = filtered[index];
                    return _AlertTableRow(
                      alert: alert,
                      onInvestigate: () => _openInvestigation(alert),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF64748B),
        fontSize: 10.5.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildTabButton(String label, ThreatFilterTab tab) {
    final isSelected = _selectedTab == tab;

    return InkWell(
      onTap: () => setState(() => _selectedTab = tab),
      borderRadius: BorderRadius.circular(6.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0F3E57).withValues(alpha: 0.4)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0284C7).withValues(alpha: 0.8)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF38BDF8)
                : const Color(0xFF64748B),
            fontSize: 11.5.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}

class _AlertTableRow extends StatefulWidget {
  final ThreatAlertModel alert;
  final VoidCallback onInvestigate;

  const _AlertTableRow({
    required this.alert,
    required this.onInvestigate,
  });

  @override
  State<_AlertTableRow> createState() => _AlertTableRowState();
}

class _AlertTableRowState extends State<_AlertTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final alert = widget.alert;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered
            ? const Color(0xFF1E293B).withValues(alpha: 0.45)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        child: Row(
          children: [
            // Alert ID
            SizedBox(
              width: 100.w,
              child: GestureDetector(
                onTap: widget.onInvestigate,
                child: Text(
                  alert.alertId,
                  style: TextStyle(
                    color: const Color(0xFF00B4D8),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Title
            Expanded(
              flex: 4,
              child: Text(
                alert.title,
                style: TextStyle(
                  color: const Color(0xFFF1F5F9),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Severity Badge
            SizedBox(
              width: 100.w,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 2.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: alert.severityColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: alert.severityColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    alert.severityLabel,
                    style: TextStyle(
                      color: alert.severityColor,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ),

            // Source Layer
            SizedBox(
              width: 90.w,
              child: Text(
                alert.sourceLabel,
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 11.5.sp,
                ),
              ),
            ),

            // Time Ago
            SizedBox(
              width: 90.w,
              child: Text(
                alert.timeAgo,
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 11.sp,
                ),
              ),
            ),

            // Status Indicator with dot
            SizedBox(
              width: 110.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: alert.statusDotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    alert.statusLabel,
                    style: TextStyle(
                      color: alert.status == ThreatStatus.investigating
                          ? const Color(0xFFF59E0B)
                          : alert.status == ThreatStatus.closed
                              ? const Color(0xFF64748B)
                              : const Color(0xFFE2E8F0),
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Action Button: Investigate
            SizedBox(
              width: 100.w,
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: widget.onInvestigate,
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3E57).withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      'Investigate',
                      style: TextStyle(
                        color: const Color(0xFF38BDF8),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
