import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../data/models/access_management/access_role.dart';
import '../../dialogs/access_management/role_form_dialog.dart';
import '../../providers/access_management/access_management_provider.dart';
import 'access_section_card.dart';

class AccessRoleDetailsSection extends ConsumerWidget {
  const AccessRoleDetailsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleDetail = ref.watch(accessManagementProvider).roleDetail;

    return Column(
      children: [
        _buildRoleDetailsBasicInfo(context, roleDetail),
        Gap(24.h),
        _buildPermissionMatrix(context, roleDetail),
      ],
    );
  }

  Widget _buildRoleDetailsBasicInfo(
    BuildContext context,
    AccessRoleDetail? detail,
  ) {
    final titleColor = context.isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final subtitleColor = context.isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return AccessSectionCard(
      title: 'Roles Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ROLE NAME',
            style: context.textTheme.bodySmall?.copyWith(
              color: subtitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
          ),
          Gap(4.h),
          Text(
            detail?.name ?? "N/A",
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          Gap(16.h),
          Text(
            'DESCRIPTION',
            style: context.textTheme.bodySmall?.copyWith(
              color: subtitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
          ),
          Gap(4.h),
          Text(
            detail?.description ?? "N/A",
            style: context.textTheme.bodyMedium?.copyWith(color: titleColor),
          ),
          Gap(16.h),
          Text(
            'USERS ASSIGNED',
            style: context.textTheme.bodySmall?.copyWith(
              color: subtitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
          ),
          Gap(4.h),
          Text(
            '${detail?.assignedUsersCount ?? 0} users',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          Gap(24.h),
          Row(
            children: [
              AppButton(
                label: 'Edit Role',
                icon: Icons.edit,
                backgroundColor: AppColors.primary.withValues(alpha: .1),
                foregroundColor: AppColors.primary,
                onPressed: () =>
                    RoleFormDialog.show(context, roleDetail: detail),
              ),
              Gap(12.w),
              AppButton.outline(
                label: 'Clone Role',
                icon: Icons.copy,
                onPressed: () {},
              ),
              Gap(12.w),
              AppButton(
                label: 'Delete Role',
                icon: Icons.delete,
                backgroundColor: AppColors.error.withValues(alpha: .1),
                foregroundColor: AppColors.error,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionMatrix(
    BuildContext context,
    AccessRoleDetail? detail,
  ) {
    final titleColor = context.isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;

    return AccessSectionCard(
      title: 'Permission Matrix',
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.isDark
                      ? AppColors.cardBorderDark
                      : AppColors.cardBorder,
                ),
              ),
            ),
            children: [
              _buildTableHeader(
                context,
                title: 'Module',
                alignment: Alignment.centerLeft,
              ),
              _buildTableHeader(context, title: 'View'),
              _buildTableHeader(context, title: 'Create'),
              _buildTableHeader(context, title: 'Edit'),
              _buildTableHeader(context, title: 'Delete'),
            ],
          ),
          for (AccessRolePermission module in detail?.permissions ?? [])
            TableRow(
              children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Text(
                      module.name,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: DigifyCheckbox(
                        value: module.view,
                        enabled: false,
                        onChanged: (value) {},
                        alignment: MainAxisAlignment.center,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: DigifyCheckbox(
                        value: module.create,
                        enabled: false,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: DigifyCheckbox(
                        value: module.edit,
                        enabled: false,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: DigifyCheckbox(
                        value: module.delete,
                        enabled: false,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(
    BuildContext context, {
    required String title,
    Alignment alignment = Alignment.center,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      alignment: alignment,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: context.isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}
