import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/tabs/employment_details_sections/employment_details_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmploymentDetailsTabContent extends StatelessWidget {
  const EmploymentDetailsTabContent({super.key, required this.isDark, this.fullDetails, this.wrapInScrollView = true});

  final bool isDark;
  final EmployeeFullDetails? fullDetails;
  final bool wrapInScrollView;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EnterpriseStructureSection(isDark: isDark, fullDetails: fullDetails),
          Gap(24.h),
          WorkforceStructureSection(isDark: isDark, fullDetails: fullDetails),
          Gap(24.h),
          EmploymentInformationSection(isDark: isDark, fullDetails: fullDetails),
        ],
      ),
    );
    if (wrapInScrollView) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: content,
      );
    }
    return content;
  }
}
