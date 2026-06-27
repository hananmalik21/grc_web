import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddNoteCard extends StatelessWidget {
  const AddNoteCard({
    super.key,
    required this.isDark,
    required this.notesController,
    required this.isPrivate,
    required this.onPrivateChanged,
    required this.onAddNote,
  });

  final bool isDark;
  final TextEditingController notesController;
  final bool isPrivate;
  final ValueChanged<bool> onPrivateChanged;
  final VoidCallback onAddNote;

  @override
  Widget build(BuildContext context) {
    final cardBorderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final cardBgColor = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final inputBorderColor = isDark ? AppColors.borderGreyDark : const Color(0xFFD1D5DC);

    final isMobile = context.isMobileLayout;

    return Container(
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: cardBorderColor, width: 1.0.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Note', style: context.textTheme.headlineSmall?.copyWith(color: textColor)),
          Gap(16.h),
          DigifyTextArea(
            controller: notesController,
            maxLines: 4,
            minLines: 4,
            hintText: 'Add a note about this candidate...',
          ),
          Gap(16.h),
          if (isMobile)
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: isPrivate ? 'Internal Only' : 'Shared Visible',
                    onPressed: () => onPrivateChanged(!isPrivate),
                    type: AppButtonType.outline,
                    borderColor: inputBorderColor,
                    foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Gap(12.w),
                AppMobileButton.primary(svgPath: Assets.icons.addDivisionIcon.path, onPressed: onAddNote),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  label: isPrivate ? 'Internal - Recruiting Team Only' : 'Shared - Visible to Hiring Team',
                  onPressed: () => onPrivateChanged(!isPrivate),
                  type: AppButtonType.outline,
                  borderColor: inputBorderColor,
                  foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
                AppButton.primary(label: 'Add Note', svgPath: Assets.icons.addDivisionIcon.path, onPressed: onAddNote),
              ],
            ),
        ],
      ),
    );
  }
}
