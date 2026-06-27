import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/domain/models/interview_result_status.dart';
import 'package:grc/features/hiring/domain/models/interview_status_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InterviewStatusCapsuleStyle {
  const InterviewStatusCapsuleStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  static InterviewStatusCapsuleStyle fromStatusCode(String? statusCode, {required bool isDark}) {
    switch (statusCode?.toUpperCase()) {
      case InterviewResultStatus.rejected:
        return InterviewStatusCapsuleStyle(
          backgroundColor: isDark ? AppColors.errorBgDark : AppColors.errorBg,
          textColor: isDark ? AppColors.errorTextDark : AppColors.errorText,
          borderColor: isDark ? AppColors.errorBorderDark : AppColors.errorBorder,
        );
      case InterviewResultStatus.selected:
        return InterviewStatusCapsuleStyle(
          backgroundColor: isDark ? AppColors.successBgDark : AppColors.shiftActiveStatusBg,
          textColor: isDark ? AppColors.successTextDark : AppColors.shiftActiveStatusText,
          borderColor: isDark ? AppColors.successBorderDark : AppColors.activeStatusBorder,
        );
      case InterviewResultStatus.onHold:
        return InterviewStatusCapsuleStyle(
          backgroundColor: isDark ? AppColors.warningBgDark : AppColors.pendingStatusBackground,
          textColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
          borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
        );
      case InterviewResultStatus.pending:
        return InterviewStatusCapsuleStyle(
          backgroundColor: isDark ? AppColors.warningBgDark : AppColors.pendingStatusBackground,
          textColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
          borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
        );
      case InterviewStatusCode.completed:
        return InterviewStatusCapsuleStyle(
          backgroundColor: isDark ? AppColors.purpleBgDark : AppColors.infoBg,
          textColor: isDark ? AppColors.purpleTextDark : AppColors.primary,
          borderColor: isDark ? AppColors.purpleBorderDark : AppColors.infoBorder,
        );
      case InterviewStatusCode.cancelled:
        return InterviewStatusCapsuleStyle(
          backgroundColor: isDark ? AppColors.errorBgDark : AppColors.errorBg,
          textColor: isDark ? AppColors.errorTextDark : AppColors.errorText,
          borderColor: isDark ? AppColors.errorBorderDark : AppColors.errorBorder,
        );
      case InterviewStatusCode.rescheduled:
        return InterviewStatusCapsuleStyle(
          backgroundColor: isDark ? AppColors.warningBgDark : AppColors.pendingStatusBackground,
          textColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
          borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
        );
      case InterviewStatusCode.scheduled:
      default:
        return InterviewStatusCapsuleStyle(
          backgroundColor: isDark ? AppColors.successBgDark : AppColors.shiftActiveStatusBg,
          textColor: isDark ? AppColors.successTextDark : AppColors.shiftActiveStatusText,
          borderColor: isDark ? AppColors.successBorderDark : AppColors.activeStatusBorder,
        );
    }
  }

  static InterviewStatusCapsuleStyle fromInterview(BuildContext context, Interview interview) {
    return fromStatusCode(interview.resultStatus ?? interview.statusCode, isDark: context.isDark);
  }
}

class InterviewStatusCapsule extends StatelessWidget {
  const InterviewStatusCapsule({required this.interview, super.key});

  final Interview interview;

  @override
  Widget build(BuildContext context) {
    final style = InterviewStatusCapsuleStyle.fromInterview(context, interview);

    return DigifySquareCapsule(
      label: interview.statusLabel,
      backgroundColor: style.backgroundColor,
      textColor: style.textColor,
      borderColor: style.borderColor,
      borderRadius: BorderRadius.circular(4.r),
    );
  }
}
