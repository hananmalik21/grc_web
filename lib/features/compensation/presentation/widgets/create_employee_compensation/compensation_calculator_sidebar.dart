import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_calculator_sidebar_config.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_section_card.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/add_compensation_plans_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Palette used to assign a distinct color to each unique component type code.
const List<Color> _typeColorPalette = [
  AppColors.info,
  AppColors.success,
  AppColors.purple,
  AppColors.warning,
  AppColors.orange,
  AppColors.primary,
];

class CompensationCalculatorSidebar extends ConsumerWidget {
  final bool showActions;
  final CompensationPlansSelectionNotifierProvider? plansProvider;

  const CompensationCalculatorSidebar({super.key, this.showActions = true, this.plansProvider});

  CompensationPlansSelectionNotifierProvider get _plansProvider => plansProvider ?? addCompensationPlansProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectivePlansProvider = _plansProvider;
    final state = ref.watch(effectivePlansProvider);
    final notifier = ref.read(effectivePlansProvider.notifier);
    final isMobile = context.isMobileLayout;

    if (showActions) {
      ref.listen(effectivePlansProvider.select((s) => s.success), (previous, next) {
        if (next) {
          ToastService.success(context, 'Compensation plan assigned successfully');
          context.pop();
        }
      });
    }

    if (state.errorMessage != null && state.errorMessage!.isNotEmpty && !state.isCreating) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastService.error(context, state.errorMessage!);
      });
    }

    final grossFormatted = '${state.selectedCurrency} ${state.grossTotal.toStringAsFixed(0)}';
    final activePlansLabel = '${state.activePlansCount} ${state.activePlansCount == 1 ? 'Plan' : 'Plans'}';
    final typeTotals = state.componentTotalsByType;

    return Column(
      children: [
        CompensationSectionCard(
          title: CompensationCalculatorSidebarConfig.cardTitle,
          titleIconPath: Assets.icons.eosCalculatorIcon.path,
          child: Column(
            spacing: 12.h,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  border: Border.all(color: AppColors.infoBorder),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CompensationCalculatorSidebarConfig.grossCompensationLabel,
                      style: context.textTheme.labelMedium?.copyWith(fontSize: 11.sp, color: AppColors.roleBadgeText),
                    ),
                    Gap(6.h),
                    Text(
                      grossFormatted,
                      style: context.textTheme.titleLarge?.copyWith(fontSize: 24.sp, color: AppColors.authButton),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: context.themeCardBackground,
                  border: Border.all(color: context.themeCardBorder),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CompensationCalculatorSidebarConfig.activePlansLabel,
                      style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.grayBorderDark),
                    ),
                    Gap(6.h),
                    Text(activePlansLabel, style: context.textTheme.titleLarge?.copyWith(color: AppColors.textPrimary)),
                  ],
                ),
              ),
              ...typeTotals.entries.indexed.map((entry) {
                final index = entry.$1;
                final typeCode = entry.$2.key;
                final amount = entry.$2.value;
                final color = _typeColorPalette[index % _typeColorPalette.length];
                return CalcLineItem(
                  label: _formatTypeLabel(typeCode),
                  value: '${state.selectedCurrency} ${amount.toStringAsFixed(0)}',
                  dotColor: color,
                );
              }),
            ],
          ),
        ),
        // Gap(24.h),
        // WarningCard(
        //   title: CompensationCalculatorSidebarConfig.requiredFieldsTitle,
        //   bullets: CompensationCalculatorSidebarConfig.requiredFieldBullets,
        // ),
        if (showActions) ...[
          Gap(16.h),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: CompensationCalculatorSidebarConfig.cancelButtonLabel,
                  type: AppButtonType.outline,
                  onPressed: () => context.pop(),
                  svgPath: Assets.icons.closeIcon.path,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: AppButton(
                  label: isMobile ? 'Save' : CompensationCalculatorSidebarConfig.saveButtonLabel,
                  type: AppButtonType.primary,
                  isLoading: state.isCreating,
                  onPressed: state.eligiblePlans.isEmpty
                      ? null
                      : () =>
                            (notifier as AddCompensationPlansNotifier).createEmployeeCompensation(), // standalone only
                  svgPath: Assets.icons.saveDivisionIcon.path,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Converts a type code like "BASIC_SALARY" into "Basic Salary".
String _formatTypeLabel(String typeCode) {
  return typeCode
      .split('_')
      .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
      .join(' ');
}

class CalcLineItem extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;

  const CalcLineItem({super.key, required this.label, required this.value, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(color: AppColors.tableHeaderBackground, borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        children: [
          DigifyStatusDot(color: dotColor, size: 8.w),
          Gap(10.w),
          Expanded(
            child: Text(label, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.grayBorderDark)),
          ),
          Text(
            value,
            style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class WarningCard extends StatelessWidget {
  final String title;
  final List<String> bullets;

  const WarningCard({super.key, required this.title, required this.bullets});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.themeCardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: context.themeCardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(assetPath: Assets.icons.infoCircleBlue.path, width: 18, height: 18, color: AppColors.orange),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.titleSmall?.copyWith(color: AppColors.orangeText)),
                Gap(8.h),
                for (final b in bullets)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Row(
                      children: [
                        DigifyStatusDot(color: AppColors.orange, size: 6.w),
                        Gap(4.w),
                        Text(
                          b,
                          style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.orangeText),
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
}
