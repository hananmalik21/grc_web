import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/employee_self_service/presentation/providers/employment_info/employment_info_provider.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/employment_info/widgets/compliance_details_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/employment_info/widgets/current_assignment_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/employment_info/widgets/reporting_structure_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmploymentInfoTabView extends ConsumerWidget {
  const EmploymentInfoTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employmentInfoProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTabHeader(title: state.headerTitle, description: state.headerSubtitle),
          Gap(24.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isStacked = constraints.maxWidth < 980;
              final currentAssignmentCard = CurrentAssignmentCard(state: state);
              final complianceCard = ComplianceDetailsCard(state: state);

              if (isStacked) {
                return Column(children: [currentAssignmentCard, Gap(24.h), complianceCard]);
              }

              return SizedBox(
                height: 404.h,
                child: Row(
                  children: [
                    Expanded(child: currentAssignmentCard),
                    Gap(20.w),
                    Expanded(child: complianceCard),
                  ],
                ),
              );
            },
          ),
          Gap(24.h),
          ReportingStructureCard(directManager: state.directManager, myTeam: state.myTeam),
        ],
      ),
    );
  }
}
