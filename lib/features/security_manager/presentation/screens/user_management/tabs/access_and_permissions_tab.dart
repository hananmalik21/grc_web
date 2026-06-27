import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../data/models/user_management/user_policy.dart';
import '../../../dialogs/user_management/user_data_policy_form_dialog.dart';
import '../../../providers/user_management/user_form_provider.dart';
import '../../../widgets/user_management/user_form_section.dart';
import '../../../widgets/user_management/user_form_table_header_text.dart';

class AccessAndPermissionsTab extends ConsumerStatefulWidget {
  const AccessAndPermissionsTab({super.key});

  @override
  ConsumerState<AccessAndPermissionsTab> createState() => _AccessAndPermissionsTabState();
}

class _AccessAndPermissionsTabState extends ConsumerState<AccessAndPermissionsTab> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDataAccessPoliciesSection(context, state, notifier),
        Gap(24.h),
        _buildFunctionalPrivilegesSection(context, state, notifier),
      ],
    );
  }

  Widget _buildDataAccessPoliciesSection(BuildContext context, UserFormState state, UserFormProvider notifier) {
    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Data Access Policies',
        subtitle: 'Define what data the user can access',
        iconAssetPath: Assets.icons.securityManager.database.path,
        trailing: AppButton.primary(
          label: 'Add Policy',
          svgPath: Assets.icons.addNewIconFigma.path,
          onPressed: () => UserDataPolicyFormDialog.show(context),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: context.isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
            ),
            child: Column(children: [_buildPolicyTableHeader(), _buildEmptyPolicyTableState()]),
          ),
          Gap(24.h),
          _buildAvailableSecurityPoliciesSection(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildPolicyTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
      ),
      child: Row(
        children: [
          UserFormTableHeaderText(text: 'POLICY NAME', flex: 2, isDark: context.isDark),
          UserFormTableHeaderText(text: 'TYPE', flex: 1, isDark: context.isDark),
          UserFormTableHeaderText(text: 'SCOPE', flex: 1, isDark: context.isDark),
          UserFormTableHeaderText(text: 'EFFECTIVE DATE', flex: 1, isDark: context.isDark),
          UserFormTableHeaderText(text: 'ACTIONS', flex: 1, isDark: context.isDark),
        ],
      ),
    );
  }

  Widget _buildEmptyPolicyTableState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      alignment: Alignment.center,
      child: Text(
        'No data access policies assigned. Click "Add Policy" to grant data access.',
        style: TextStyle(
          fontSize: 14.sp,
          color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildAvailableSecurityPoliciesSection(BuildContext context, UserFormState state, UserFormProvider notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Data Security Policies',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(16.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final policy = state.availablePolicies[index];
            return _buildPolicyRow(policy);
          },
          separatorBuilder: (context, index) => Gap(12.h),
          itemCount: state.availablePolicies.length,
        ),
      ],
    );
  }

  Widget _buildPolicyRow(UserPolicy policy) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: context.isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
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
                    color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Text(
                  policy.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: context.isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              policy.type,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionalPrivilegesSection(BuildContext context, UserFormState state, UserFormProvider notifier) {
    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Functional Privileges',
        subtitle: 'Additional privileges and permissions',
        iconAssetPath: Assets.icons.securityManager.functionalRoles.path,
      ),
      child: Column(
        children: [
          Gap(16.h),
          DigifyTextField(
            hintText: 'Search privileges...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.w),
              child: DigifyAsset(
                assetPath: Assets.icons.searchIconFigma.path,
                width: 18,
                height: 18,
                color: AppColors.textPlaceholder,
              ),
            ),
            onChanged: (value) => notifier.searchFunctionalPrivileges(value),
          ),
          Gap(16.h),
          _buildPrivilegesGrid(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildPrivilegesGrid(BuildContext context, UserFormState state, UserFormProvider notifier) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isMobile ? 1 : 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: 100.h,
      ),
      itemCount: state.filteredFunctionalPrivileges.length,
      itemBuilder: (context, index) {
        final privilege = state.filteredFunctionalPrivileges[index];

        return _buildPrivilegeCard(
          title: privilege.name,
          description: privilege.description,
          category: privilege.type,
          isActive: state.selectedFunctionalPrivileges.contains(privilege.id),
          onTap: () => notifier.setFunctionalPrivilege(privilege.id),
        );
      },
    );
  }

  Widget _buildPrivilegeCard({
    required String title,
    required String description,
    required String category,
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: context.isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyCheckbox(value: isActive, onChanged: (v) {}),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
