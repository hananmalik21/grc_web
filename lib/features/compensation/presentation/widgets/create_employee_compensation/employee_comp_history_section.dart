import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/employee_comp_history_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/compensation_history/compensation_history_section.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/compensation_history/compensation_history_skeleton.dart';
import 'compensation_section_card.dart';

/// Displays compensation history for the employee selected on the
/// create-employee-compensation-plan page.
class EmployeeCompHistorySection extends ConsumerWidget {
  const EmployeeCompHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(employeeCompHistoryProvider);

    return CompensationSectionCard(
      title: 'Compensation History',
      child: historyAsync.when(
        loading: () => const CompensationHistorySkeleton(),
        error: (_, _) => const _EmptyState(),
        data: (items) {
          if (items.isEmpty) return const _EmptyState();
          return HistoryList(items: items);
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: Text(
          'No compensation history available',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
