import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/submit_payroll_flow_header.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/submit_payroll_flow_main_card.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/submit_payroll_flow_processing_info_banner.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SubmitPayrollFlowContent extends StatelessWidget {
  const SubmitPayrollFlowContent({required this.padding, super.key});

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);

    return Container(
      color: context.isDark ? AppColors.backgroundDark : AppColors.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SubmitPayrollFlowHeader(),
            Gap(sectionSpacing),
            const SubmitPayrollFlowProcessingInfoBanner(),
            Gap(sectionSpacing),
            const SubmitPayrollFlowMainCard(),
          ],
        ),
      ),
    );
  }
}
