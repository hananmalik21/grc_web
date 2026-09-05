import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/incidents/incident_item_model.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/dialogs/incident_ai_triage_dialog.dart';

enum IncidentFilterTab { all, open, investigating, contained, resolved, closed }

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
          onExecuteContainment: () {},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredIncidents;
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isDark ? AppColors.cyberCardBorder : const Color(0xFFE2E8F0),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minWidth = constraints.maxWidth > 950
                  ? constraints.maxWidth
                  : 950.0;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: minWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: isDark ? AppColors.cyberCardBorder : const Color(0xFFE2E8F0),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90.w,
                              child: _buildHeaderLabel('ID'),
                            ),
                            SizedBox(
                              width: 250.w,
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
                              width: 140.w,
                              child: const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                      if (filtered.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 36.h,
                            horizontal: 20.w,
                          ),
                          child: Center(
                            child: Text(
                              'No incidents found under this filter.',
                              style: TextStyle(
                                color: AppColors.textPlaceholderDark,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        )
                      else
                        ...filtered.map((incident) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _IncidentTableRow(
                                incident: incident,
                                onTriage: () => _openTriage(incident),
                                onTake: () =>
                                    widget.onTakeOwnership?.call(incident),
                                isDark: isDark,
                              ),
                              Divider(
                                color: isDark ? AppColors.cyberCardBorder : const Color(0xFFE2E8F0),
                                height: 1,
                              ),
                            ],
                          );
                        }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderLabel(String text) {
    final isDark = context.isDark;
    return Text(
      text,
      style: TextStyle(
        color: isDark ? AppColors.textPlaceholderDark : const Color(0xFF64748B),
        fontSize: 10.5.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildTabButton(String label, IncidentFilterTab tab) {
    final isSelected = _selectedTab == tab;

    final isDark = context.isDark;

    return InkWell(
      onTap: () => setState(() => _selectedTab = tab),
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.dashCyberSecurity.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSelected ? AppColors.dashCyberSecurity.withValues(alpha: 0.6) : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.dashCyberSecurity
                : (isDark ? AppColors.textPlaceholderDark : const Color(0xFF64748B)),
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
  final bool isDark;

  const _IncidentTableRow({
    required this.incident,
    required this.onTriage,
    required this.onTake,
    required this.isDark,
  });

  @override
  State<_IncidentTableRow> createState() => _IncidentTableRowState();
}

class _IncidentTableRowState extends State<_IncidentTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final incident = widget.incident;
    final showTakeButton =
        incident.owner == 'Unassigned' ||
        incident.status == IncidentStatus.open ||
        incident.status == IncidentStatus.investigating;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered
            ? (widget.isDark
                ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.3)
                : const Color(0xFFF1F5F9))
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        child: Row(
          children: [
            SizedBox(
              width: 90.w,
              child: GestureDetector(
                onTap: widget.onTriage,
                child: Text(
                  incident.id,
                  style: TextStyle(
                    color: AppColors.dashCyberSecurity,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 250.w,
              child: Text(
                incident.title,
                style: TextStyle(
                  color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
            SizedBox(
              width: 110.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.r,
                    height: 6.r,
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
                          ? AppColors.cyberCritical
                          : incident.status == IncidentStatus.investigating
                          ? AppColors.alertMedium
                          : incident.status == IncidentStatus.contained
                          ? AppColors.cyberHigh
                          : incident.status == IncidentStatus.resolved
                          ? AppColors.cyberLiveGreen
                          : AppColors.textPlaceholderDark,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 95.w,
              child: Text(
                incident.owner,
                style: TextStyle(
                  color: incident.owner == 'Unassigned'
                      ? (widget.isDark ? AppColors.textPlaceholderDark : const Color(0xFF94A3B8))
                      : (widget.isDark ? AppColors.textSecondaryDark : AppColors.textPrimary),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 100.w,
              child: Text(
                incident.createdDate,
                style: TextStyle(
                  color: widget.isDark ? AppColors.textPlaceholderDark : const Color(0xFF64748B),
                  fontSize: 11.sp,
                ),
              ),
            ),
            SizedBox(
              width: 70.w,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: AppColors.purple.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    incident.mitreCode,
                    style: TextStyle(
                      color: AppColors.barPurple,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 140.w,
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
                        color: AppColors.dashCyberSecurity.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: AppColors.dashCyberSecurity.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        'AI Triage',
                        style: TextStyle(
                          color: AppColors.dashCyberSecurity,
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
                          color: widget.isDark
                              ? AppColors.cardBackgroundGreyDark
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: widget.isDark
                                ? AppColors.cyberCardBorder
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Text(
                          'Take',
                          style: TextStyle(
                            color: widget.isDark
                                ? AppColors.textTertiaryDark
                                : const Color(0xFF475569),
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
