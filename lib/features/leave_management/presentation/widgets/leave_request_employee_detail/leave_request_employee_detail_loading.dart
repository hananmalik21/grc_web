import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveRequestEmployeeDetailLoading extends StatelessWidget {
  const LeaveRequestEmployeeDetailLoading({super.key, required this.isDark, required this.localizations});

  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLoadingIndicator(
            type: LoadingType.fadingCircle,
            color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
            size: 48.r,
          ),
          Gap(16.h),
          Text(
            localizations.pleaseWait,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
