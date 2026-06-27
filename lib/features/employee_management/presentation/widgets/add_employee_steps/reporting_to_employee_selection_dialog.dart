import 'dart:async';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/selection_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportingToEmployeeSelectionDialog extends ConsumerStatefulWidget {
  const ReportingToEmployeeSelectionDialog({super.key});

  static Future<EmployeeListItem?> show(BuildContext context) async {
    return showDialog<EmployeeListItem>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ReportingToEmployeeSelectionDialog(),
    );
  }

  @override
  ConsumerState<ReportingToEmployeeSelectionDialog> createState() => _ReportingToEmployeeSelectionDialogState();
}

class _ReportingToEmployeeSelectionDialogState extends ConsumerState<ReportingToEmployeeSelectionDialog> {
  late final TextEditingController _searchController;
  Timer? _debounce;
  List<EmployeeListItem> _employees = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _search());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId == null) {
      setState(() {
        _error = 'Enterprise not selected';
        _employees = [];
        _loading = false;
      });
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    final repository = ref.read(manageEmployeesListRepositoryProvider);
    final query = _searchController.text.trim();
    try {
      final result = await repository.getEmployees(
        enterpriseId: enterpriseId,
        page: 1,
        pageSize: 25,
        search: query.isEmpty ? null : query,
      );
      if (!mounted) return;
      setState(() {
        _employees = result.items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _employees = [];
        _loading = false;
      });
    }
  }

  static const Duration _searchDebounce = Duration(milliseconds: 350);

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_searchDebounce, _search);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Dialog(
      backgroundColor: isDark ? AppColors.cardBackgroundDark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        width: 550.w,
        constraints: BoxConstraints(maxHeight: 500.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      localizations.reportingTo,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: DigifyTextField.search(
                controller: _searchController,
                hintText: localizations.typeToSearchEmployees,
                onChanged: _onSearchChanged,
              ),
            ),
            Gap(12.h),
            Flexible(child: _buildContent(context, localizations, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations localizations, bool isDark) {
    if (_loading) {
      return _buildLoadingSkeleton();
    }
    if (_error != null && _employees.isEmpty) {
      return _buildErrorState();
    }
    if (_employees.isEmpty) {
      return _buildEmptyState(localizations, isDark);
    }
    return _buildEmployeeList(context);
  }

  Widget _buildLoadingSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 14.h,
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                      ),
                      Gap(6.h),
                      Container(
                        width: 120.w,
                        height: 12.h,
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Center(
        child: Text(
          _error!,
          style: TextStyle(fontSize: 14.sp, color: AppColors.error),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Center(
        child: Text(
          localizations.noResultsFound,
          style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildEmployeeList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: _employees.length,
      separatorBuilder: (_, _) => Gap(8.h),
      itemBuilder: (context, index) {
        final employee = _employees[index];
        return SelectionListItem(
          title: employee.fullNameDisplay,
          subtitle: employee.employeeNumberDisplay,
          isSelected: false,
          onTap: () => context.pop(employee),
        );
      },
    );
  }
}
