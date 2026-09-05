import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/threat_detection/threat_alert_model.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/dialogs/threat_investigation_dialog.dart';

enum ThreatFilterTab { all, new_, investigating, closed }

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
            setState(() {});
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAlerts;
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTabButton('ALL', ThreatFilterTab.all, isDark),
              const Gap(8),
              _buildTabButton('NEW', ThreatFilterTab.new_, isDark),
              const Gap(8),
              _buildTabButton('INVESTIGATING', ThreatFilterTab.investigating, isDark),
              const Gap(8),
              _buildTabButton('CLOSED', ThreatFilterTab.closed, isDark),
            ],
          ),
        ),
        const Gap(16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minWidth = constraints.maxWidth > 850
                  ? constraints.maxWidth
                  : 850.0;

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
                          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28.r),
                            topRight: Radius.circular(28.r),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100.w,
                              child: _buildHeaderLabel('ALERT ID', isDark),
                            ),
                            SizedBox(
                              width: 260.w,
                              child: _buildHeaderLabel('TITLE', isDark),
                            ),
                            SizedBox(
                              width: 100.w,
                              child: _buildHeaderLabel('SEVERITY', isDark),
                            ),
                            SizedBox(
                              width: 90.w,
                              child: _buildHeaderLabel('SOURCE', isDark),
                            ),
                            SizedBox(
                              width: 90.w,
                              child: _buildHeaderLabel('TIME', isDark),
                            ),
                            SizedBox(
                              width: 110.w,
                              child: _buildHeaderLabel('STATUS', isDark),
                            ),
                            SizedBox(
                              width: 100.w,
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
                              'No threat alerts in this category.',
                              style: TextStyle(
                                color: isDark ? AppColors.textPlaceholderDark : const Color(0xFF64748B),
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        )
                      else
                        ...filtered.map((alert) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _AlertTableRow(
                                alert: alert,
                                onInvestigate: () => _openInvestigation(alert),
                              ),
                              Divider(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
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

  Widget _buildHeaderLabel(String text, bool isDark) {
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

  Widget _buildTabButton(String label, ThreatFilterTab tab, bool isDark) {
    final isSelected = _selectedTab == tab;

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

class _AlertTableRow extends StatefulWidget {
  final ThreatAlertModel alert;
  final VoidCallback onInvestigate;

  const _AlertTableRow({required this.alert, required this.onInvestigate});

  @override
  State<_AlertTableRow> createState() => _AlertTableRowState();
}

class _AlertTableRowState extends State<_AlertTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final alert = widget.alert;
    final isDark = context.isDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered
            ? (isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF8FAFC))
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        child: Row(
          children: [
            SizedBox(
              width: 100.w,
              child: GestureDetector(
                onTap: widget.onInvestigate,
                child: Text(
                  alert.alertId,
                  style: TextStyle(
                    color: isDark ? AppColors.dashCyberSecurity : const Color(0xFF00B4D8),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 260.w,
              child: Text(
                alert.title,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
            SizedBox(
              width: 90.w,
              child: Text(
                alert.sourceLabel,
                style: TextStyle(
                  color: isDark ? AppColors.textTertiaryDark : const Color(0xFF64748B),
                  fontSize: 11.5.sp,
                ),
              ),
            ),
            SizedBox(
              width: 90.w,
              child: Text(
                alert.timeAgo,
                style: TextStyle(
                  color: isDark ? AppColors.textPlaceholderDark : const Color(0xFF64748B),
                  fontSize: 11.sp,
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
                      color: alert.statusDotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    alert.statusLabel,
                    style: TextStyle(
                      color: alert.status == ThreatStatus.investigating
                          ? AppColors.alertMedium
                          : alert.status == ThreatStatus.closed
                          ? (isDark ? AppColors.textPlaceholderDark : const Color(0xFF64748B))
                          : (isDark ? Colors.white : const Color(0xFF0F172A)),
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
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
                      color: AppColors.dashCyberSecurity.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: AppColors.dashCyberSecurity.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      'Investigate',
                      style: TextStyle(
                        color: AppColors.dashCyberSecurity,
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
