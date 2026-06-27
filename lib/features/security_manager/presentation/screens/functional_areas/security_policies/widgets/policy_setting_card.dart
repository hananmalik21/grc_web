import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PolicySettingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final Widget input;

  const PolicySettingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onEnabledChanged,
    required this.input,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.headlineMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle),
                ),
              ),
              DigifySwitch(
                value: enabled,
                adaptive: true,
                activeTrackColor: AppColors.primary,
                activeThumbColor: AppColors.cardBackground,
                onChanged: onEnabledChanged,
              ),
            ],
          ),
          Gap(8.h),
          Text(
            subtitle,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
          Gap(10.h),
          Opacity(
            opacity: enabled ? 1.0 : 0.5,
            child: IgnorePointer(ignoring: !enabled, child: input),
          ),
        ],
      ),
    );
  }
}
