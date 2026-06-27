import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_radio.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum CalculationMethod { immediateForfeit, gracePeriod, manualProcessing }

class CalculationMethodCard extends StatefulWidget {
  final bool isDark;
  final CalculationMethod? selectedMethod;
  final String? gracePeriodDuration;
  final String? notificationAdvance;
  final ValueChanged<CalculationMethod>? onMethodChanged;
  final ValueChanged<String>? onGracePeriodChanged;
  final ValueChanged<String>? onNotificationAdvanceChanged;

  const CalculationMethodCard({
    super.key,
    required this.isDark,
    this.selectedMethod,
    this.gracePeriodDuration,
    this.notificationAdvance,
    this.onMethodChanged,
    this.onGracePeriodChanged,
    this.onNotificationAdvanceChanged,
  });

  @override
  State<CalculationMethodCard> createState() => _CalculationMethodCardState();
}

class _CalculationMethodCardState extends State<CalculationMethodCard> {
  late CalculationMethod _selectedMethod;
  late TextEditingController _gracePeriodController;
  late TextEditingController _notificationAdvanceController;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedMethod ?? CalculationMethod.gracePeriod;
    _gracePeriodController = TextEditingController(text: widget.gracePeriodDuration ?? '90');
    _notificationAdvanceController = TextEditingController(text: widget.notificationAdvance ?? '30');
  }

  @override
  void didUpdateWidget(CalculationMethodCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMethod != oldWidget.selectedMethod && widget.selectedMethod != null) {
      _selectedMethod = widget.selectedMethod!;
    }
    if (widget.gracePeriodDuration != oldWidget.gracePeriodDuration) {
      _gracePeriodController.text = widget.gracePeriodDuration ?? '90';
    }
    if (widget.notificationAdvance != oldWidget.notificationAdvance) {
      _notificationAdvanceController.text = widget.notificationAdvance ?? '30';
    }
  }

  @override
  void dispose() {
    _gracePeriodController.dispose();
    _notificationAdvanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.leaveManagement.policyConfiguration.path,
                width: 20,
                height: 20,
                color: AppColors.primary,
              ),
              Gap(7.w),
              Text(
                'Calculation Method',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 14.sp,
                  color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Gap(14.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.h,
            children: [
              _CalculationMethodOption(
                method: CalculationMethod.immediateForfeit,
                label: 'Immediate Forfeit',
                description: 'Leave is forfeited immediately when trigger occurs',
                selectedMethod: _selectedMethod,
                isDark: widget.isDark,
                onTap: () {
                  setState(() {
                    _selectedMethod = CalculationMethod.immediateForfeit;
                  });
                  widget.onMethodChanged?.call(_selectedMethod);
                },
              ),
              _CalculationMethodOption(
                method: CalculationMethod.gracePeriod,
                label: 'Grace Period',
                description: 'Employees have grace period to use or encash leave',
                selectedMethod: _selectedMethod,
                isDark: widget.isDark,
                onTap: () {
                  setState(() {
                    _selectedMethod = CalculationMethod.gracePeriod;
                  });
                  widget.onMethodChanged?.call(_selectedMethod);
                },
              ),
              _CalculationMethodOption(
                method: CalculationMethod.manualProcessing,
                label: 'Manual Processing',
                description: 'HR manually processes each forfeit case',
                selectedMethod: _selectedMethod,
                isDark: widget.isDark,
                onTap: () {
                  setState(() {
                    _selectedMethod = CalculationMethod.manualProcessing;
                  });
                  widget.onMethodChanged?.call(_selectedMethod);
                },
              ),
            ],
          ),
          Gap(16.h),
          Row(
            spacing: 12.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    DigifyTextField.number(
                      controller: _gracePeriodController,
                      labelText: 'Grace Period Duration (Days)',
                      hintText: 'Enter days',
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      onChanged: widget.onGracePeriodChanged,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    DigifyTextField.number(
                      controller: _notificationAdvanceController,
                      labelText: 'Notification Advance (Days)',
                      hintText: 'Enter days',
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      onChanged: widget.onNotificationAdvanceChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalculationMethodOption extends StatelessWidget {
  final CalculationMethod method;
  final String label;
  final String description;
  final CalculationMethod selectedMethod;
  final bool isDark;
  final VoidCallback onTap;

  const _CalculationMethodOption({
    required this.method,
    required this.label,
    required this.description,
    required this.selectedMethod,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyRadio<CalculationMethod>(value: method, groupValue: selectedMethod, onChanged: (_) => onTap()),
            Gap(11.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3.h,
                children: [
                  Text(
                    label,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    description,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontSize: 12.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
