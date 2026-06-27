import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../../core/widgets/common/digify_divider.dart';
import '../../../../../../core/widgets/common/digify_radio.dart';
import '../../../../../../core/widgets/forms/date_selection_field.dart';
import '../../../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';

class CountrySetup extends ConsumerStatefulWidget {
  const CountrySetup({super.key});

  @override
  ConsumerState<CountrySetup> createState() => _CountrySetupState();
}

class _CountrySetupState extends ConsumerState<CountrySetup> {
  final List<String> countries = [
    'Kuwait - GCC',
    'Saudi Arabia - GCC',
    'United Arab Emirates - GCC',
    'Qatar - GCC',
    'Oman - GCC',
    'Bahrain - GCC',
  ];

  String? selectedCountry = 'Kuwait - GCC';

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Column(
        children: [
          _buildCountryConfigurationCard(context),
          Gap(24.h),
          _buildComplianceSnapshotCard(context),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildCountryConfigurationCard(context)),
          Gap(24.w),
          Expanded(child: _buildComplianceSnapshotCard(context)),
        ],
      );
    }
  }

  Widget _buildCountryConfigurationCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.isDark
              ? AppColors.inputBorderDark
              : AppColors.inputBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Text(
              'Country Configuration',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigifySelectFieldWithLabel<String>(
                  label: 'COUNTRY',
                  items: countries,
                  value: selectedCountry,
                  itemLabelBuilder: (item) => item,
                  onChanged: (val) => setState(() => selectedCountry = val),
                ),
                Gap(18.h),
                const DigifyTextField(
                  labelText: 'REGION',
                  hintText: 'GCC',
                  readOnly: true,
                ),
                Gap(18.h),
                const DigifyTextField(
                  labelText: 'CURRENCY CODE',
                  hintText: 'KWD',
                  readOnly: true,
                ),
                Gap(18.h),
                DigifySelectFieldWithLabel<String>(
                  label: 'DEFAULT PAY FREQUENCY',
                  items: const ['Monthly', 'Weekly', 'Bi-Weekly'],
                  value: 'Monthly',
                  itemLabelBuilder: (item) => item,
                  onChanged: (val) {},
                ),
                Gap(18.h),
                DigifySelectFieldWithLabel<String>(
                  label: 'WORK WEEK PATTERN',
                  items: const [
                    'Sunday - Thursday (5 days)',
                    'Monday - Friday (5 days)',
                  ],
                  value: 'Sunday - Thursday (5 days)',
                  itemLabelBuilder: (item) => item,
                  onChanged: (val) {},
                ),
                Gap(18.h),
                DigifySelectFieldWithLabel<String>(
                  label: 'NATIONALITY CATEGORY HANDLING',
                  items: const ['National / GCC / Expatriate', 'All Combined'],
                  value: 'National / GCC / Expatriate',
                  itemLabelBuilder: (item) => item,
                  onChanged: (val) {},
                ),
                Gap(18.h),
                if (context.isMobile) ...[
                  DateSelectionField(
                    label: "EFFECTIVE START DATE",
                    date: DateTime(2024, 1, 1),
                    onDateSelected: (date) {},
                  ),
                  Gap(18.h),
                  DateSelectionField(
                    label: "EFFECTIVE END DATE",
                    date: null,
                    hintText: 'dd/mm/yyyy',
                    onDateSelected: (date) {},
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: DateSelectionField(
                          label: "EFFECTIVE START DATE",
                          date: DateTime(2024, 1, 1),
                          onDateSelected: (date) {},
                        ),
                      ),
                      Gap(16.w),
                      Expanded(
                        child: DateSelectionField(
                          label: "EFFECTIVE END DATE",
                          date: null,
                          hintText: 'dd/mm/yyyy',
                          onDateSelected: (date) {},
                        ),
                      ),
                    ],
                  ),
                ],
                Gap(18.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STATUS',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: context.isDark
                            ? context.themeTextPrimary
                            : AppColors.inputLabel,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Gap(8.h),
                    Row(
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: DigifyRadio(
                            value: 'DRAFT',
                            groupValue: 'DRAFT',
                            labelWidget: Text('DRAFT'),
                            onChanged: (val) {},
                          ),
                        ),
                        Gap(18.w),
                        SizedBox(
                          width: 100.w,
                          child: DigifyRadio(
                            value: 'ACTIVE',
                            groupValue: 'DRAFT',
                            labelWidget: Text('ACTIVE'),
                            onChanged: (val) {},
                          ),
                        ),
                        Gap(18.w),
                        SizedBox(
                          width: 100.w,
                          child: DigifyRadio(
                            value: 'INACTIVE',
                            groupValue: 'DRAFT',
                            labelWidget: Text('INACTIVE'),
                            onChanged: (val) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceSnapshotCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.isDark
              ? AppColors.inputBorderDark
              : AppColors.inputBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Country Compliance Snapshot',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Gap(16.h),
          const Divider(),
          Gap(24.h),
          _buildSnapshotItem(
            context,
            label: 'Required Salary Structure',
            trailing: Text(
              'Basic + Allowances',
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildSnapshotItem(
            context,
            label: 'Mandatory Benefits',
            trailing: Text(
              'PIFSS, Leave Encashment',
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildSnapshotItem(
            context,
            label: 'Severance Method',
            trailing: Text(
              'Labor Law Indemnity',
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildSnapshotItem(
            context,
            label: 'Currency',
            trailing: Text(
              'KWD (Kuwaiti Dinar)',
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildSnapshotItem(
            context,
            label: 'Payroll Integration',
            trailing: DigifyCapsule(
              label: 'Connected',
              textColor: AppColors.success,
              backgroundColor: AppColors.success.withValues(alpha: 0.1),
            ),
          ),
          _buildSnapshotItem(
            context,
            label: 'Last Reviewed',
            trailing: Text(
              '15-Feb-2026',
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotItem(
    BuildContext context, {
    required String label,
    Widget? trailing,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
