import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/create_adjustment_form_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/compensation_components_list_mobile.dart';
import 'package:grc/features/compensation/presentation/widgets/common/compensation_component_type_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompensationComponentsTable extends StatelessWidget {
  final List<ComponentAdjustment> adjustments;
  final bool isDark;

  const CompensationComponentsTable({super.key, required this.adjustments, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (context.isMobileLayout) {
      return CompensationComponentsListMobile(adjustments: adjustments, isDark: isDark);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _buildTableHeader(context, isDark),
          Column(
            children: adjustments.asMap().entries.map((entry) {
              final index = entry.key;
              final adj = entry.value;

              return _buildTableRow(
                context,
                adj.componentName,
                adj.componentType,
                adj.frequencyLabel,
                adj.formattedCurrentAmount,
                adj.formattedAnnualValue,
                isDark,
                isLast: index == adjustments.length - 1,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grayBgDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Component Name', 3),
          _buildHeaderCell('Type', 2),
          _buildHeaderCell('Frequency', 2),
          _buildHeaderCell('Current Amount', 2),
          _buildHeaderCell('Annual Value', 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, int flex, {TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textTertiary),
      ),
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    String name,
    String type,
    String freq,
    String current,
    String annual,
    bool isDark, {
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(children: [CompensationComponentTypeBadge(type: type)]),
          ),
          Expanded(
            flex: 2,
            child: Text(
              freq,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              current,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              annual,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
