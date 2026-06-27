import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/widgets/data_role_org_tree_section.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/security_manager_org_structure_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DataRoleEnterpriseStructureFields extends ConsumerWidget {
  const DataRoleEnterpriseStructureFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgStructureState = ref.watch(securityManagerOrgStructureNotifierProvider);
    final activeLevels = orgStructureState.orgStructure?.activeLevels ?? [];
    final structureId = orgStructureState.orgStructure?.structureId;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(),
          Gap(8.h),
          _AccessScopeHint(),
          Gap(16.h),
          if (orgStructureState.isLoading)
            const _OrgFieldsSkeleton()
          else if (orgStructureState.error != null)
            Text(
              'Failed to load structure: ${orgStructureState.error}',
              style: TextStyle(fontSize: 13.sp, color: AppColors.error),
            )
          else if (activeLevels.isEmpty || structureId == null)
            Text(
              'No organizational structure found.',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            )
          else
            DataRoleOrgTreeSection(levels: activeLevels, structureId: structureId),
        ],
      ),
    );
  }
}

class _OrgFieldsSkeleton extends StatelessWidget {
  const _OrgFieldsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(3, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: i < 2 ? 16.h : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100.w,
                  height: 13.h,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                ),
                SizedBox(height: 6.h),
                Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r)),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Organizational Unit Access',
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
    );
  }
}

class _AccessScopeHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16.sp, color: AppColors.primary),
          Gap(8.w),
          Expanded(
            child: Text(
              'Select units at any level to define the access boundary. '
              'You can select multiple units and nest selections within each.',
              style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
