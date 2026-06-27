import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/security_manager/presentation/providers/application_roles/application_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/application_roles/mobile/application_role_card_mobile.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/application_role_detail_mobile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

const _pageSize = 5;

class ApplicationRolesDirectorySectionMobile extends ConsumerStatefulWidget {
  const ApplicationRolesDirectorySectionMobile({super.key});

  @override
  ConsumerState<ApplicationRolesDirectorySectionMobile> createState() => _ApplicationRolesDirectorySectionMobileState();
}

class _ApplicationRolesDirectorySectionMobileState extends ConsumerState<ApplicationRolesDirectorySectionMobile> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final roles = ref.watch(applicationRolesProvider).filteredRoles;
    final totalItems = roles.length;
    final totalPages = (totalItems / _pageSize).ceil().clamp(1, double.infinity).toInt();

    final safePage = _currentPage.clamp(1, totalPages < 1 ? 1 : totalPages);
    if (safePage != _currentPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _currentPage = safePage);
      });
    }

    final startIndex = (safePage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, totalItems);
    final pageRoles = roles.sublist(startIndex, endIndex);

    return Column(
      children: [
        RolesManagementSurfaceCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: _DirectoryHeaderMobile(totalRoles: totalItems),
              ),
              if (pageRoles.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: const RolesManagementEmptyBody(message: 'No application roles found for the current filter.'),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: pageRoles.length,
                  separatorBuilder: (_, _) => Gap(12.h),
                  itemBuilder: (context, index) {
                    return ApplicationRoleCardMobile(
                      role: pageRoles[index],
                      onView: () => ApplicationRoleDetailMobileSheet.show(context, pageRoles[index]),
                      onEdit: () {},
                      onDelete: () {},
                    );
                  },
                ),
              Gap(16.h),
            ],
          ),
        ),
        if (totalItems > 0) ...[
          Gap(16.h),
          PaginationControls(
            currentPage: safePage,
            totalPages: totalPages,
            totalItems: totalItems,
            pageSize: _pageSize,
            hasNext: safePage < totalPages,
            hasPrevious: safePage > 1,
            onPrevious: () => setState(() => _currentPage = safePage - 1),
            onNext: () => setState(() => _currentPage = safePage + 1),
          ),
        ],
      ],
    );
  }
}

class _DirectoryHeaderMobile extends StatelessWidget with RolesManagementPermissionMixin {
  const _DirectoryHeaderMobile({required this.totalRoles});

  final int totalRoles;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Roles Directory',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Text(
                  '($totalRoles roles)',
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.grayBorderDark),
                ),
              ],
            ),
            Row(
              children: [
                _IconButton(svgPath: Assets.icons.downloadIcon.path, onPressed: () {}, isDark: isDark),
                if (canCreateRole) ...[
                  Gap(8.w),
                  _IconButton(
                    svgPath: Assets.icons.addDivisionIcon.path,
                    onPressed: () {},
                    isDark: isDark,
                    isPrimary: true,
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.svgPath, required this.onPressed, required this.isDark, this.isPrimary = false});

  final String svgPath;
  final VoidCallback onPressed;
  final bool isDark;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground),
          borderRadius: BorderRadius.circular(8.r),
          border: isPrimary ? null : Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          boxShadow: isPrimary ? AppShadows.primaryShadow : null,
        ),
        child: DigifyAsset(
          assetPath: svgPath,
          width: 18.w,
          height: 18.w,
          color: isPrimary ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
        ),
      ),
    );
  }
}
