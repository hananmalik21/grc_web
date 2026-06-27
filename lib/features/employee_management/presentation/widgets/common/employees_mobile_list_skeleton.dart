import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeesMobileListSkeleton extends StatelessWidget {
  const EmployeesMobileListSkeleton({super.key, required this.isDark, this.itemCount = 6});

  final bool isDark;
  final int itemCount;

  List<EmployeeListItem> _mockEmployees() => List.generate(
    itemCount,
    (i) => EmployeeListItem(
      id: 'mock_$i',
      fullName: 'Mock User $i',
      employeeNumber: 'E$i',
      position: EmployeeListItem.empty().position,
      department: 'Department $i',
      status: i.isEven ? 'Active' : 'Probation',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final mockEmployees = _mockEmployees();
    final bgColor = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final shimmerBase = isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBorder;

    return Skeletonizer(
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemCount: mockEmployees.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (_, _) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: tileBorderColor, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 34.w,
                                height: 34.w,
                                decoration: BoxDecoration(color: shimmerBase, borderRadius: BorderRadius.circular(8.r)),
                              ),
                              Gap(10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 12.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: shimmerBase,
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                    ),
                                    Gap(4.h),
                                    Container(
                                      height: 10.h,
                                      width: 120.w,
                                      decoration: BoxDecoration(
                                        color: shimmerBase,
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 90.w,
                          height: 26.h,
                          decoration: BoxDecoration(color: shimmerBase, borderRadius: BorderRadius.circular(20.r)),
                        ),
                      ],
                    ),
                    Gap(10.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 10.h,
                        width: 160.w,
                        decoration: BoxDecoration(color: shimmerBase, borderRadius: BorderRadius.circular(4.r)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
