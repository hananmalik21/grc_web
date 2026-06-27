import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/employee_management/presentation/screens/mixins/manage_employees_permission_mixin.dart';
import 'package:grc/features/employee_management/presentation/screens/manage_employees/manage_employees_screen_state.dart';
import 'package:grc/features/employee_management/presentation/widgets/common/employees_mobile_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ManageEmployeesMobileContentArea extends StatelessWidget with ManageEmployeesPermissionMixin {
  const ManageEmployeesMobileContentArea({super.key, required this.s, required this.ref});

  final ManageEmployeesScreenState s;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    if (s.listState.error != null) {
      return _MobileErrorState(
        message: s.localizations.somethingWentWrong,
        retryLabel: s.localizations.retry,
        isDark: s.isDark,
        onRetry: () => ref.read(manageEmployeesListProvider.notifier).refresh(),
      );
    }

    if (s.listState.items.isEmpty && !s.listState.isLoading) {
      return _MobileNoResultsState(isDark: s.isDark, localizations: s.localizations);
    }

    return Column(
      children: [
        EmployeesMobileListView(
          employees: s.listState.items,
          localizations: s.localizations,
          isDark: s.isDark,
          isLoading: s.listState.isLoading,
          onView: canViewEmployee ? (employee) => context.push(AppRoutes.employeeDetail, extra: employee) : (_) {},
        ),
        if (s.listState.pagination != null) ...[
          Gap(16.w),
          MobilePaginationControls(
            isDark: s.isDark,
            currentPage: s.listState.currentPage,
            totalPages: s.listState.pagination!.totalPages,
            hasPrevious: s.listState.pagination!.hasPrevious,
            hasNext: s.listState.pagination!.hasNext,
            onPrevious: s.listState.pagination!.hasPrevious
                ? () => ref.read(manageEmployeesListProvider.notifier).goToPage(s.listState.currentPage - 1)
                : null,
            onNext: s.listState.pagination!.hasNext
                ? () => ref.read(manageEmployeesListProvider.notifier).goToPage(s.listState.currentPage + 1)
                : null,
          ),
        ],
      ],
    );
  }
}

class _MobileNoResultsState extends StatelessWidget {
  const _MobileNoResultsState({required this.isDark, required this.localizations});

  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return MobileStateCard(
      isDark: isDark,
      borderColor: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
      iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : const Color(0xFFF1F5F9),
      icon: Icon(
        Icons.person_search_rounded,
        size: 32.sp,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
      title: localizations.noResultsFound,
      subtitle: localizations.tryAdjustingFilters,
    );
  }
}

class _MobileErrorState extends StatelessWidget {
  const _MobileErrorState({
    required this.isDark,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final bool isDark;
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MobileStateCard(
      isDark: isDark,
      borderColor: isDark ? AppColors.cardBorderDark : AppColors.errorBorder,
      iconBackground: AppColors.errorBg,
      icon: Icon(Icons.wifi_off_rounded, size: 32.sp, color: AppColors.brandRed),
      title: message,
      subtitle: 'Check your connection and try again.',
      action: GestureDetector(
        onTap: onRetry,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
          decoration: BoxDecoration(color: AppColors.brandRed, borderRadius: BorderRadius.circular(10.r)),
          child: Text(
            retryLabel,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
