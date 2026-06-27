import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'find_candidates/requisitions_candidate_card.dart';
import 'find_candidates/requisition_find_candidates_tab_config.dart';

class RequisitionFindCandidatesTab extends StatelessWidget {
  const RequisitionFindCandidatesTab({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isMobile = context.isMobileLayout;
    final candidates = RequisitionFindCandidatesTabConfig.mockCandidates;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context, loc, isMobile),
        Gap(24.h),
        ...candidates.map((candidate) => RequisitionCandidateCard(data: candidate, isDark: isDark)),
        Gap(24.h),
        PaginationControls(
          currentPage: 1,
          totalPages: 1,
          totalItems: candidates.length,
          pageSize: RequisitionFindCandidatesTabConfig.pageSize,
          hasNext: false,
          hasPrevious: false,
          showBorder: false,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations loc, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16.w : 24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Matching Candidates from Talent Pools',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontSize: 17.sp,
                  ),
                ),
                Gap(8.h),
                Text(
                  'Found 4 candidates that match your requisition criteria. These candidates are already in our talent pools and can be quickly added to your hiring pipeline.',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textDarkSlate,
                  ),
                ),
              ],
            ),
          ),
          Gap(16.w),
          DigifySquareCapsule(
            label: '4 Matches',
            borderRadius: BorderRadius.circular(10.r),
            backgroundColor: AppColors.primary,
            textColor: AppColors.cardBackground,
          ),
        ],
      ),
    );
  }
}
