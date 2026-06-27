import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/hiring/application/candidates/controllers/delete_candidate_controller.dart';
import 'package:grc/features/hiring/application/candidates/providers/delete_candidate_providers.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_table_width_provider.dart';
import 'package:grc/features/hiring/presentation/screens/candidate_detail_page.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/candidates_permission_mixin.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_table_config.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_table_types.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CandidatesTableRow extends ConsumerStatefulWidget {
  const CandidatesTableRow({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  ConsumerState<CandidatesTableRow> createState() => _CandidatesTableRowState();
}

class _CandidatesTableRowState extends ConsumerState<CandidatesTableRow> with CandidatesPermissionMixin {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(candidatesTableWidthsProvider);
    final primaryText = widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryText = widget.isDark ? AppColors.textSecondaryDark : AppColors.textMuted;

    final dividerWidths = <double>[
      ...state.columnOrder.map(state.widthFor),
      if (CandidatesTableConfig.showActions) CandidatesTableConfig.actionsWidth.w,
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                for (var i = 0; i < dividerWidths.length; i++)
                  _buildDivider(dividerWidths[i], isLast: i == dividerWidths.length - 1),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...state.columnOrder.map((column) {
                final cell = _buildCellForColumn(
                  context,
                  column,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                );
                return _buildDataCell(cell, state.widthFor(column));
              }),
              if (CandidatesTableConfig.showActions) _buildActionsCell(loc),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCellForColumn(
    BuildContext context,
    CandidatesTableColumn column, {
    required Color primaryText,
    required Color secondaryText,
  }) {
    return switch (column) {
      CandidatesTableColumn.candidate => Row(
        children: [
          AppAvatar(fallbackInitial: widget.candidate.name, size: 40.w),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => context.pushNamed(CandidateDetailPage.routeName, extra: widget.candidate),
                  child: Text(widget.candidate.name, style: context.textTheme.titleSmall?.copyWith(color: primaryText)),
                ),
                Gap(4.h),
                Text(
                  widget.candidate.email,
                  style: context.textTheme.labelSmall?.copyWith(color: secondaryText, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
      CandidatesTableColumn.currentRole => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.candidate.jobTitle, style: context.textTheme.titleSmall?.copyWith(color: primaryText)),
          Gap(4.h),
          Text(
            widget.candidate.company,
            style: context.textTheme.labelSmall?.copyWith(color: secondaryText, fontSize: 12.sp),
          ),
        ],
      ),
      CandidatesTableColumn.experience => Text(
        widget.candidate.experience,
        style: context.textTheme.titleSmall?.copyWith(color: primaryText),
      ),
      CandidatesTableColumn.location => Text(
        widget.candidate.location,
        style: context.textTheme.titleSmall?.copyWith(color: primaryText),
      ),
      CandidatesTableColumn.rating => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 14.r, color: AppColors.warning),
          Gap(4.w),
          Text(widget.candidate.rating.toString(), style: context.textTheme.titleSmall?.copyWith(color: primaryText)),
        ],
      ),
      CandidatesTableColumn.status => Align(
        alignment: Alignment.centerLeft,
        child: DigifyStatusCapsule(status: widget.candidate.status),
      ),
    };
  }

  Widget _buildActionsCell(AppLocalizations loc) {
    final isDeleting = ref.watch(deleteCandidateLoadingProvider(widget.candidate.id));

    return SizedBox(
      width: CandidatesTableConfig.actionsWidth.w,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.w,
            children: [
              if (canViewCandidates)
                ActionButtonWidget(
                  type: ActionButtonType.view,
                  tooltip: loc.view,
                  onTap: () => context.pushNamed(CandidateDetailPage.routeName, extra: widget.candidate),
                  borderRadius: BorderRadius.circular(6.r),
                  customBorder: null,
                ),
              if (canUpdateCandidate)
                ActionButtonWidget(
                  type: ActionButtonType.delete,
                  tooltip: loc.delete,
                  isLoading: isDeleting,
                  onTap: _onDeletePressed,
                  borderRadius: BorderRadius.circular(6.r),
                  customBorder: null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onDeletePressed() async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: loc.delete,
      message: loc.hiringCandidatesDeleteConfirmMessage,
      itemName: widget.candidate.name,
      confirmLabel: loc.delete,
      cancelLabel: loc.close,
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );
    if (confirmed != true || !mounted) return;

    await ref.read(deleteCandidateControllerProvider).delete(context, candidateGuid: widget.candidate.id);
  }

  Widget _buildDivider(double width, {required bool isLast}) {
    if (isLast) {
      return SizedBox(width: width);
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
        child: child,
      ),
    );
  }
}
