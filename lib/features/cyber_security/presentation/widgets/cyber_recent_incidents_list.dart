import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/dashboard/cyber_dashboard_models.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';

class CyberRecentIncidentsList extends StatefulWidget {
  final List<IncidentItem>? incidents;

  const CyberRecentIncidentsList({super.key, this.incidents});

  static const Color skyBlue = Color(0xFF00B4D8);

  @override
  State<CyberRecentIncidentsList> createState() =>
      _CyberRecentIncidentsListState();
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 12.r : 18.r),
      decoration: BoxDecoration(
        color: Colors.white, // Solid white card
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
                  color: const Color(0xFF0F172A),
                  fontSize: isMobile ? 13.sp : 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(4.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Text(
                    'View all →',
                    style: TextStyle(
                      color: CyberRecentIncidentsList.skyBlue,
                      fontSize: isMobile ? 11.sp : 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(isMobile ? 6.h : 8.h),
          Expanded(
            child: incidents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: isMobile ? 28.r : 36.r,
                          color: const Color(0xFF166534),
                        ),
                        Gap(6.h),
                        Text(
                          'No Active Security Incidents',
                          style: TextStyle(
                            color: const Color(0xFF0F172A),
                            fontSize: isMobile ? 12.sp : 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(2.h),
                        Text(
                          'All cloud systems and identity perimeters normal',
                          style: TextStyle(
                            color: const Color(0xFF64748B),
                            fontSize: isMobile ? 10.5.sp : 11.5.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: incidents.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Color(0xFFF1F5F9),
                      height: 8,
                    ),
                    itemBuilder: (context, index) {
                      return _buildIncidentRow(incidents[index], index, isMobile);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentRow(IncidentItem incident, int index, bool isMobile) {
    return Tooltip(
      message:
          '${incident.incidentId}: ${incident.title}\nStatus: ${incident.status} | Severity: ${incident.severity}',
      waitDuration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(6.r),
      ),
      textStyle: TextStyle(
        color: Colors.white,
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
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: isHovered
                    ? CyberRecentIncidentsList.skyBlue.withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: isHovered
                      ? CyberRecentIncidentsList.skyBlue.withValues(alpha: 0.3)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 7.r,
                    height: 7.r,
                    decoration: BoxDecoration(
                      color: incident.severityColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap(6.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incident.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF0F172A),
                            fontSize: isMobile ? 11.sp : 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${incident.incidentId} • ${incident.timestamp}',
                          style: TextStyle(
                            color: const Color(0xFF64748B),
                            fontSize: isMobile ? 9.5.sp : 10.5.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(6.w),
                  DigifyStatusCapsule(
                    status: incident.status,
                    variant: DigifyStatusCapsuleVariant.rounded,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 6.w : 8.w,
                      vertical: 2.h,
                    ),
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
