import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/common/digify_square_capsule.dart';
import '../../../../../core/widgets/feedback/app_dialog.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../data/models/user_management/user_policy.dart';
import '../../providers/user_management/user_data_policy_form_provider.dart';

class UserDataPolicyFormDialog extends ConsumerStatefulWidget {
  const UserDataPolicyFormDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const UserDataPolicyFormDialog(),
    );
  }

  @override
  ConsumerState<UserDataPolicyFormDialog> createState() =>
      _UserDataPolicyFormDialogState();
}

class _UserDataPolicyFormDialogState
    extends ConsumerState<UserDataPolicyFormDialog> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userDataPolicyFormProvider);
    final notifier = ref.read(userDataPolicyFormProvider.notifier);
    return AppDialog(
      width: context.deviceWidth * .4,
      title: 'Add Data Access Policy',
      subtitle: 'Select a policy to grant data access to this user',
      onClose: () {
        notifier.resetFilters();
        context.pop();
      },
      content: Column(
        children: [
          DigifyTextField(
            controller: _searchController,
            hintText: 'Search policies...',
            onChanged: (v) => notifier.searchPolicies(v),
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
          Gap(24.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.filteredPolicies.length,
            separatorBuilder: (context, index) => Gap(16.h),
            itemBuilder: (context, index) {
              final policy = state.filteredPolicies[index];
              return _buildPolicyRow(
                policy,
                isSelected: state.selectedPolicy?.id == policy.id,
                onTap: () => notifier.assignPolicy(policy),
              );
            },
          ),
        ],
      ),
      actions: [
        // RichText(
        //   text: TextSpan(
        //     children: [
        //       TextSpan(
        //         text: (state.assignedRoles?.length ?? 0).toString(),
        //         style: context.labelLarge,
        //       ),
        //       TextSpan(text: ' policy/policies currently assigned'),
        //     ],
        //     style: context.labelMedium,
        //   ),
        // ),
        // Spacer(),
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

  Widget _buildPolicyRow(
    UserPolicy policy, {
    bool isSelected = false,
    final VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: .1)
              : context.isDark
              ? AppColors.cardBackgroundDark
              : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: context.isDark
                ? AppColors.cardBorderDark
                : AppColors.dashboardCardBorder,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    policy.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: context.isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    policy.description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            DigifySquareCapsule(
              label: policy.type,
              textColor: AppColors.primary,
              backgroundColor: AppColors.primary.withValues(alpha: .1),
            ),
          ],
        ),
      ),
    );
  }
}
