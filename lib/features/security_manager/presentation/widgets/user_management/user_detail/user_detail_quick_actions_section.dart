import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../gen/assets.gen.dart';
import 'user_detail_models.dart';
import 'user_detail_shared_widgets.dart';

class UserDetailQuickActionsSection extends StatelessWidget {
  const UserDetailQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      QuickActionItem(iconPath: Assets.icons.resetIcon.path, label: 'Reset Password', onTap: _emptyAction),
      QuickActionItem(iconPath: Assets.icons.lockIcon.path, label: 'Unlock Account', onTap: _emptyAction),
      QuickActionItem(iconPath: Assets.icons.securityIcon.path, label: 'Enable MFA', onTap: _emptyAction),
      QuickActionItem(
        iconPath: Assets.icons.securityManager.terminate.path,
        label: 'Revoke Sessions',
        onTap: _emptyAction,
      ),
    ];

    return UserDetailSectionCard(
      title: 'Quick Actions',
      iconPath: Assets.icons.resetIcon.path,
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: actions.map((action) => _UserDetailQuickActionTile(action: action)).toList(),
      ),
    );
  }
}

class _UserDetailQuickActionTile extends StatelessWidget {
  final QuickActionItem action;

  const _UserDetailQuickActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderRadius = BorderRadius.circular(10.r);
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: borderRadius,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: (context.isMobile ? constraints.maxWidth / 2 : constraints.maxWidth / 4) - 12.w,
              child: Ink(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                  borderRadius: borderRadius,
                  border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: DigifyAsset(
                        assetPath: action.iconPath,
                        color: AppColors.primary,
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                    Gap(12.h),
                    Text(
                      action.label,
                      style: context.labelLarge.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _emptyAction() {}
