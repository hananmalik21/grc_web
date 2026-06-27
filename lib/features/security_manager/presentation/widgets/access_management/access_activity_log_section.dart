import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../data/models/access_management/access_role.dart';
import '../../providers/access_management/access_management_provider.dart';
import 'access_section_card.dart';

class AccessActivityLogSection extends ConsumerWidget {
  const AccessActivityLogSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref
        .watch(accessManagementProvider)
        .roleDetail
        ?.activities;
    return AccessSectionCard(
      title: 'Activity Log',
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 300.h),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) =>
              ActivityTile(activity: activities![index]),
          separatorBuilder: (context, index) => Gap(24.h),
          itemCount: activities?.length ?? 0,
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  const ActivityTile({super.key, required this.activity});

  final AccessActivity activity;

  @override
  Widget build(BuildContext context) {
    final icon = activity.title?.contains('User') ?? false
        ? Icons.person_outline
        : Icons.history;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    activity.title ?? 'N/A',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    activity.timestamp == null
                        ? "--/--/--"
                        : DateFormat('dd MMM yyyy').format(activity.timestamp!),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Gap(4.h),
              Text(
                activity.description ?? 'N/A',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
              Gap(8.h),
              Text(
                'By ${activity.user ?? 'N/A'}',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
