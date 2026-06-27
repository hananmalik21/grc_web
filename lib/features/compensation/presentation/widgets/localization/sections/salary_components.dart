import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/common/digify_capsule.dart';

enum SalaryComponentCategory {
  salary,
  allowance,
  benefit,
  variablePay;

  String get label => switch (this) {
    salary => 'Salary',
    allowance => 'Allowance',
    benefit => 'Benefit',
    variablePay => 'Variable Pay',
  };

  Color get backgroundColor => switch (this) {
    salary => AppColors.infoBg,
    allowance => AppColors.primary.withValues(alpha: 0.1),
    benefit => AppColors.purpleBg,
    variablePay => AppColors.sidebarActiveBg,
  };

  Color get textColor => switch (this) {
    salary => AppColors.infoText,
    allowance => AppColors.primary,
    benefit => AppColors.purpleText,
    variablePay => AppColors.sidebarActiveText,
  };
}

enum FormulaType {
  fixed,
  percentage,
  formula;

  String get label => switch (this) {
    fixed => 'Fixed',
    percentage => 'Percentage',
    formula => 'Formula',
  };
}

class SalaryComponent {
  final String code;
  final String name;
  final SalaryComponentCategory category;
  final bool isMandatory;
  final bool isTaxable;
  final bool isPensionable;
  final FormulaType formulaType;
  final bool isActive;

  const SalaryComponent({
    required this.code,
    required this.name,
    required this.category,
    required this.isMandatory,
    required this.isTaxable,
    required this.isPensionable,
    required this.formulaType,
    required this.isActive,
  });
}

class SalaryComponents extends ConsumerStatefulWidget {
  const SalaryComponents({super.key});

  @override
  ConsumerState<SalaryComponents> createState() => _SalaryComponentsState();
}

class _SalaryComponentsState extends ConsumerState<SalaryComponents> {
  final List<SalaryComponent> _allComponents = [
    const SalaryComponent(
      code: 'BASIC_SALARY',
      name: 'Basic Salary',
      category: SalaryComponentCategory.salary,
      isMandatory: true,
      isTaxable: true,
      isPensionable: true,
      formulaType: FormulaType.fixed,
      isActive: true,
    ),
    const SalaryComponent(
      code: 'HOUSING_ALLOWANCE',
      name: 'Housing Allowance',
      category: SalaryComponentCategory.allowance,
      isMandatory: true,
      isTaxable: false,
      isPensionable: false,
      formulaType: FormulaType.percentage,
      isActive: true,
    ),
    const SalaryComponent(
      code: 'TRANSPORT_ALLOWANCE',
      name: 'Transport Allowance',
      category: SalaryComponentCategory.allowance,
      isMandatory: true,
      isTaxable: false,
      isPensionable: false,
      formulaType: FormulaType.fixed,
      isActive: true,
    ),
    const SalaryComponent(
      code: 'MOBILE_ALLOWANCE',
      name: 'Mobile Allowance',
      category: SalaryComponentCategory.allowance,
      isMandatory: false,
      isTaxable: false,
      isPensionable: false,
      formulaType: FormulaType.fixed,
      isActive: true,
    ),
    const SalaryComponent(
      code: 'COST_OF_LIVING',
      name: 'Cost of Living Adjustment',
      category: SalaryComponentCategory.allowance,
      isMandatory: false,
      isTaxable: true,
      isPensionable: false,
      formulaType: FormulaType.formula,
      isActive: true,
    ),
    const SalaryComponent(
      code: 'MEAL_ALLOWANCE',
      name: 'Meal Allowance',
      category: SalaryComponentCategory.allowance,
      isMandatory: false,
      isTaxable: false,
      isPensionable: false,
      formulaType: FormulaType.fixed,
      isActive: true,
    ),
    const SalaryComponent(
      code: 'SHIFT_ALLOWANCE',
      name: 'Shift Allowance',
      category: SalaryComponentCategory.allowance,
      isMandatory: false,
      isTaxable: true,
      isPensionable: false,
      formulaType: FormulaType.percentage,
      isActive: true,
    ),
    const SalaryComponent(
      code: 'HAZARD_ALLOWANCE',
      name: 'Hazard Allowance',
      category: SalaryComponentCategory.allowance,
      isMandatory: false,
      isTaxable: true,
      isPensionable: true,
      formulaType: FormulaType.fixed,
      isActive: true,
    ),
    const SalaryComponent(
      code: 'SCHOOLING_ALLOWANCE',
      name: 'Schooling Allowance',
      category: SalaryComponentCategory.benefit,
      isMandatory: false,
      isTaxable: false,
      isPensionable: false,
      formulaType: FormulaType.fixed,
      isActive: true,
    ),
    const SalaryComponent(
      code: 'ANNUAL_BONUS',
      name: 'Annual Bonus',
      category: SalaryComponentCategory.variablePay,
      isMandatory: false,
      isTaxable: true,
      isPensionable: false,
      formulaType: FormulaType.formula,
      isActive: true,
    ),
  ];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredComponents = _allComponents.where((c) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Mandatory') return c.isMandatory;
      if (_selectedFilter == 'Optional') return !c.isMandatory;
      if (_selectedFilter == 'Taxable') return c.isTaxable;
      if (_selectedFilter == 'Non-Taxable') return !c.isTaxable;
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderActions(context),
        Gap(24.h),
        _buildDataTable(context, filteredComponents),
      ],
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.filter_list,
                size: 18.sp,
                color: AppColors.textPrimary,
              ),
              Gap(8.w),
              Text(
                'Filter',
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Gap(12.w),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Mandatory', 'Optional', 'Taxable', 'Non-Taxable']
                  .map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedFilter = filter);
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.cardBackgroundGrey,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 13.sp,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ),
        Gap(12.w),
        AppButton.outline(
          label: 'Download Mapping',
          icon: Icons.download,
          onPressed: () {},
        ),
        Gap(12.w),
        AppButton.outline(
          label: 'Bulk Edit',
          icon: Icons.edit_note,
          onPressed: () {},
        ),
        Gap(12.w),
        AppButton.outline(label: 'Add Country Template', onPressed: () {}),
        Gap(12.w),
        AppButton.primary(
          label: 'Add Component',
          icon: Icons.add,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDataTable(
    BuildContext context,
    List<SalaryComponent> components,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.isDark
              ? AppColors.cardBorderDark
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        children: [
          _buildTableHeader(context),
          const Divider(height: 1, color: AppColors.cardBorder),
          ...components.asMap().entries.map((entry) {
            final isLast = entry.key == components.length - 1;
            return Column(
              children: [
                _buildTableRow(context, entry.value),
                if (!isLast)
                  const Divider(height: 1, color: AppColors.cardBorder),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      color: context.isDark
          ? AppColors.backgroundDark
          : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          _buildHeaderItem('COMPONENT CODE', 2),
          _buildHeaderItem('COMPONENT NAME', 2),
          _buildHeaderItem('CATEGORY', 1.5),
          _buildHeaderItem('MANDATORY', 1, Alignment.center),
          _buildHeaderItem('TAXABLE', 1, Alignment.center),
          _buildHeaderItem('PENSIONABLE', 1, Alignment.center),
          _buildHeaderItem('FORMULA TYPE', 1.5),
          _buildHeaderItem('STATUS', 1),
          _buildHeaderItem('ACTIONS', 1.2, Alignment.centerRight),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(
    String label,
    double flex, [
    Alignment alignment = Alignment.centerLeft,
  ]) {
    return Expanded(
      flex: (flex * 100).toInt(),
      child: Align(
        alignment: alignment,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.tableHeaderText,
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, SalaryComponent component) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            flex: 200,
            child: Text(
              component.code,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 200,
            child: Text(component.name, style: context.textTheme.bodyMedium),
          ),
          Expanded(
            flex: 150,
            child: Align(
              alignment: Alignment.centerLeft,
              child: DigifyCapsule(
                label: component.category.label,
                backgroundColor: component.category.backgroundColor,
                textColor: component.category.textColor,
                borderColor: Colors.transparent,
              ),
            ),
          ),
          Expanded(
            flex: 100,
            child: Center(child: _buildStatusIndicator(component.isMandatory)),
          ),
          Expanded(
            flex: 100,
            child: Center(child: _buildStatusIndicator(component.isTaxable)),
          ),
          Expanded(
            flex: 100,
            child: Center(
              child: _buildStatusIndicator(component.isPensionable),
            ),
          ),
          Expanded(
            flex: 150,
            child: Text(
              component.formulaType.label,
              style: context.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 100,
            child: DigifyCapsule(
              label: 'Active',
              backgroundColor: AppColors.successBg,
              textColor: AppColors.success,
              borderColor: Colors.transparent,
            ),
          ),
          Expanded(
            flex: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionIcon(Icons.remove_red_eye, AppColors.info),
                Gap(12.w),
                _buildActionIcon(Icons.edit, AppColors.editIconGreen),
                Gap(12.w),
                _buildActionIcon(Icons.delete_outline, AppColors.error),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(bool isActive) {
    return isActive
        ? Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 20.sp,
          )
        : Icon(Icons.circle_outlined, color: AppColors.cardBorder, size: 20.sp);
  }

  Widget _buildActionIcon(IconData icon, Color color) {
    return Icon(icon, size: 18.sp, color: color);
  }
}
