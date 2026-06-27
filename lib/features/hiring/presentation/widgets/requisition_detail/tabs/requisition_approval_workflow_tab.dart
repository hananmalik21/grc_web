import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'approval_workflow/approval_step_card.dart';
import 'approval_workflow/requisition_approval_workflow_tab_config.dart';

class RequisitionApprovalWorkflowTab extends StatelessWidget {
  const RequisitionApprovalWorkflowTab({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isMobile = context.isMobileLayout;

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
            loc.hiringRequisitionDetailTabApprovalWorkflow,
            style: context.textTheme.headlineSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(24.h),
          _buildProgressSection(context),
          Gap(24.h),
          _buildApprovalStepsList(context),
          Gap(24.h),
          PaginationControls(
            currentPage: 1,
            totalPages: 1,
            totalItems: 4,
            pageSize: RequisitionApprovalWorkflowTabConfig.pageSize,
            hasNext: false,
            hasPrevious: false,
            showBorder: false,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: LinearProgressIndicator(
                  value: row.approvalProgress,
                  minHeight: 8.h,
                  backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
            Gap(12.w),
            Text(
              '${row.approvalCompleted} of ${row.approvalTotal}',
              style: context.textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildApprovalStepsList(BuildContext context) {
    final steps = RequisitionApprovalWorkflowTabConfig.mockApprovalSteps;

    return Column(
      children: steps.map((step) => ApprovalStepCard(data: step, isDark: isDark)).toList(),
    );
  }
}
