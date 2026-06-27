import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/security_manager/data/config/user_management_table_config.dart';
import 'package:grc/features/security_manager/domain/models/system_user.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_management_table_width_provider.dart';
import 'package:grc/features/security_manager/presentation/screens/user_management/user_management_permission_mixin.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/user_management_delete_mixin.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/user_management_table_types.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grc/features/security_manager/presentation/screens/user_management/user_detail_screen.dart';
import 'package:grc/features/security_manager/presentation/screens/user_management/edit_user_screen.dart';

class UserManagementTableRow extends ConsumerWidget with UserManagementDeleteMixin, UserManagementPermissionMixin {
  final SystemUser user;
  final bool isDark;
  final double widthMultiplier;

  const UserManagementTableRow({super.key, required this.user, required this.isDark, this.widthMultiplier = 1});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userManagementTableWidthsProvider);
    final isDeleting = isUserDeleting(ref, user.userGuid);

    final dividerWidths = <double>[
      ...state.columnOrder.map((col) => state.widthFor(col) * widthMultiplier),
      if (UserManagementTableConfig.showActions) UserManagementTableConfig.actionsWidth * widthMultiplier,
    ];

    final secondaryStyle = context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                for (var i = 0; i < dividerWidths.length; i++)
                  _buildDivider(dividerWidths[i], isLast: i == dividerWidths.length - 1),
              ],
            ),
          ),
          Row(
            children: [
              ...state.columnOrder.map((column) {
                final cell = switch (column) {
                  UserManagementTableColumn.user => Row(
                    children: [
                      AppAvatar(image: null, fallbackInitial: user.initials, size: 44.w),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.name,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Gap(2.h),
                            Text(user.email, style: secondaryStyle),
                            Text(user.displayEmployeeNumber, style: secondaryStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                  UserManagementTableColumn.department => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.displayDepartment,
                        style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  UserManagementTableColumn.roles => Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: user.roles
                        .map(
                          (role) => DigifyCapsule(
                            label: role,
                            textColor: AppColors.roleBadgeText,
                            backgroundColor: AppColors.roleBadgeBg,
                            borderColor: AppColors.roleBadgeBorder,
                          ),
                        )
                        .toList(),
                  ),
                  UserManagementTableColumn.status => DigifyStatusCapsule(status: user.displayStatus),
                  UserManagementTableColumn.security => Align(
                    alignment: Alignment.centerLeft,
                    child: DigifyCapsule(
                      label: user.twoFaLabel,
                      iconPath: Assets.icons.auth.secureShield.path,
                      textColor: user.is2FAEnabled ? AppColors.activeStatusTextLight : AppColors.orange,
                      backgroundColor: user.is2FAEnabled ? AppColors.activeStatusBgLight : AppColors.orangeBg,
                      borderColor: user.is2FAEnabled ? AppColors.activeStatusBorderLight : AppColors.orangeBorder,
                    ),
                  ),
                };

                return _buildDataCell(cell, state.widthFor(column) * widthMultiplier);
              }),
              if (UserManagementTableConfig.showActions)
                _buildDataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8.w,
                    children: [
                      if (canViewUser)
                        ActionButtonWidget(
                          type: ActionButtonType.view,
                          onTap: () => context.pushNamed(UserDetailScreen.routeName, extra: user),
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                      if (canUpdateUser)
                        ActionButtonWidget(
                          type: ActionButtonType.edit,
                          onTap: () => context.pushNamed(EditUserScreen.routeName, extra: user),
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                      if (canDeleteUser)
                        ActionButtonWidget(
                          type: ActionButtonType.delete,
                          isLoading: isDeleting,
                          onTap: () async {
                            await confirmAndDeleteUser(context: context, ref: ref, user: user);
                          },
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                    ],
                  ),
                  UserManagementTableConfig.actionsWidth * widthMultiplier,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(double width, {required bool isLast}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: AppColors.cardBorder, width: 1.w),
              ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: UserManagementTableConfig.cellPaddingHorizontal.w,
          vertical: 16.h,
        ),
        child: child,
      ),
    );
  }
}
