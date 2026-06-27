import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'applications/application_card.dart';
import 'applications/requisition_applications_tab_config.dart';

class RequisitionApplicationsTab extends StatelessWidget {
  const RequisitionApplicationsTab({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isMobile = context.isMobileLayout;

    final applications = RequisitionApplicationsTabConfig.mockApplications;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16.w : 24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.hiringRequisitionDetailTabApplications,
            style: context.textTheme.headlineSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(24.h),
          ...applications.map((app) => ApplicationCard(data: app, isDark: isDark)),
          Gap(24.h),
          PaginationControls(
            currentPage: 1,
            totalPages: 1,
            totalItems: applications.length,
            pageSize: RequisitionApplicationsTabConfig.pageSize,
            hasNext: false,
            hasPrevious: false,
            showBorder: false,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
