import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/shift_selection_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShiftSelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;
  final int enterpriseId;
  final ShiftOverview? selectedShift;
  final ValueChanged<ShiftOverview?> onChanged;
  final bool enabled;

  const ShiftSelectionField({
    super.key,
    required this.label,
    this.isRequired = true,
    required this.enterpriseId,
    this.selectedShift,
    required this.onChanged,
    this.enabled = true,
  });

  String _getDisplayText(ShiftOverview? shift) {
    if (shift == null) return 'Select Shift';
    return '${shift.name} (${shift.startTime} - ${shift.endTime})';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final shiftsState = ref.watch(shiftsNotifierProvider(enterpriseId));
    final error = shiftsState.errorMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                    fontFamily: 'Inter',
                  ),
                ),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.deleteIconRed,
                      fontFamily: 'Inter',
                    ),
                  ),
              ],
            ),
          ),
          Gap(6.h),
        ],
        InkWell(
          onTap: enabled
              ? () async {
                  final selected = await ShiftSelectionDialog.show(
                    context: context,
                    enterpriseId: enterpriseId,
                    selectedShift: selectedShift,
                  );

                  if (selected != null) {
                    onChanged(selected);
                  }
                }
              : null,
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: enabled ? AppColors.cardBackground : AppColors.inputBg.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: error != null ? AppColors.error : AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getDisplayText(selectedShift),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: selectedShift != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (enabled)
                  DigifyAsset(
                    assetPath: Assets.icons.workforce.chevronRight.path,
                    color: AppColors.textSecondary,
                    height: 15,
                  )
                else
                  Icon(Icons.block, size: 20.sp, color: AppColors.textSecondary.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
