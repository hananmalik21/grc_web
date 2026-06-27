import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/feedback/app_dialog.dart';
import '../../../../../core/widgets/forms/digify_select_field.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../providers/user_management/user_role_form_provider.dart';

class UserRoleFormDialog extends ConsumerStatefulWidget {
  const UserRoleFormDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const UserRoleFormDialog(),
    );
  }

  @override
  ConsumerState<UserRoleFormDialog> createState() => _UserRoleFormDialogState();
}

class _UserRoleFormDialogState extends ConsumerState<UserRoleFormDialog> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userRoleFormProvider);
    final notifier = ref.read(userRoleFormProvider.notifier);
    return AppDialog(
      width: context.deviceWidth * .55,
      title: 'Add Role',
      subtitle: 'Select a role to assign to this user',
      onClose: () {
        notifier.resetFilters();
        context.pop();
      },
      content: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DigifyTextField(
                  controller: _searchController,
                  hintText: 'Search roles...',
                  onChanged: (v) => notifier.searchRoles(v),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: DigifyAsset(
                      assetPath: Assets.icons.searchIcon.path,
                      width: 18,
                      height: 18,
                      color: AppColors.textPlaceholder,
                    ),
                  ),
                ),
              ),
              Gap(16.w),
              Expanded(
                flex: 1,
                child: DigifySelectField<String>(
                  hint: 'All Categories',
                  items: const [
                    'All Categories',
                    'Application',
                    'Job',
                    'Function',
                  ],
                  value: state.selectedRoleType,
                  itemLabelBuilder: (v) => v,
                  onChanged: (v) => notifier.filterRoles(v!),
                ),
              ),
            ],
          ),
          Gap(24.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.isMobile ? 1 : 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              mainAxisExtent: 110.h,
            ),
            itemCount: state.filteredRoles.length,
            itemBuilder: (context, index) {
              final role = state.filteredRoles[index];
              return _buildRoleCard(
                title: role.title,
                description: role.description,
                type: role.type,
                userCount: role.userCount,
                isSelected: state.assignedRoles?.contains(role.id) ?? false,
                onTap: () => notifier.assignRole(role.id),
              );
            },
          ),
        ],
      ),
      actions: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: (state.assignedRoles?.length ?? 0).toString(),
                style: context.labelLarge,
              ),
              TextSpan(text: ' role(s) currently assigned'),
            ],
            style: context.labelMedium,
          ),
        ),
        Spacer(),
        AppButton(
          label: 'Close',
          onPressed: () {
            notifier.resetFilters();
            context.pop();
          },
          backgroundColor: AppColors.shiftExportButton,
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required String type,
    required int userCount,

    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Durations.medium4,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : context.isDark
              ? AppColors.cardBackgroundDark
              : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : context.isDark
                ? AppColors.cardBorderDark
                : AppColors.dashboardCardBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: context.isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: context.isDark
                        ? AppColors.cardBackgroundGreyDark
                        : AppColors.tableHeaderBackground,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "$userCount users",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: context.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            Gap(4.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 12.sp,
                color: context.isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              type,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
