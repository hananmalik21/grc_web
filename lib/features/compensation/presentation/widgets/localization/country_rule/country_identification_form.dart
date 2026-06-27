import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';

class CountryIdentificationForm extends ConsumerStatefulWidget {
  const CountryIdentificationForm({super.key});

  @override
  ConsumerState<CountryIdentificationForm> createState() =>
      _CountryIdentificationFormState();
}

class _CountryIdentificationFormState
    extends ConsumerState<CountryIdentificationForm> {
  final _countryCodeController = TextEditingController();
  final _countryNameController = TextEditingController();
  final _currencyCodeController = TextEditingController();
  final _currencySymbolController = TextEditingController();

  String? _selectedRegion;
  String? _selectedFiscalYearStart;

  final List<String> _regions = [
    'Middle East',
    'North Africa',
    'Europe',
    'Asia Pacific',
    'North America',
    'South America',
    'Sub-Saharan Africa',
  ];

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void dispose() {
    _countryCodeController.dispose();
    _countryNameController.dispose();
    _currencyCodeController.dispose();
    _currencySymbolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderCard(
            icon: Icon(Icons.public, size: 17.sp, color: AppColors.primary),
            title: 'Country Identification',
            subtitle:
                'Provide basic country information and regional classification',
          ),
          Gap(24.h),

          // Form fields in responsive 2-column grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;

              if (isWide) {
                return Column(
                  children: [
                    // Row 1: Country Code + Country Name
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildCountryCodeField()),
                        Gap(24.w),
                        Expanded(
                          child: DigifyTextField.normal(
                            controller: _countryNameController,
                            labelText: 'Country Name',
                            isRequired: true,
                            hintText: 'e.g., United States, United Kingdom',
                          ),
                        ),
                      ],
                    ),
                    Gap(20.h),

                    // Row 2: Region + Currency Code
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DigifySelectFieldWithLabel<String>(
                            label: 'Region',
                            isRequired: true,
                            hint: 'Select region',
                            items: _regions,
                            itemLabelBuilder: (item) => item,
                            value: _selectedRegion,
                            onChanged: (value) =>
                                setState(() => _selectedRegion = value),
                          ),
                        ),
                        Gap(24.w),
                        Expanded(child: _buildCurrencyCodeField()),
                      ],
                    ),
                    Gap(20.h),

                    // Row 3: Currency Symbol + Fiscal Year Start
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DigifyTextField.normal(
                            controller: _currencySymbolController,
                            labelText: 'Currency Symbol',
                            hintText: 'e.g., \$, €, £, د.ع',
                          ),
                        ),
                        Gap(24.w),
                        Expanded(
                          child: DigifySelectFieldWithLabel<String>(
                            label: 'Fiscal Year Start',
                            hint: 'Select fiscal year start month',
                            items: _months,
                            itemLabelBuilder: (item) => item,
                            value: _selectedFiscalYearStart,
                            onChanged: (value) => setState(
                              () => _selectedFiscalYearStart = value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Mobile: single column
                return Column(
                  children: [
                    _buildCountryCodeField(),
                    Gap(20.h),
                    DigifyTextField.normal(
                      controller: _countryNameController,
                      labelText: 'Country Name',
                      isRequired: true,
                      hintText: 'e.g., United States, United Kingdom',
                    ),
                    Gap(20.h),
                    DigifySelectFieldWithLabel<String>(
                      label: 'Region',
                      isRequired: true,
                      hint: 'Select region',
                      items: _regions,
                      itemLabelBuilder: (item) => item,
                      value: _selectedRegion,
                      onChanged: (value) =>
                          setState(() => _selectedRegion = value),
                    ),
                    Gap(20.h),
                    _buildCurrencyCodeField(),
                    Gap(20.h),
                    DigifyTextField.normal(
                      controller: _currencySymbolController,
                      labelText: 'Currency Symbol',
                      hintText: 'e.g., \$, €, £, د.ع',
                    ),
                    Gap(20.h),
                    DigifySelectFieldWithLabel<String>(
                      label: 'Fiscal Year Start',
                      hint: 'Select fiscal year start month',
                      items: _months,
                      itemLabelBuilder: (item) => item,
                      value: _selectedFiscalYearStart,
                      onChanged: (value) =>
                          setState(() => _selectedFiscalYearStart = value),
                    ),
                  ],
                );
              }
            },
          ),
          Gap(24.h),
          // Missing fields warning banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: context.isDark
                  ? AppColors.warningBgDark
                  : AppColors.orangeBg,
              border: Border.all(
                color: context.isDark
                    ? AppColors.warningBorderDark
                    : AppColors.orangeBorder,
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  color: context.isDark
                      ? AppColors.warningTextDark
                      : AppColors.orangeText,
                  size: 20.sp,
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Required Fields Missing',
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.isDark
                              ? AppColors.warningTextDark
                              : AppColors.orangeText,
                          fontSize: 14.sp,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        'Please fill in Country Code, Country Name, and Currency to continue.',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.isDark
                              ? AppColors.warningTextDark
                              : AppColors.orangeText,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Country Code field with helper text below
  Widget _buildCountryCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField.normal(
          controller: _countryCodeController,
          labelText: 'Country Code',
          isRequired: true,
          hintText: 'E.G., US, GB, IN, SA',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
            LengthLimitingTextInputFormatter(2),
            UpperCaseTextFormatter(),
          ],
        ),
        Gap(6.h),
        Text(
          'ISO 3166-1 alpha-2 code (2 letters)',
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
            color: context.isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Currency Code field with helper text below
  Widget _buildCurrencyCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField.normal(
          controller: _currencyCodeController,
          labelText: 'Currency Code',
          isRequired: true,
          hintText: 'E.G., USD, EUR, GBP, KWD',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
            LengthLimitingTextInputFormatter(3),
            UpperCaseTextFormatter(),
          ],
        ),
        Gap(6.h),
        Text(
          'ISO 4217 currency code (3 letters)',
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
            color: context.isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Formatter that converts text to uppercase as the user types
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
