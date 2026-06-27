import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EncashmentOptionCard extends StatefulWidget {
  final bool isDark;
  final bool allowEncashment;
  final String? maxEncashmentDays;
  final String? encashmentRate;
  final ValueChanged<bool>? onAllowEncashmentChanged;
  final ValueChanged<String>? onMaxEncashmentDaysChanged;
  final ValueChanged<String>? onEncashmentRateChanged;

  const EncashmentOptionCard({
    super.key,
    required this.isDark,
    this.allowEncashment = false,
    this.maxEncashmentDays,
    this.encashmentRate,
    this.onAllowEncashmentChanged,
    this.onMaxEncashmentDaysChanged,
    this.onEncashmentRateChanged,
  });

  @override
  State<EncashmentOptionCard> createState() => _EncashmentOptionCardState();
}

class _EncashmentOptionCardState extends State<EncashmentOptionCard> {
  late bool _allowEncashment;
  late TextEditingController _maxEncashmentDaysController;
  late TextEditingController _encashmentRateController;

  @override
  void initState() {
    super.initState();
    _allowEncashment = widget.allowEncashment;
    _maxEncashmentDaysController = TextEditingController(text: widget.maxEncashmentDays ?? '15');
    _encashmentRateController = TextEditingController(text: widget.encashmentRate ?? '100');
  }

  @override
  void didUpdateWidget(EncashmentOptionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.allowEncashment != oldWidget.allowEncashment) {
      _allowEncashment = widget.allowEncashment;
    }
    if (widget.maxEncashmentDays != oldWidget.maxEncashmentDays) {
      _maxEncashmentDaysController.text = widget.maxEncashmentDays ?? '15';
    }
    if (widget.encashmentRate != oldWidget.encashmentRate) {
      _encashmentRateController.text = widget.encashmentRate ?? '100';
    }
  }

  @override
  void dispose() {
    _maxEncashmentDaysController.dispose();
    _encashmentRateController.dispose();
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
                assetPath: Assets.icons.leaveManagement.dollar.path,
                width: 20,
                height: 20,
                color: AppColors.primary,
              ),
              Gap(7.w),
              Text(
                'Encashment Option Before Forfeit',
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
            spacing: 16.h,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: widget.isDark ? AppColors.orangeBg.withValues(alpha: 0.2) : AppColors.orangeBg,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: widget.isDark ? AppColors.orangeBorder.withValues(alpha: 0.5) : AppColors.orangeBorder,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DigifyCheckbox(
                      value: _allowEncashment,
                      onChanged: (value) {
                        setState(() {
                          _allowEncashment = value ?? false;
                        });
                        widget.onAllowEncashmentChanged?.call(_allowEncashment);
                      },
                    ),
                    Gap(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4.h,
                        children: [
                          Text(
                            'Allow Encashment Before Forfeit',
                            style: context.textTheme.titleSmall?.copyWith(
                              color: widget.isDark ? AppColors.orangeText : AppColors.orangeText,
                            ),
                          ),
                          Text(
                            'Employees can encash excess leave instead of forfeiting it',
                            style: context.textTheme.labelSmall?.copyWith(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                          controller: _maxEncashmentDaysController,
                          labelText: 'Maximum Encashment Days',
                          hintText: 'Enter days',
                          filled: true,
                          fillColor: AppColors.cardBackground,
                          onChanged: widget.onMaxEncashmentDaysChanged,
                        ),
                        Text(
                          'Max days per year',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
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
                          controller: _encashmentRateController,
                          labelText: 'Encashment Rate (%)',
                          hintText: 'Enter rate',
                          filled: true,
                          fillColor: AppColors.cardBackground,
                          onChanged: widget.onEncashmentRateChanged,
                        ),
                        Text(
                          '% of daily wage',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
