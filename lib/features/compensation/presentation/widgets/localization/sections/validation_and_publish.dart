import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/common/digify_capsule.dart';

enum ValidationStatus { error, warning, success }

class ValidationItem {
  final String title;
  final String subtitle;
  final ValidationStatus status;
  final List<String> details;
  final IconData icon;

  const ValidationItem({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.details,
    required this.icon,
  });
}

class ValidationAndPublish extends ConsumerStatefulWidget {
  const ValidationAndPublish({super.key});

  @override
  ConsumerState<ValidationAndPublish> createState() =>
      _ValidationAndPublishState();
}

class _ValidationAndPublishState extends ConsumerState<ValidationAndPublish> {
  final List<ValidationItem> _items = [
    const ValidationItem(
      title: 'Salary Structure',
      subtitle: 'Missing mandatory components',
      status: ValidationStatus.error,
      icon: Icons.info_outline,
      details: [
        'Basic Salary mapping required',
        'Housing allowance formula not defined',
      ],
    ),
    const ValidationItem(
      title: 'Statutory Compliance',
      subtitle: 'Review required',
      status: ValidationStatus.warning,
      icon: Icons.info_outline,
      details: [
        'PIFSS ceiling needs review',
        'Medical insurance configuration pending',
        'Leave encashment policy not set',
      ],
    ),
    const ValidationItem(
      title: 'Severance Rules',
      subtitle: 'Configuration complete',
      status: ValidationStatus.success,
      icon: Icons.check_circle_outline,
      details: ['All end of service rules properly configured'],
    ),
    const ValidationItem(
      title: 'Payroll Integration',
      subtitle: 'Mapping verified',
      status: ValidationStatus.success,
      icon: Icons.check_circle_outline,
      details: ['All components mapped to payroll system'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAlert(context),
          Gap(24.h),
          _buildValidationGrid(context),
          Gap(24.h),
          _buildPublishCard(context),
          Gap(24.h),
        ],
      ),
    );
  }

  Widget _buildAlert(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.warningBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              color: AppColors.warningText,
              size: 24.sp,
            ),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configuration Validation Required',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.warningText,
                  ),
                ),
                Text(
                  '2 errors, 3 warnings found. Please resolve before publishing.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.warningText.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Country Readiness',
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.warningText,
                ),
              ),
              Gap(8.h),
              Row(
                children: [
                  SizedBox(
                    width: 150.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: 0.75,
                        minHeight: 8.h,
                        backgroundColor: AppColors.cardBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.warningText,
                        ),
                      ),
                    ),
                  ),
                  Gap(12.w),
                  Text(
                    '75%',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.warningText,
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

  Widget _buildValidationGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 24.w,
          runSpacing: 24.h,
          children: _items.map((item) {
            return SizedBox(
              width: (constraints.maxWidth - 24.w) / 2,
              child: _buildValidationCard(context, item),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildValidationCard(BuildContext context, ValidationItem item) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: _getStatusColor(item.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  item.icon,
                  color: _getStatusColor(item.status),
                  size: 24.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      item.subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(item),
            ],
          ),
          Gap(16.h),
          ...item.details.map(
            (detail) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16.sp,
                    ),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      detail,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ValidationItem item) {
    switch (item.status) {
      case ValidationStatus.error:
        return DigifyCapsule(
          label: '2 Errors',
          backgroundColor: AppColors.errorBg,
          textColor: AppColors.error,
          borderColor: Colors.transparent,
        );
      case ValidationStatus.warning:
        return DigifyCapsule(
          label: '3 Warnings',
          backgroundColor: AppColors.warningBg,
          textColor: AppColors.warningText,
          borderColor: Colors.transparent,
        );
      case ValidationStatus.success:
        return DigifyCapsule(
          label: 'Complete',
          backgroundColor: AppColors.successBg,
          textColor: AppColors.success,
          borderColor: Colors.transparent,
        );
    }
  }

  Color _getStatusColor(ValidationStatus status) {
    switch (status) {
      case ValidationStatus.error:
        return AppColors.error;
      case ValidationStatus.warning:
        return AppColors.warningText;
      case ValidationStatus.success:
        return AppColors.success;
    }
  }

  Widget _buildPublishCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Text(
              'Publish Configuration',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (context.isMobile) ...[
                  DigifyTextField(
                    labelText: 'REVIEWER NAME',
                    hintText: 'Enter reviewer name',
                  ),
                  Gap(24.h),
                  DigifyTextField(
                    labelText: 'APPROVAL STATUS',
                    hintText: 'Pending Review',
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: DigifyTextField(
                          labelText: 'REVIEWER NAME',
                          hintText: 'Enter reviewer name',
                        ),
                      ),
                      Gap(24.w),
                      Expanded(
                        child: DigifyTextField(
                          labelText: 'APPROVAL STATUS',
                          hintText: 'Pending Review',
                        ),
                      ),
                    ],
                  ),
                ],
                Gap(24.h),
                DigifyTextArea(
                  labelText: 'PUBLISH NOTES',
                  hintText: 'Add notes about this configuration update...',
                ),
                DigifyDivider.horizontal(height: 48.h),
                _buildFooterActions(context),
                Gap(16.h),
                _buildNoteBanner(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActions(BuildContext context) {
    return Row(
      children: [
        AppButton.outline(label: 'Rollback Configuration', onPressed: () {}),
        const Spacer(),
        AppButton.outline(label: 'Save Draft', onPressed: () {}),
        Gap(12.w),
        AppButton(
          label: 'Publish Configuration',
          icon: Icons.send,
          type: AppButtonType.primary,
          backgroundColor: AppColors.primary.withValues(
            alpha: 0.5,
          ), // Disabled look
          onPressed: null, // Disabled
        ),
      ],
    );
  }

  Widget _buildNoteBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Note: ',
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.infoText,
              ),
            ),
            TextSpan(
              text:
                  'Publish button will be enabled once all validation errors are resolved.',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.infoText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
