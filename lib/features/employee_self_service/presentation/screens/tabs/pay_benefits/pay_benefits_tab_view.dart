import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/employee_self_service/presentation/providers/pay_benefits/pay_benefits_provider.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/pay_benefits/widgets/bank_details_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/pay_benefits/widgets/salary_components_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PayBenefitsTabView extends ConsumerWidget {
  const PayBenefitsTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(payBenefitsProvider);

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
              final salaryCard = SalaryComponentsCard(
                salaryComponents: state.salaryComponents,
                totalMonthlyPay: state.totalMonthlyPay,
              );
              final bankCard = BankDetailsCard(bankDetails: state.bankDetails);

              if (isStacked) {
                return Column(children: [salaryCard, Gap(24.h), bankCard]);
              }

              return SizedBox(
                height: 236.h,
                child: Row(
                  children: [
                    Expanded(child: salaryCard),
                    Gap(20.w),
                    Expanded(child: bankCard),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
