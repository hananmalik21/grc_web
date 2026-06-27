import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../core/widgets/common/digify_divider.dart';

class ComponentSummarySection extends StatefulWidget {
  const ComponentSummarySection({super.key});

  @override
  State<ComponentSummarySection> createState() =>
      _ComponentSummarySectionState();
}

class _ComponentSummarySectionState extends State<ComponentSummarySection> {
  double _confidence = 85.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocalizationSummaryCard(context),
          Gap(24.h),
          _buildImplementationGuidanceCard(context),
          Gap(24.h),
          _buildConfigurationConfidenceCard(context),
          Gap(24.h),
        ],
      ),
    );
  }

  Widget _buildCardBase(
    BuildContext context, {
    required String title,
    Widget? trailingContent,
    required Widget child,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ?trailingContent,
              ],
            ),
          ),
          DigifyDivider.horizontal(),
          child,
        ],
      ),
    );
  }

  Widget _buildLocalizationSummaryCard(BuildContext context) {
    return _buildCardBase(
      context,
      title: 'Localization Summary',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          children: [
            Row(
              children: [
                Text('🇰🇼', style: TextStyle(fontSize: 24.sp)),
                Gap(16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kuwait',
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'GCC',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(16.h),
            _buildSummaryRow(context, 'Version', 'v2.4', isBold: true),
            DigifyDivider.horizontal(),
            _buildSummaryRow(
              context,
              'Status',
              '',
              widgetValue: DigifyCapsule(
                label: 'Active',
                textColor: AppColors.success,
                backgroundColor: AppColors.success.withValues(alpha: 0.1),
              ),
            ),
            DigifyDivider.horizontal(),
            _buildSummaryRow(context, 'Total Components', '10', isBold: true),
            DigifyDivider.horizontal(),
            _buildSummaryRow(context, 'Mandatory Benefits', '5', isBold: true),
            DigifyDivider.horizontal(),
            _buildSummaryRow(
              context,
              'Gratuity Method',
              'Labor Law',
              isBold: true,
            ),
            DigifyDivider.horizontal(),
            _buildSummaryRow(
              context,
              'Payroll Sync',
              '',
              widgetValue: DigifyCapsule(
                label: 'Connected',
                textColor: AppColors.success,
                backgroundColor: AppColors.success.withValues(alpha: 0.1),
              ),
            ),
            DigifyDivider.horizontal(),
            _buildSummaryRow(
              context,
              'Last Updated By',
              'Sarah Mitchell',
              isBold: true,
            ),
            DigifyDivider.horizontal(),
            _buildSummaryRow(
              context,
              'Last Updated',
              '2 days ago',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    Widget? widgetValue,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (widgetValue != null)
            widgetValue
          else
            Text(
              value,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImplementationGuidanceCard(BuildContext context) {
    return _buildCardBase(
      context,
      title: 'Implementation Guidance',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          children: [
            _buildGuidanceItem(
              context,
              'Use country templates for faster rollout',
            ),
            _buildGuidanceItem(
              context,
              'Validate statutory rules before publishing',
            ),
            _buildGuidanceItem(
              context,
              'Review payroll mapping for taxable and pensionable components',
            ),
            _buildGuidanceItem(
              context,
              'Confirm effective dates before activation',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidanceItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.primary,
            size: 20.sp,
          ),
          Gap(12.w),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationConfidenceCard(BuildContext context) {
    return _buildCardBase(
      context,
      title: 'Configuration Confidence',
      trailingContent: DigifyCapsule(
        label: '${_confidence.toInt()}%',
        textColor: AppColors.primary,
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            // Interactive Slider
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 12.h,
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.cardBackgroundGrey,
                thumbColor: Colors.white,
                overlayColor: AppColors.primary.withValues(alpha: 0.1),
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 8.w,
                  elevation: 2,
                ),
                trackShape: const RoundedRectSliderTrackShape(),
              ),
              child: Slider(
                value: _confidence,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    _confidence = value;
                  });
                },
              ),
            ),
            Gap(4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0%',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '50%',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '100%',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Gap(24.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 20.sp),
                Gap(12.w),
                Expanded(
                  child: Text(
                    'Good progress. Review pending items before publishing.',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            Gap(32.h),
            Row(
              children: [
                _buildConfidenceIndicator(
                  context,
                  Icons.circle_outlined,
                  'High',
                  AppColors.textSecondary,
                ),
                _buildConfidenceIndicator(
                  context,
                  Icons.error_outline,
                  'Medium',
                  AppColors.warningText,
                ),
                _buildConfidenceIndicator(
                  context,
                  Icons.circle_outlined,
                  'Low',
                  AppColors.textSecondary,
                ),
              ],
            ),
            Gap(16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceIndicator(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20.sp),
          Gap(8.h),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
