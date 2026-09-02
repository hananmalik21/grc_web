import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/dashboard/cyber_dashboard_models.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';

class CyberRecentIncidentsList extends StatefulWidget {
  final List<IncidentItem>? incidents;

  const CyberRecentIncidentsList({super.key, this.incidents});

  @override
  State<CyberRecentIncidentsList> createState() => _CyberRecentIncidentsListState();
}

class _CyberRecentIncidentsListState extends State<CyberRecentIncidentsList> {
  final ValueNotifier<int?> _hoveredIndexNotifier = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _hoveredIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final incidents = widget.incidents ?? const <IncidentItem>[];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT INCIDENTS',
                style: TextStyle(
                  color: AppColors.textTertiaryDark,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(4.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Text(
                    'View all →',
                    style: TextStyle(
                      color: AppColors.dashCyberSecurity,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(6),
          Expanded(
            child: incidents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 36.r,
                          color: AppColors.cyberLiveGreen.withValues(alpha: 0.6),
                        ),
                        Gap(8.h),
                        Text(
                          'No Active Security Incidents',
                          style: TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(2.h),
                        Text(
                          'All cloud systems and identity perimeters normal',
                          style: TextStyle(
                            color: AppColors.textPlaceholderDark,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: incidents.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: AppColors.cyberCardBorder,
                      height: 8,
                    ),
                    itemBuilder: (context, index) {
                      return _buildIncidentRow(incidents[index], index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentRow(IncidentItem incident, int index) {
    return Tooltip(
      message: '${incident.incidentId}: ${incident.title}\nStatus: ${incident.status} | Severity: ${incident.severity}',
      waitDuration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: AppColors.cyberDarkBg.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      textStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
      ),
      child: MouseRegion(
        onEnter: (_) => _hoveredIndexNotifier.value = index,
        onExit: (_) {
          if (_hoveredIndexNotifier.value == index) {
            _hoveredIndexNotifier.value = null;
          }
        },
        cursor: SystemMouseCursors.click,
        child: ValueListenableBuilder<int?>(
          valueListenable: _hoveredIndexNotifier,
          builder: (context, hoveredIndex, _) {
            final isHovered = hoveredIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isHovered
                    ? AppColors.dashCyberSecurity.withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: isHovered
                      ? AppColors.dashCyberSecurity.withValues(alpha: 0.3)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: BoxDecoration(
                      color: incident.severityColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incident.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${incident.incidentId} • ${incident.timestamp}',
                          style: TextStyle(
                            color: AppColors.textPlaceholderDark,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(8.w),
                  DigifyStatusCapsule(
                    status: incident.status,
                    variant: DigifyStatusCapsuleVariant.rounded,
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
