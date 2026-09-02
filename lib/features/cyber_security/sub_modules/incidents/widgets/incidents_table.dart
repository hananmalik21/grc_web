import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/dialogs/incident_ai_triage_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/models/incident_item_model.dart';

enum IncidentFilterTab {
  all,
  open,
  investigating,
  contained,
  resolved,
  closed,
}

class IncidentsTable extends StatefulWidget {
  final List<IncidentItemModel> incidents;
  final ValueChanged<IncidentItemModel>? onTakeOwnership;
  final ValueChanged<IncidentItemModel>? onTriage;

  const IncidentsTable({
    super.key,
    required this.incidents,
    this.onTakeOwnership,
    this.onTriage,
  });

  @override
  State<IncidentsTable> createState() => _IncidentsTableState();
}

class _IncidentsTableState extends State<IncidentsTable> {
  IncidentFilterTab _selectedTab = IncidentFilterTab.all;

  List<IncidentItemModel> get _filteredIncidents {
    switch (_selectedTab) {
      case IncidentFilterTab.all:
        return widget.incidents;
      case IncidentFilterTab.open:
        return widget.incidents
            .where((i) => i.status == IncidentStatus.open)
            .toList();
      case IncidentFilterTab.investigating:
        return widget.incidents
            .where((i) => i.status == IncidentStatus.investigating)
            .toList();
      case IncidentFilterTab.contained:
        return widget.incidents
            .where((i) => i.status == IncidentStatus.contained)
            .toList();
      case IncidentFilterTab.resolved:
        return widget.incidents
            .where((i) => i.status == IncidentStatus.resolved)
            .toList();
      case IncidentFilterTab.closed:
        return widget.incidents
            .where((i) => i.status == IncidentStatus.closed)
            .toList();
    }
  }

  void _openTriage(IncidentItemModel incident) {
    if (widget.onTriage != null) {
      widget.onTriage!(incident);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => IncidentAiTriageDialog(
          incident: incident,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredIncidents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTabButton('ALL', IncidentFilterTab.all),
              const Gap(8),
              _buildTabButton('OPEN', IncidentFilterTab.open),
              const Gap(8),
              _buildTabButton('INVESTIGATING', IncidentFilterTab.investigating),
              const Gap(8),
              _buildTabButton('CONTAINED', IncidentFilterTab.contained),
              const Gap(8),
              _buildTabButton('RESOLVED', IncidentFilterTab.resolved),
              const Gap(8),
              _buildTabButton('CLOSED', IncidentFilterTab.closed),
            ],
          ),
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
                      width: 90.w,
                      child: _buildHeaderLabel('ID'),
                    ),
                    Expanded(
                      flex: 4,
                      child: _buildHeaderLabel('TITLE'),
                    ),
                    SizedBox(
                      width: 95.w,
                      child: _buildHeaderLabel('SEVERITY'),
                    ),
                    SizedBox(
                      width: 110.w,
                      child: _buildHeaderLabel('STATUS'),
                    ),
                    SizedBox(
                      width: 95.w,
                      child: _buildHeaderLabel('OWNER'),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: _buildHeaderLabel('CREATED'),
                    ),
                    SizedBox(
                      width: 70.w,
                      child: _buildHeaderLabel('MITRE'),
                    ),
                    SizedBox(
                      width: 135.w,
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
                      'No incidents found under this filter.',
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
                    final incident = filtered[index];
                    return _IncidentTableRow(
                      incident: incident,
                      onTriage: () => _openTriage(incident),
                      onTake: () => widget.onTakeOwnership?.call(incident),
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

  Widget _buildTabButton(String label, IncidentFilterTab tab) {
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

class _IncidentTableRow extends StatefulWidget {
  final IncidentItemModel incident;
  final VoidCallback onTriage;
  final VoidCallback onTake;

  const _IncidentTableRow({
    required this.incident,
    required this.onTriage,
    required this.onTake,
  });

  @override
  State<_IncidentTableRow> createState() => _IncidentTableRowState();
}

class _IncidentTableRowState extends State<_IncidentTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final incident = widget.incident;
    final showTakeButton = incident.owner == 'Unassigned' ||
        incident.status == IncidentStatus.open ||
        incident.status == IncidentStatus.investigating;

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
            // ID
            SizedBox(
              width: 90.w,
              child: GestureDetector(
                onTap: widget.onTriage,
                child: Text(
                  incident.id,
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
                incident.title,
                style: TextStyle(
                  color: const Color(0xFFF1F5F9),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Severity Tag
            SizedBox(
              width: 95.w,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 2.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: incident.severityColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: incident.severityColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    incident.severityLabel,
                    style: TextStyle(
                      color: incident.severityColor,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
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
                      color: incident.statusDotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    incident.statusLabel,
                    style: TextStyle(
                      color: incident.status == IncidentStatus.open
                          ? const Color(0xFFEF4444)
                          : incident.status == IncidentStatus.investigating
                              ? const Color(0xFFF59E0B)
                              : incident.status == IncidentStatus.contained
                                  ? const Color(0xFFF97316)
                                  : incident.status == IncidentStatus.resolved
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF64748B),
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Owner
            SizedBox(
              width: 95.w,
              child: Text(
                incident.owner,
                style: TextStyle(
                  color: incident.owner == 'Unassigned'
                      ? const Color(0xFF64748B)
                      : const Color(0xFFCBD5E1),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Created Date
            SizedBox(
              width: 100.w,
              child: Text(
                incident.createdDate,
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 11.sp,
                ),
              ),
            ),

            // MITRE Tag
            SizedBox(
              width: 70.w,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF581C87).withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: const Color(0xFFA855F7).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    incident.mitreCode,
                    style: TextStyle(
                      color: const Color(0xFFD8B4FE),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Action Buttons: AI Triage & Take
            SizedBox(
              width: 135.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: widget.onTriage,
                    borderRadius: BorderRadius.circular(6.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F3E57).withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        'AI Triage',
                        style: TextStyle(
                          color: const Color(0xFF38BDF8),
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (showTakeButton) ...[
                    const Gap(6),
                    InkWell(
                      onTap: widget.onTake,
                      borderRadius: BorderRadius.circular(6.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: const Color(0xFF334155),
                          ),
                        ),
                        child: Text(
                          'Take',
                          style: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
