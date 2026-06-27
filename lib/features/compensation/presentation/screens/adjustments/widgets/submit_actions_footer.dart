import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SubmitActionsFooter extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onSaveDraft;
  final bool isLoading;

  const SubmitActionsFooter({super.key, required this.onSubmit, required this.onSaveDraft, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final infoText = Row(
      children: [
        Icon(Icons.info_outline, size: 16.w, color: AppColors.textTertiary),
        Gap(8.w),
        Expanded(
          child: Text(
            'All required fields must be completed before submission',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textTertiary),
          ),
        ),
      ],
    );

    final actions = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
        Gap(12.w),
        AppButton.primary(label: 'Submit for Approval', onPressed: onSubmit, isLoading: isLoading),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        border: Border(top: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder)),
      ),
      child: context.isMobileLayout
          ? Column(mainAxisSize: MainAxisSize.min, children: [infoText, Gap(16.h), actions])
          : Row(
              children: [
                Expanded(child: infoText),
                actions,
              ],
            ),
    );
  }
}
