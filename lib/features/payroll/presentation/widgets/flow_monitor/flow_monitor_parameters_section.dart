import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/domain/models/flow_monitor_parameters.dart';
import 'package:grc/features/payroll/presentation/screens/flow_monitor/flow_monitor_tab_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import 'package:gap/gap.dart';

class FlowMonitorParametersSection extends StatelessWidget {
  const FlowMonitorParametersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final parameters = FlowMonitorTabConfig.buildMockParameters(loc);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder.withValues(alpha: 0.1)),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FlowMonitorParametersHeader(loc: loc),
          Gap(20.h),
          _FlowMonitorParametersGrid(fields: parameters.fields),
        ],
      ),
    );
  }
}

class _FlowMonitorParametersHeader extends StatelessWidget {
  const _FlowMonitorParametersHeader({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.payrollSubmitPayrollFlowStepParameters,
          style: context.textTheme.titleMedium?.copyWith(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(4.h),
        Text(
          loc.payrollFlowMonitorFlowParameters,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _FlowMonitorParametersGrid extends StatelessWidget {
  const _FlowMonitorParametersGrid({required this.fields});

  final List<FlowMonitorParameterField> fields;

  @override
  Widget build(BuildContext context) {
    final columnCount = switch (ResponsiveHelper.getDeviceType(context)) {
      DeviceType.mobile => 1,
      DeviceType.tablet => 2,
      DeviceType.web => 4,
    };
    final rowCount = (fields.length / columnCount).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var row = 0; row < rowCount; row++) ...[
          if (row > 0) Gap(24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var column = 0; column < columnCount; column++) ...[
                if (column > 0) Gap(16.w),
                Expanded(
                  child: _buildFieldAt(row: row, column: column, columnCount: columnCount),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFieldAt({required int row, required int column, required int columnCount}) {
    final index = row * columnCount + column;
    if (index >= fields.length) {
      return const SizedBox.shrink();
    }

    return _FlowMonitorParameterField(data: fields[index]);
  }
}

class _FlowMonitorParameterField extends StatelessWidget {
  const _FlowMonitorParameterField({required this.data});

  final FlowMonitorParameterField data;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelColor = isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder;
    final valueColor = data.isEmpty
        ? (isDark ? AppColors.textMutedDark : AppColors.textMuted)
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.label.toUpperCase(),
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.48,
            color: labelColor,
          ),
        ),
        Gap(4.h),
        Text(
          data.value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
