import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AppUnauthorizedState extends StatelessWidget {
  const AppUnauthorizedState({super.key, this.title, this.message, this.icon = Icons.lock_outline_rounded});

  final String? title;
  final String? message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final resolvedTitle = title?.trim().isNotEmpty == true ? title! : localizations.unauthorizedAccess;
    final resolvedMessage = message?.trim().isNotEmpty == true
        ? message!
        : "You don't have permission to view this section. "
              "Your account role doesn't include access to this feature.";

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 480.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LockBadge(isDark: isDark),
              Gap(20.h),
              Text(
                resolvedTitle,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(8.h),
              Text(
                resolvedMessage,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(24.h),
              _HelpCard(isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}

class _LockBadge extends StatelessWidget {
  const _LockBadge({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        color: isDark ? AppColors.errorBgDark : AppColors.errorBg,
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: isDark ? AppColors.errorBorderDark : AppColors.errorBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: isDark ? 0.25 : 0.12),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: DigifyAsset(
        assetPath: Assets.icons.lockIcon.path,
        color: isDark ? AppColors.errorBorderDark : AppColors.error,
        width: 36.w,
        height: 36.w,
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.15) : AppColors.infoBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 16.w, color: isDark ? AppColors.infoTextDark : AppColors.infoText),
              Gap(6.w),
              Text(
                'What can you do?',
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.infoTextDark : AppColors.infoText,
                ),
              ),
            ],
          ),
          Gap(10.h),
          ..._hints.map(
            (hint) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: _HintRow(text: hint, isDark: isDark),
            ),
          ),
        ],
      ),
    );
  }

  static const _hints = [
    'Contact your system administrator to request access.',
    'Ask your admin to review and update your role permissions.',
    'Verify you are signed in with the correct account.',
  ];
}

class _HintRow extends StatelessWidget {
  const _HintRow({required this.text, required this.isDark});

  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5.h, right: 8.w),
          child: Container(
            width: 5.w,
            height: 5.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoTextDark : AppColors.infoText,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.infoTextDark.withValues(alpha: 0.85) : AppColors.infoText,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
