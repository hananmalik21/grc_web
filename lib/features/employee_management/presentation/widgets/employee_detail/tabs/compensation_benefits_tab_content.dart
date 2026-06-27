import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/presentation/utils/employee_detail_formatters.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_row_section_card.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/tabs/employee_detail_assigned_components_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationBenefitsTabContent extends StatelessWidget {
  const CompensationBenefitsTabContent({
    super.key,
    required this.isDark,
    required this.employeeGuid,
    this.fullDetails,
    this.wrapInScrollView = true,
  });

  final bool isDark;
  final String employeeGuid;
  final EmployeeFullDetails? fullDetails;
  final bool wrapInScrollView;

  List<EmployeeDetailRowItem> _salaryComponentsRows() {
    final comp = fullDetails?.compensation;
    final allow = fullDetails?.allowances;
    if (comp == null && allow == null) {
      return List.generate(6, (_) => const EmployeeDetailRowItem(label: '—', value: '—'));
    }
    return [
      EmployeeDetailRowItem(label: 'Basic Salary', value: formatKwd(comp?.basicSalaryKwd)),
      EmployeeDetailRowItem(label: 'Housing Allowance', value: formatKwd(allow?.housingKwd)),
      EmployeeDetailRowItem(label: 'Transportation Allowance', value: formatKwd(allow?.transportKwd)),
      EmployeeDetailRowItem(label: 'Food Allowance', value: formatKwd(allow?.foodKwd)),
      EmployeeDetailRowItem(label: 'Mobile Allowance', value: formatKwd(allow?.mobileKwd)),
      EmployeeDetailRowItem(label: 'Other Allowances', value: formatKwd(allow?.otherKwd)),
    ];
  }

  String _totalSalary() {
    if (fullDetails == null) return '—';
    final base = fullDetails!.compensation?.basicSalaryKwd ?? 0.0;
    final a = fullDetails!.allowances;
    final total =
        base +
        (a?.housingKwd ?? 0) +
        (a?.transportKwd ?? 0) +
        (a?.foodKwd ?? 0) +
        (a?.mobileKwd ?? 0) +
        (a?.otherKwd ?? 0);
    return total == 0 ? '—' : '${total.toStringAsFixed(3)} KWD';
  }

  String _pifssLine() {
    final total = _totalSalary();
    if (total == '—') return 'PIFSS Contribution (Expat 8%): —';
    try {
      final numStr = total.replaceAll(RegExp(r'[^0-9.]'), '');
      final value = double.tryParse(numStr);
      if (value != null && value > 0) {
        final contrib = value * 0.08;
        return 'PIFSS Contribution (Expat 8%): ${contrib.toStringAsFixed(3)} KWD';
      }
    } catch (_) {}
    return 'PIFSS Contribution (Expat 8%): —';
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final footerBg = isDark ? AppColors.infoBgDark : AppColors.infoBg;
    final footerBorderColor = isDark ? AppColors.infoBorderDark : AppColors.infoBorder;

    final salaryFooter = Container(
      margin: EdgeInsets.all(24.w).copyWith(top: 0.0),
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: footerBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: footerBorderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Total Monthly Salary',
                  style: context.textTheme.titleMedium?.copyWith(color: textPrimary),
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
              Gap(8.w),
              Flexible(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      _totalSalary(),
                      style: context.textTheme.displaySmall?.copyWith(color: AppColors.primary, fontSize: 29.w),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.infoCircleBlue.path,
                width: 16.w,
                height: 16.h,
                color: AppColors.permissionBadgeText,
              ),
              Gap(6.w),
              Expanded(
                child: Text(
                  _pifssLine(),
                  style: context.textTheme.bodyMedium?.copyWith(color: AppColors.permissionBadgeText),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final content = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmployeeDetailRowSectionCard(
            title: 'Salary Components',
            titleIconAssetPath: Assets.icons.leaveManagement.dollar.path,
            rows: _salaryComponentsRows(),
            footer: salaryFooter,
            isDark: isDark,
          ),
          if (employeeGuid.isNotEmpty) ...[
            Gap(24.h),
            EmployeeDetailAssignedComponentsSection(employeeGuid: employeeGuid, isDark: isDark),
          ],
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
