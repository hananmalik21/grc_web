import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifySingleSelectMobileSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData headerIcon;
  final Widget searchField;
  final Widget content;
  final Widget? pagination;
  final bool canApply;
  final bool canClear;
  final VoidCallback? onApply;
  final VoidCallback? onClear;
  final VoidCallback onCancel;

  const DigifySingleSelectMobileSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.headerIcon,
    required this.searchField,
    required this.content,
    required this.canApply,
    required this.canClear,
    required this.onApply,
    required this.onClear,
    required this.onCancel,
    this.pagination,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.cardBackgroundDark
        : AppColors.cardBackground;

    return Material(
      color: bgColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MobileHeader(title: title, subtitle: subtitle, headerIcon: headerIcon, searchField: searchField),
          const DigifyDivider.horizontal(),
          Flexible(
            child: ConstrainedBox(constraints: const BoxConstraints(minHeight: 120), child: content),
          ),
          if (pagination != null) ...[const DigifyDivider.horizontal(), pagination!],
          const DigifyDivider.horizontal(),
          _MobileActions(
            canApply: canApply,
            canClear: canClear,
            onApply: onApply,
            onClear: onClear,
            onCancel: onCancel,
          ),
        ],
      ),
    );
  }
}

class DigifySingleSelectMobileListItem extends StatelessWidget {
  final String label;
  final String? description;
  final bool isSelected;
  final VoidCallback onTap;

  const DigifySingleSelectMobileListItem({
    super.key,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.06),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    if (description?.trim().isNotEmpty == true) ...[
                      Gap(2.h),
                      Text(
                        description!,
                        style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(Icons.check_rounded, size: 13.sp, color: AppColors.primary),
                )
              else
                SizedBox(width: 22.r),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData headerIcon;
  final Widget searchField;

  const _MobileHeader({
    required this.title,
    required this.subtitle,
    required this.headerIcon,
    required this.searchField,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(headerIcon, color: AppColors.primary, size: 18.sp),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 30.r,
                  height: 30.r,
                  decoration: BoxDecoration(color: AppColors.cardBackgroundGrey, shape: BoxShape.circle),
                  child: Icon(Icons.close_rounded, size: 15.sp, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          Gap(14.h),
          searchField,
        ],
      ),
    );
  }
}

class _MobileActions extends StatelessWidget {
  final bool canApply;
  final bool canClear;
  final VoidCallback? onApply;
  final VoidCallback? onClear;
  final VoidCallback onCancel;

  const _MobileActions({
    required this.canApply,
    required this.canClear,
    required this.onApply,
    required this.onClear,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Row(
        children: [
          AppMobileButton.outline(onPressed: canClear ? onClear : null, icon: Icons.refresh_rounded),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppMobileButton.outline(onPressed: onCancel, icon: Icons.close_rounded),
              Gap(12.w),
              AppMobileButton.primary(onPressed: canApply ? onApply : null, icon: Icons.check_rounded),
            ],
          ),
        ],
      ),
    );
  }
}
