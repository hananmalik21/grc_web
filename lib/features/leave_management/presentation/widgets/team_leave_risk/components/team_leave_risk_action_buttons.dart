import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamLeaveRiskActionButtons extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onApprove;

  const TeamLeaveRiskActionButtons({super.key, this.onView, this.onApprove});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8.w,
      children: [
        if (onView != null)
          DigifyAssetButton(assetPath: Assets.icons.blueEyeIcon.path, width: 14.w, height: 14.h, onTap: onView),
        if (onApprove != null)
          DigifyAssetButton(
            assetPath: Assets.icons.checkIconGreen.path,
            width: 14.w,
            height: 14.h,
            color: AppColors.shiftEditButtonText,
            onTap: onApprove,
          ),
      ],
    );
  }
}
