import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/hiring/application/interviews/controllers/accept_interview_controller.dart';
import 'package:grc/features/hiring/application/interviews/controllers/reject_interview_controller.dart';
import 'package:grc/features/hiring/application/interviews/providers/interviews_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/schedule_interview/edit_interview_dialog.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/add_feedback_dialog.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interview_accept_actions.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interview_reject_actions.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interview_status_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class InterviewCard extends ConsumerWidget {
  const InterviewCard({
    required this.interview,
    this.onJoinMeeting,
    this.onAddFeedback,
    this.onEdit,
    this.onCancel,
    super.key,
  });

  final Interview interview;
  final VoidCallback? onJoinMeeting;
  final VoidCallback? onAddFeedback;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final interviewGuid = interview.interviewGuid?.trim() ?? '';
    final isRejecting = ref.watch(rejectInterviewLoadingProvider(interviewGuid));
    final isAccepting = ref.watch(acceptInterviewLoadingProvider(interviewGuid));
    final isResultActionLoading = isRejecting || isAccepting;
    final showPendingActions = interview.allowsEditAndReject;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: context.themeCardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: context.themeCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AppAvatar(fallbackInitial: interview.candidateName, size: 40.w),
                  Gap(12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        interview.candidateName,
                        style: context.textTheme.titleSmall?.copyWith(fontSize: 16.sp, color: context.themeTextPrimary),
                      ),
                      Text(
                        interview.position,
                        style: context.textTheme.bodyMedium?.copyWith(color: context.themeTextSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              InterviewStatusCapsule(interview: interview),
            ],
          ),
          Gap(16.h),
          _buildInfoRow(
            context,
            Assets.icons.employeesAssignedIcon.path,
            interview.dateTime != null
                ? '${DateFormat('yyyy-MM-dd').format(interview.dateTime!)} at ${DateFormat('hh:mm a').format(interview.dateTime!)}'
                : 'Not scheduled',
          ),
          Gap(12.h),
          _buildInfoRow(context, Assets.icons.hiring.videoMeet.path, interview.interviewType ?? 'N/A'),
          Gap(12.h),
          _buildInfoRow(context, Assets.icons.employeeListIcon.path, interview.interviewers.join(', ')),
          Gap(12.h),
          DigifySquareCapsule(
            label: interview.roundInfo,
            backgroundColor: Colors.transparent,
            textColor: context.themeTextPrimary,
            borderColor: context.themeTextPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 16.h)),
          Row(
            children: [
              AppButton.primary(
                label: loc.joinMeeting,
                onPressed: onJoinMeeting,
                svgPath: Assets.icons.hiring.videoMeet.path,
              ),
              Gap(8.w),
              Expanded(
                flex: 2,
                child: AppButton.outline(
                  label: loc.addFeedback,
                  onPressed: onAddFeedback ?? () => AddFeedbackDialog.show(context, interview: interview),
                  svgPath: Assets.icons.hiring.message.path,
                ),
              ),
              if (showPendingActions) ...[
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.editIcon.path,
                  onPressed: isResultActionLoading
                      ? null
                      : onEdit ??
                            () => EditInterviewDialog.show(
                              context,
                              interview: interview,
                              enterpriseId: ref.read(interviewsTabEnterpriseIdProvider),
                            ),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.checkIconGreen.path,
                  onPressed: isResultActionLoading
                      ? null
                      : () => showAcceptInterviewConfirmationAndAccept(context, ref, interview),
                  isLoading: isAccepting,
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.onPrimary,
                ),
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.closeDialogIcon.path,
                  onPressed: isResultActionLoading
                      ? null
                      : onCancel ?? () => showRejectInterviewConfirmationAndReject(context, ref, interview),
                  isLoading: isRejecting,
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.cardBackground,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String assetPath, String text) {
    return Row(
      children: [
        DigifyAsset(assetPath: assetPath, width: 16.w, height: 16.w, color: context.themeTextSecondary),
        Gap(8.w),
        Text(text, style: context.bodySmall.copyWith(color: context.themeTextSecondary)),
      ],
    );
  }
}
