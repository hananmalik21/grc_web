import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_location.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'salary_structure_grid.dart';

class SalaryStructureListingSkeleton extends StatelessWidget {
  const SalaryStructureListingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalaryStructureGrid(items: _skeletonItems, onView: (_) {}, onEdit: (_) {}, onDelete: (_) {}),
          Gap(24.h),
          PaginationControls(
            currentPage: 1,
            totalPages: 3,
            totalItems: 30,
            pageSize: 10,
            hasNext: true,
            hasPrevious: false,
            onPrevious: null,
            onNext: () {},
            style: PaginationStyle.simple,
          ),
        ],
      ),
    );
  }

  static final List<SalaryStructureItem> _skeletonItems = List.generate(6, (index) {
    final day = index + 1;

    return SalaryStructureItem(
      structureId: index + 1,
      structureGuid: 'SKELETON-GUID-$index',
      enterpriseId: 1,
      structureCode: 'STR-00$day',
      structureName: 'Salary Structure Placeholder $day',
      structureTypeCode: 'MONTHLY_FIXED',
      locationObj: const SalaryStructureLocation(
        lookupValueId: null,
        lookupValueGuid: null,
        lookupTypeId: null,
        tenantId: null,
        valueCode: 'KUWAIT',
        valueName: 'Kuwait',
        displaySequence: null,
        activeFlag: null,
        typeCode: null,
        typeName: null,
        typeDescription: null,
      ),
      activeFlag: 'Y',
      createdBy: 'SYSTEM',
      creationDate: DateTime(2026, 4, day),
      lastUpdatedBy: 'SYSTEM',
      lastUpdateDate: DateTime(2026, 4, day),
    );
  });
}
