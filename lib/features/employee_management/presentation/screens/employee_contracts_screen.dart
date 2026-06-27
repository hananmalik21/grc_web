import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Dummy screen for Employee Contracts module.
/// Route: /employees/contracts — Digital contract management.
class EmployeeContractsScreen extends StatelessWidget {
  const EmployeeContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employee Contracts',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: context.themeTextPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            'Digital contract management',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: context.themeTextSecondary),
          ),
          SizedBox(height: 24.h),
          Expanded(child: _buildPlaceholderContent(context)),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.themeCardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.themeCardBorder),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64.sp,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'Coming Soon',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: context.themeTextSecondary),
            ),
            SizedBox(height: 8.h),
            Text(
              'Employee contract management will be available here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.themeTextTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
