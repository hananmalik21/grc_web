import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LabelWithCapsule extends StatelessWidget {
  final BuildContext context;
  final String label;
  final String? iconPath;
  final Widget capsule;
  final bool isDark;

  const LabelWithCapsule({
    super.key,
    required this.context,
    required this.label,
    this.iconPath,
    required this.capsule,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.textTheme.labelSmall?.copyWith(
      fontSize: 12.sp,
      color: isDark ? context.themeTextSecondary : AppColors.textSecondary,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(label, style: labelStyle),
            if (iconPath != null) ...[
              Gap(7.w),
              DigifyAsset(
                assetPath: iconPath!,
                width: 14,
                height: 14,
                color: isDark ? context.themeTextSecondary : AppColors.textSecondary,
              ),
            ],
          ],
        ),
        capsule,
      ],
    );
  }
}

class CarryForwardInfo extends StatelessWidget {
  final bool carryForwardAllowed;
  final String? carryForwardMax;
  final bool isDark;

  const CarryForwardInfo({super.key, required this.carryForwardAllowed, this.carryForwardMax, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return LabelWithCapsule(
      context: context,
      label: 'Carry Forward Allowed',
      iconPath: Assets.icons.infoCircleBlue.path,
      isDark: isDark,
      capsule: DigifyCapsule(
        label: carryForwardAllowed ? (carryForwardMax != null ? 'Yes (Max $carryForwardMax)' : 'Yes') : 'No',
        backgroundColor: carryForwardAllowed ? AppColors.jobRoleBg : AppColors.errorBg,
        textColor: carryForwardAllowed ? AppColors.statIconBlue : AppColors.errorText,
      ),
    );
  }
}

class ExpiryDateInfo extends StatelessWidget {
  final String? expiryDate;
  final bool isDark;

  const ExpiryDateInfo({super.key, this.expiryDate, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return LabelWithCapsule(
      context: context,
      label: 'Expiry Date',
      isDark: isDark,
      capsule: DigifyCapsule(
        label: expiryDate ?? 'N/A',
        backgroundColor: AppColors.jobRoleBg,
        textColor: AppColors.statIconBlue,
      ),
    );
  }
}
