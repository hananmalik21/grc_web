import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/dashboard/cyber_dashboard_models.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/cyber_security/data/mock/cyber_dashboard_mock_data.dart';

class CyberRecentIncidentsList extends StatelessWidget {
  const CyberRecentIncidentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const Gap(14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: CyberDashboardMockData.recentIncidents.length,
            separatorBuilder: (context, index) => const Divider(
              color: AppColors.cyberCardBorder,
              height: 14,
            ),
            itemBuilder: (context, index) {
              final incident = CyberDashboardMockData.recentIncidents[index];
              return _buildIncidentRow(incident);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentRow(IncidentItem incident) {
    return Row(
      children: [
        DigifyStatusCapsule(
          status: incident.severity,
          variant: DigifyStatusCapsuleVariant.boxy,
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                incident.title,
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(2),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6.w,
                children: [
                  Text(
                    incident.incidentId,
                    style: TextStyle(
                      color: AppColors.textPlaceholderDark,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '•',
                    style: TextStyle(
                      color: AppColors.textPlaceholderDark,
                      fontSize: 9.sp,
                    ),
                  ),
                  Text(
                    incident.timestamp,
                    style: TextStyle(
                      color: AppColors.textPlaceholderDark,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Gap(8),
        DigifyStatusCapsule(
          status: incident.status,
          variant: DigifyStatusCapsuleVariant.pill,
        ),
      ],
    );
  }
}
