import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/widgets/create_data_role_shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateDataRoleDataScopeStep extends StatelessWidget {
  const CreateDataRoleDataScopeStep({
    super.key,
    required this.selectedDataType,
    required this.selectedCount,
    required this.searchController,
    required this.scopeOptions,
    required this.selectedScopeItems,
    required this.onSearchChanged,
    required this.onScopeTap,
  });

  final String? selectedDataType;
  final int selectedCount;
  final TextEditingController searchController;
  final List<String> scopeOptions;
  final Set<String> selectedScopeItems;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onScopeTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateDataRoleStepHeader(
          title: DataRoleFormConfig.stepLabels[1],
        ),
        Gap(18.h),
        Wrap(
          spacing: 6.w,
          runSpacing: 4.h,
          children: [
            Text(
              DataRoleFormConfig.dataScopeDescription,
              style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            Text(
              '($selectedCount selected)',
              style: context.textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Gap(16.h),
        if (selectedDataType == null)
          Container(
            width: double.infinity,
            height: 238.h,
            decoration: BoxDecoration(
              color: AppColors.sidebarSearchBg,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DigifyAsset(
                  assetPath: DataRoleFormConfig.noDataTypeIconPath,
                  width: 56,
                  height: 56,
                  color: AppColors.borderGrey,
                ),
                Gap(18.h),
                Text(
                  DataRoleFormConfig.noDataTypeTitle,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(8.h),
                Text(
                  DataRoleFormConfig.noDataTypeBody,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, height: 1.5),
                ),
              ],
            ),
          )
        else ...[
          DigifyTextField.search(
            controller: searchController,
            hintText: DataRoleFormConfig.scopeSearchHint,
            filled: true,
            fillColor: Colors.transparent,
            onChanged: onSearchChanged,
          ),
          Gap(14.h),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 238.h),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.sidebarSearchBg,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: scopeOptions.isEmpty
                ? Center(
                    child: Text(
                      DataRoleFormConfig.noScopeTitle,
                      style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                    ),
                  )
                : Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: [
                      for (final item in scopeOptions)
                        CreateDataRoleSelectableChip(
                          label: item,
                          isSelected: selectedScopeItems.contains(item),
                          onTap: () => onScopeTap(item),
                        ),
                    ],
                  ),
          ),
        ],
      ],
    );
  }
}
