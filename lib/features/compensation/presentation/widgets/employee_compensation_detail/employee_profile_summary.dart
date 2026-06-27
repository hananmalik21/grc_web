import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_section_card.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeProfileSummary extends ConsumerWidget {
  const EmployeeProfileSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeCompensationDetailProvider);
    final isMobile = context.isMobileLayout;

    Widget infoRow(String l1, String v1, String l2, String v2) {
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.h,
          children: [_buildInfoItem(context, l1, v1), _buildInfoItem(context, l2, v2)],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildInfoItem(context, l1, v1)),
          Expanded(child: _buildInfoItem(context, l2, v2)),
        ],
      );
    }

    return CompensationSectionCard(
      title: 'Employee Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(fallbackInitial: state.employeeName, size: isMobile ? 48 : 64),
              Gap(isMobile ? 12.w : 24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.h,
                  children: [
                    Text(state.employeeName, style: context.textTheme.titleLarge),
                    infoRow('EMPLOYEE NUMBER', state.employeeNumber, 'DEPARTMENT', state.department),
                    infoRow('POSITION', state.position, 'GRADE', state.grade),
                    infoRow('EMPLOYMENT TYPE', state.employmentType, 'HIRE DATE', state.hireDate),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(fontSize: 11.sp, color: AppColors.grayBorderDark),
        ),
        Gap(4.h),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
