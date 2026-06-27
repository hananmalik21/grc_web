import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/employee_management/presentation/widgets/grid/employee_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeesGridView extends StatelessWidget {
  final List<EmployeeListItem> employees;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isLoading;
  final Function(EmployeeListItem) onView;
  final VoidCallback? onMore;

  const EmployeesGridView({
    super.key,
    required this.employees,
    required this.localizations,
    required this.isDark,
    this.isLoading = false,
    required this.onView,
    this.onMore,
  });

  static double get _minCardWidth => 280;

  static int _crossAxisCount(double width) {
    final count = (width / _minCardWidth).floor();
    return count.clamp(1, 4);
  }

  static const double _cardHeight = 386;

  static final List<EmployeeListItem> _placeholders = List.generate(6, (_) => EmployeeListItem.empty());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _crossAxisCount(constraints.maxWidth);
        final cellWidth = (constraints.maxWidth - (crossAxisCount - 1) * 16.w) / crossAxisCount;
        final childAspectRatio = cellWidth / _cardHeight.h;

        if (!isLoading && employees.isEmpty) {
          return _buildEmptyState(context);
        }

        final items = isLoading ? _placeholders : employees;

        return Skeletonizer(
          enabled: isLoading,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return EmployeeGridCard(
                employee: items[index],
                localizations: localizations,
                isDark: isDark,
                onView: () => onView(items[index]),
                onMore: onMore,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      alignment: Alignment.center,
      child: Text(
        localizations.noResultsFound,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF717182),
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
