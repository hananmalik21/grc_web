import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/threat_detection/threat_alert_model.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
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
        ),
        const Gap(16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cyberCardBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.cyberCardBorder),
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
                          color: AppColors.cardBackgroundDark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                          border: const Border(
                            bottom: BorderSide(
                              color: AppColors.cyberCardBorder,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100.w,
                              child: _buildHeaderLabel('ALERT ID'),
                            ),
                            SizedBox(
                              width: 260.w,
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
                                color: AppColors.textPlaceholderDark,
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
                              const Divider(
                                color: AppColors.cyberCardBorder,
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
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textPlaceholderDark,
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.primaryLight
                : AppColors.textPlaceholderDark,
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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered
            ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.3)
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
                    color: AppColors.dashCyberSecurity,
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
                  color: AppColors.textPrimaryDark,
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
                  color: AppColors.textTertiaryDark,
                  fontSize: 11.5.sp,
                ),
              ),
            ),
            SizedBox(
              width: 90.w,
              child: Text(
                alert.timeAgo,
                style: TextStyle(
                  color: AppColors.textPlaceholderDark,
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
                          ? AppColors.textPlaceholderDark
                          : AppColors.textPrimaryDark,
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
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: AppColors.primaryLight.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      'Investigate',
                      style: TextStyle(
                        color: AppColors.cyberLow,
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
