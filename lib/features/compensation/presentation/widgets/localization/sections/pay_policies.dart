import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../../core/widgets/common/digify_divider.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';

class PayPolicies extends ConsumerStatefulWidget {
  const PayPolicies({super.key});

  @override
  ConsumerState<PayPolicies> createState() => _PayPoliciesState();
}

class _PayPoliciesState extends ConsumerState<PayPolicies> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (context.isMobile) ...[
          _buildPolicyCard(
            title: 'GCC Policies',
            children: [
              _buildPolicyItem(
                label: '13th Month Salary',
                status: 'Enabled',
                statusColor: AppColors.success,
              ),
              _buildPolicyItem(
                label: 'Annual Air Ticket Allowance',
                status: 'Enabled',
                statusColor: AppColors.success,
              ),
              _buildPolicyItem(
                label: 'Hardship Allowance',
                status: 'Disabled',
                statusColor: AppColors.textMuted,
              ),
              _buildPolicyItem(
                label: 'Overtime Eligibility',
                trailingText: 'Grade 1-5',
              ),
            ],
          ),
          Gap(24.h),
          _buildPolicyCard(
            title: 'Europe Policies',
            children: [
              _buildPolicyItem(
                label: 'Performance Bonus',
                status: 'Enabled',
                statusColor: AppColors.success,
              ),
              _buildPolicyItem(
                label: 'Retention Bonus',
                status: 'Enabled',
                statusColor: AppColors.success,
              ),
              _buildPolicyItem(
                label: 'Shift Differential',
                status: 'Enabled',
                statusColor: AppColors.success,
              ),
              _buildPolicyItem(
                label: 'Part-Time Rules',
                trailingText: 'Prorated',
              ),
            ],
          ),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildPolicyCard(
                  title: 'GCC Policies',
                  children: [
                    _buildPolicyItem(
                      label: '13th Month Salary',
                      status: 'Enabled',
                      statusColor: AppColors.success,
                    ),
                    _buildPolicyItem(
                      label: 'Annual Air Ticket Allowance',
                      status: 'Enabled',
                      statusColor: AppColors.success,
                    ),
                    _buildPolicyItem(
                      label: 'Hardship Allowance',
                      status: 'Disabled',
                      statusColor: AppColors.textMuted,
                    ),
                    _buildPolicyItem(
                      label: 'Overtime Eligibility',
                      trailingText: 'Grade 1-5',
                    ),
                  ],
                ),
              ),
              Gap(24.w),
              Expanded(
                child: _buildPolicyCard(
                  title: 'Europe Policies',
                  children: [
                    _buildPolicyItem(
                      label: 'Performance Bonus',
                      status: 'Enabled',
                      statusColor: AppColors.success,
                    ),
                    _buildPolicyItem(
                      label: 'Retention Bonus',
                      status: 'Enabled',
                      statusColor: AppColors.success,
                    ),
                    _buildPolicyItem(
                      label: 'Shift Differential',
                      status: 'Enabled',
                      statusColor: AppColors.success,
                    ),
                    _buildPolicyItem(
                      label: 'Part-Time Rules',
                      trailingText: 'Prorated',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        Gap(24.h),
        _buildReviewPoliciesCard(),
      ],
    );
  }

  Widget _buildPolicyCard({
    required String title,
    required List<Widget> children,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Text(
              title,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem({
    required String label,
    String? status,
    Color? statusColor,
    String? trailingText,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.isDark
                ? AppColors.cardBorderDark
                : AppColors.cardBorder.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (status != null)
            DigifyCapsule(
              label: status,
              textColor: statusColor ?? AppColors.textPrimary,
              backgroundColor: (statusColor ?? AppColors.textPrimary)
                  .withValues(alpha: 0.1),
            )
          else if (trailingText != null)
            Text(
              trailingText,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewPoliciesCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Text(
              'Compensation Review Policies',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    labelText: 'ANNUAL REVIEW CYCLE',
                    hintText: 'January (Annual)',
                    initialValue: 'January (Annual)',
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    labelText: 'MERIT INCREASE RANGE',
                    hintText: '3% - 8%',
                    initialValue: '3% - 8%',
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    labelText: 'PROMOTION INCREASE GUIDELINE',
                    hintText: '8% - 15%',
                    initialValue: '8% - 15%',
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
