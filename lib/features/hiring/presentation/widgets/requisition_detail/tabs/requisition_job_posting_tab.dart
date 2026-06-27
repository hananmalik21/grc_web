import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/core/widgets/feedback/empty_state_widget.dart';
import 'package:grc/features/hiring/application/requisition/controllers/job_posting_status_controller.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisition_job_postings_provider.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/models/job_posting_view_data.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/create_job_posting/create_job_posting_dialog.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/create_job_posting/edit_job_posting_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'job_posting/job_posting_applications_summary.dart';
import 'job_posting/job_posting_channel_item.dart';
import 'job_posting/job_posting_date_item.dart';
import 'job_posting/job_posting_info_section.dart';
import 'job_posting/job_posting_visibility_section.dart';

class RequisitionJobPostingTab extends ConsumerStatefulWidget {
  const RequisitionJobPostingTab({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  ConsumerState<RequisitionJobPostingTab> createState() => _RequisitionJobPostingTabState();
}

class _RequisitionJobPostingTabState extends ConsumerState<RequisitionJobPostingTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFreshData());
  }

  Future<void> _loadFreshData() async {
    if (!mounted) return;
    await ref.read(requisitionJobPostingsProvider(widget.row.id).notifier).refresh();
  }

  Future<void> _openCreateDialog() async {
    final enterpriseId = ref.read(requisitionsTabEnterpriseIdProvider);
    await CreateJobPostingDialog.show(context, row: widget.row, enterpriseId: enterpriseId);
    if (!mounted) return;
    await _loadFreshData();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isMobile = context.isMobileLayout;
    final state = ref.watch(requisitionJobPostingsProvider(widget.row.id));
    final showCreateButton = state.items.isEmpty && !state.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showCreateButton) ...[
          if (isMobile)
            AppButton.primary(label: loc.hiringRequisitionJobPostingActionCreate, onPressed: _openCreateDialog)
          else
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppButton.primary(
                label: loc.hiringRequisitionJobPostingActionCreate,
                onPressed: _openCreateDialog,
              ),
            ),
          Gap(isMobile ? 16.h : 24.h),
        ],
        if (state.showInitialLoading)
          _buildLoadingCard(context)
        else if (state.error != null)
          _buildErrorCard(context, state.error!)
        else if (state.isEmpty)
          _buildEmptyCard(context, loc)
        else
          ...state.items.map(
            (posting) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _JobPostingCard(
                posting: posting,
                requisitionGuid: widget.row.id,
                requisitionCode: widget.row.requisitionCode,
                isDark: widget.isDark,
                loc: loc,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      decoration: _cardDecoration(widget.isDark),
      child: Center(
        child: AppLoadingIndicator(
          type: LoadingType.fadingCircle,
          color: widget.isDark ? AppColors.textSecondaryDark : AppColors.primary,
          size: 40.r,
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: _cardDecoration(widget.isDark),
      child: DigifyErrorState(message: message, onRetry: _loadFreshData, retryLabel: loc.retry),
    );
  }

  Widget _buildEmptyCard(BuildContext context, AppLocalizations loc) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: _cardDecoration(widget.isDark),
      child: EmptyStateWidget(
        iconPath: Assets.icons.workforce.totalPosition.path,
        title: loc.hiringRequisitionJobPostingEmptyTitle,
        message: loc.hiringRequisitionJobPostingEmptyMessage,
      ),
    );
  }

  BoxDecoration _cardDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
    );
  }
}

class _JobPostingCard extends ConsumerWidget {
  const _JobPostingCard({
    required this.posting,
    required this.requisitionGuid,
    required this.requisitionCode,
    required this.isDark,
    required this.loc,
  });

  final JobPostingViewData posting;
  final String requisitionGuid;
  final String requisitionCode;
  final bool isDark;
  final AppLocalizations loc;

  Future<void> _openEditDialog(BuildContext context, WidgetRef ref) async {
    final enterpriseId = ref.read(requisitionsTabEnterpriseIdProvider);
    await EditJobPostingDialog.show(
      context,
      posting: posting,
      requisitionGuid: requisitionGuid,
      requisitionCode: requisitionCode,
      enterpriseId: enterpriseId,
    );
    if (context.mounted) {
      await ref.read(requisitionJobPostingsProvider(requisitionGuid).notifier).refresh();
    }
  }

  Future<void> _confirmAndToggleStatus(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(jobPostingStatusControllerProvider);

    if (posting.isPaused) {
      final confirmed = await AppConfirmationDialog.show(
        context,
        title: loc.hiringRequisitionJobPostingActivateConfirmTitle,
        message: loc.hiringRequisitionJobPostingActivateConfirmMessage,
        itemName: posting.title,
        confirmLabel: loc.hiringRequisitionJobPostingActionActivate,
        cancelLabel: loc.cancel,
        type: ConfirmationType.success,
        svgPath: Assets.icons.activateIcon.path,
      );

      if (confirmed == true && context.mounted) {
        await controller.activate(context, postingGuid: posting.postingGuid, requisitionGuid: requisitionGuid);
      }
      return;
    }

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: loc.hiringRequisitionJobPostingPauseConfirmTitle,
      message: loc.hiringRequisitionJobPostingPauseConfirmMessage,
      itemName: posting.title,
      confirmLabel: loc.hiringRequisitionJobPostingActionPause,
      cancelLabel: loc.cancel,
      type: ConfirmationType.warning,
      svgPath: Assets.icons.hiring.hold.path,
    );

    if (confirmed == true && context.mounted) {
      await controller.pause(context, postingGuid: posting.postingGuid, requisitionGuid: requisitionGuid);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = context.isMobileLayout;
    final isStatusActionLoading = ref.watch(jobPostingStatusActionLoadingProvider(posting.postingGuid));

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.hiringRequisitionDetailTabJobPosting,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              DigifyStatusCapsule(status: posting.statusLabel),
            ],
          ),
          Gap(24.h),
          JobPostingInfoSection(
            label: loc.hiringRequisitionJobPostingTitleLabel,
            value: posting.title,
            isDark: isDark,
            isTitle: true,
          ),
          Gap(16.h),
          JobPostingInfoSection(
            label: loc.hiringRequisitionJobPostingDescriptionLabel,
            value: posting.description,
            isDark: isDark,
          ),
          Gap(16.h),
          _buildDatesRow(context),
          Gap(16.h),
          JobPostingVisibilitySection(
            label: loc.hiringRequisitionJobPostingVisibilityLabel,
            visibility: posting.visibility,
            isDark: isDark,
          ),
          if (posting.channels.isNotEmpty) ...[Gap(24.h), _buildChannelsSection(context)],
          Gap(24.h),
          JobPostingApplicationsSummary(count: posting.applicationsCount.toString(), isDark: isDark),
          Gap(24.h),
          _buildActionButtons(context, ref, isStatusActionLoading),
        ],
      ),
    );
  }

  Widget _buildDatesRow(BuildContext context) {
    final isMobile = context.isMobileLayout;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JobPostingDateItem(
            label: loc.hiringRequisitionJobPostingStartDateLabel,
            date: posting.startDate,
            isDark: isDark,
          ),
          Gap(16.h),
          JobPostingDateItem(label: loc.hiringRequisitionJobPostingEndDateLabel, date: posting.endDate, isDark: isDark),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: JobPostingDateItem(
            label: loc.hiringRequisitionJobPostingStartDateLabel,
            date: posting.startDate,
            isDark: isDark,
          ),
        ),
        Gap(16.w),
        Expanded(
          child: JobPostingDateItem(
            label: loc.hiringRequisitionJobPostingEndDateLabel,
            date: posting.endDate,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildChannelsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.hiringRequisitionJobPostingPostedChannelsLabel,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Gap(8.h),
        ...posting.channels.map(
          (channel) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: JobPostingChannelItem(name: _channelLabel(channel.type), date: channel.postedDate, isDark: isDark),
          ),
        ),
      ],
    );
  }

  String _channelLabel(JobPostingChannelType type) {
    return switch (type) {
      JobPostingChannelType.internal => loc.hiringRequisitionJobPostingChannelInternal,
      JobPostingChannelType.external => loc.hiringRequisitionJobPostingChannelExternal,
      JobPostingChannelType.linkedIn => loc.hiringRequisitionJobPostingChannelLinkedIn,
    };
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, bool isStatusActionLoading) {
    final statusButton = posting.isPaused
        ? AppButton.primary(
            label: loc.hiringRequisitionJobPostingActionActivate,
            isLoading: isStatusActionLoading,
            onPressed: isStatusActionLoading ? null : () => _confirmAndToggleStatus(context, ref),
          )
        : AppButton.dangerOutline(
            label: loc.hiringRequisitionJobPostingActionPause,
            isLoading: isStatusActionLoading,
            onPressed: isStatusActionLoading ? null : () => _confirmAndToggleStatus(context, ref),
          );

    return Row(
      children: [
        Expanded(
          child: AppButton.outline(
            label: loc.hiringRequisitionJobPostingActionEdit,
            onPressed: isStatusActionLoading ? null : () => _openEditDialog(context, ref),
          ),
        ),
        Gap(8.w),
        Expanded(child: statusButton),
      ],
    );
  }
}
