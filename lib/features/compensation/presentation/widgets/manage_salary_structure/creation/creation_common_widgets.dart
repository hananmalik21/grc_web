import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../../../../core/widgets/common/digify_status_capsule.dart';
import '../../../../../../gen/assets.gen.dart';

class CreationSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const CreationSectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.w, color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
        Gap(8.w),
        Text(title, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      ],
    );
  }
}

class CreationSettingTile extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CreationSettingTile({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundGreyDark : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24.w,
                height: 24.w,
                child: Center(
                  child: DigifyCheckbox(
                    value: value,
                    onChanged: onChanged,
                    activeColor: AppColors.primary,
                    enabled: true,
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                    Gap(4.h),
                    Text(
                      description,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreationComponentCard extends StatelessWidget {
  final String name;
  final String code;
  final String type;
  final String category;
  final String status;
  final String description;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const CreationComponentCard({
    super.key,
    required this.name,
    required this.code,
    required this.type,
    required this.category,
    required this.status,
    required this.description,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isSelected ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => onChanged(!isSelected),
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 16.w,
                height: 18.w,
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: DigifyCheckbox(
                    value: isSelected,
                    onChanged: onChanged,
                    activeColor: AppColors.primary,
                    checkColor: Colors.white,
                    enabled: true,
                    size: 16.w,
                    borderRadius: 4.r,
                    uncheckedBorderColor: isDark ? AppColors.borderGreyDark : const Color(0xFFB3B3B3),
                    uncheckedBorderWidth: 1,
                    checkedBorderWidth: 1,
                    checkIconSize: 12.sp,
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.titleMedium?.copyWith(
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Gap(8.w),
                              DigifyCapsule(
                                label: type,
                                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                                backgroundColor: isDark ? AppColors.infoBgDark : AppColors.infoBg,
                                textColor: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
                              ),
                            ],
                          ),
                        ),
                        Gap(12.w),
                        DigifyStatusCapsule(status: status),
                      ],
                    ),
                    Gap(4.h),
                    Row(
                      children: [
                        Text(
                          code,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: AppColors.sidebarSecondaryText,
                            fontSize: 12.sp,
                          ),
                        ),
                        Gap(12.w),
                        Text(
                          '•',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: AppColors.sidebarSecondaryText,
                            fontSize: 12.sp,
                          ),
                        ),
                        Gap(12.w),
                        Text(
                          category,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: AppColors.sidebarSecondaryText,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    Gap(8.h),
                    Text(
                      description,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreationFieldLabel extends StatelessWidget {
  final String label;
  final String svgPath;
  final bool isRequired;

  const CreationFieldLabel({super.key, required this.label, required this.svgPath, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgGenImage(svgPath).svg(
          width: 16.w,
          height: 16.h,
          colorFilter: ColorFilter.mode(
            context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            BlendMode.srcIn,
          ),
        ),
        Gap(8.w),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class CreationFieldDescription extends StatelessWidget {
  final String text;

  const CreationFieldDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.bodySmall?.copyWith(
        color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        fontSize: 12.sp,
      ),
    );
  }
}
