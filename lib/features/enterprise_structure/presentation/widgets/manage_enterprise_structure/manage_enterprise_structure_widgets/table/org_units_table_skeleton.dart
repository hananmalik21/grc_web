import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/enterprise_structure/data/config/manage_org_units_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrgUnitsTableSkeleton extends StatelessWidget {
  const OrgUnitsTableSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        8,
        (index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
            ),
          ),
          child: Row(
            children: [
              if (ManageOrgUnitsTableConfig.showIndex) _buildSkeletonCell(ManageOrgUnitsTableConfig.indexWidth.w),
              if (ManageOrgUnitsTableConfig.showOrgStructure)
                _buildSkeletonCell(ManageOrgUnitsTableConfig.orgStructureWidth.w),
              if (ManageOrgUnitsTableConfig.showEnterpriseId)
                _buildSkeletonCell(ManageOrgUnitsTableConfig.enterpriseIdWidth.w),
              if (ManageOrgUnitsTableConfig.showLevelCode)
                _buildSkeletonCell(ManageOrgUnitsTableConfig.levelCodeWidth.w),
              if (ManageOrgUnitsTableConfig.showOrgUnitCode)
                _buildSkeletonCell(ManageOrgUnitsTableConfig.orgUnitCodeWidth.w),
              if (ManageOrgUnitsTableConfig.showNameEn) _buildSkeletonCell(ManageOrgUnitsTableConfig.nameEnWidth.w),
              if (ManageOrgUnitsTableConfig.showNameAr) _buildSkeletonCell(ManageOrgUnitsTableConfig.nameArWidth.w),
              if (ManageOrgUnitsTableConfig.showParent) _buildSkeletonCell(ManageOrgUnitsTableConfig.parentWidth.w),
              if (ManageOrgUnitsTableConfig.showManager) _buildSkeletonCell(ManageOrgUnitsTableConfig.managerWidth.w),
              if (ManageOrgUnitsTableConfig.showLocation) _buildSkeletonCell(ManageOrgUnitsTableConfig.locationWidth.w),
              if (ManageOrgUnitsTableConfig.showActive) _buildSkeletonCell(ManageOrgUnitsTableConfig.activeWidth.w),
              if (ManageOrgUnitsTableConfig.showLastUpdated)
                _buildSkeletonCell(ManageOrgUnitsTableConfig.lastUpdatedWidth.w),
              if (ManageOrgUnitsTableConfig.showActions) _buildSkeletonCell(ManageOrgUnitsTableConfig.actionsWidth.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonCell(double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: ManageOrgUnitsTableConfig.cellPaddingHorizontal.w,
        vertical: 20.h,
      ),
      child: Bone.text(words: 1),
    );
  }
}
