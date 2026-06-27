import 'package:grc/core/services/responsive/responsive_helper.dart'
    as responsive_helper;
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../core/widgets/common/digify_status_capsule.dart';
import '../../../../../../features/security_manager/domain/models/user_detail_data.dart';
import '../../../../../../gen/assets.gen.dart';

class UserDetailStatusCardsSection extends StatelessWidget {
  final UserDetailData detail;

  const UserDetailStatusCardsSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final cards = _buildCards(context);
    return _buildResponsiveLayout(context, cards);
  }

  List<_UserDetailStatusCardData> _buildCards(BuildContext context) => [
        _UserDetailStatusCardData(
          svgPath: Assets.icons.employeeManagement.user.path,
          label: 'Account Status',
          value: detail.displayAccountStatus,
          badge: DigifyStatusCapsule(
            status: detail.isAccountActive ? 'Active' : 'Inactive',
          ),
        ),
        _UserDetailStatusCardData(
          svgPath: Assets.icons.securityIcon.path,
          label: 'MFA Status',
          value: detail.displayMfaStatus,
          badge: DigifySquareCapsule(
            label: detail.displayMfaStatus,
            backgroundColor: detail.mfaRequired
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.warning.withValues(alpha: 0.1),
            textColor:
                detail.mfaRequired ? AppColors.success : AppColors.warning,
            borderColor:
                detail.mfaRequired ? AppColors.success : AppColors.warning,
          ),
        ),
        _UserDetailStatusCardData(
          svgPath: Assets.icons.clockIcon.path,
          label: 'Last Login',
          value: '--',
        ),
        _UserDetailStatusCardData(
          svgPath: Assets.icons.securityManager.warning.path,
          label: 'Failed Attempts',
          value: detail.displayFailedAttempts,
          badge: detail.failedLoginAttempts > 0
              ? DigifySquareCapsule(
                  label: 'Warning',
                  backgroundColor: AppColors.warning.withValues(alpha: 0.1),
                  textColor: AppColors.warning,
                  borderColor: AppColors.warning,
                )
              : null,
        ),
      ];

  Widget _buildResponsiveLayout(
    BuildContext context,
    List<_UserDetailStatusCardData> cards,
  ) {
    final device =
        responsive_helper.ResponsiveHelper.getDeviceType(context);
    final gap = switch (device) {
      responsive_helper.DeviceType.mobile => 12.0,
      responsive_helper.DeviceType.tablet => 16.0,
      responsive_helper.DeviceType.web => 20.0,
    };

    if (device == responsive_helper.DeviceType.mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) Gap(gap),
            _UserDetailStatusCard(card: cards[i]),
          ],
        ],
      );
    }

    if (device == responsive_helper.DeviceType.tablet) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = (constraints.maxWidth - gap) / 2;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: cards
                .map(
                  (card) => SizedBox(
                    width: cardWidth,
                    child: _UserDetailStatusCard(card: card),
                  ),
                )
                .toList(),
          );
        },
      );
    }

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) Gap(gap),
          Expanded(child: _UserDetailStatusCard(card: cards[i])),
        ],
      ],
    );
  }
}

class _UserDetailStatusCard extends StatelessWidget {
  final _UserDetailStatusCardData card;

  const _UserDetailStatusCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final device =
        responsive_helper.ResponsiveHelper.getDeviceType(context);
    final cardPadding = switch (device) {
      responsive_helper.DeviceType.mobile => 16.0,
      responsive_helper.DeviceType.tablet => 18.0,
      responsive_helper.DeviceType.web => 20.0,
    };
    final iconSize = switch (device) {
      responsive_helper.DeviceType.mobile => 22.0,
      responsive_helper.DeviceType.tablet => 23.0,
      responsive_helper.DeviceType.web => 24.0,
    };
    final iconBoxSize = switch (device) {
      responsive_helper.DeviceType.mobile => 38.0,
      responsive_helper.DeviceType.tablet => 40.0,
      responsive_helper.DeviceType.web => 42.0,
    };
    final valueFontSize = switch (device) {
      responsive_helper.DeviceType.mobile => 20.0,
      responsive_helper.DeviceType.tablet => 22.0,
      responsive_helper.DeviceType.web => 24.0,
    };
    final iconBgColor =
        isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : AppColors.infoBg;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  card.label,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(7.h),
                Text(
                  card.value,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontSize: valueFontSize.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                Gap(8.h),
                if (card.badge != null) card.badge! else Gap(28.h),
              ],
            ),
          ),
          Gap(12.w),
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(7.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(
              assetPath: card.svgPath,
              color: AppColors.primary,
              width: iconSize,
              height: iconSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserDetailStatusCardData {
  final String label;
  final String value;
  final String svgPath;
  final Widget? badge;

  const _UserDetailStatusCardData({
    required this.label,
    required this.value,
    required this.svgPath,
    this.badge,
  });
}
