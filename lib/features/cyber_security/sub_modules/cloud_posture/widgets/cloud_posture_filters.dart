import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class CloudPostureFilters extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String selectedSeverity;
  final ValueChanged<String> onSeverityChanged;
  final String selectedAccount;
  final ValueChanged<String> onAccountChanged;
  final String selectedService;
  final ValueChanged<String> onServiceChanged;
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;

  const CloudPostureFilters({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedSeverity,
    required this.onSeverityChanged,
    required this.selectedAccount,
    required this.onAccountChanged,
    required this.selectedService,
    required this.onServiceChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    
    return Wrap(
      spacing: 12.w,
      runSpacing: 10.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          width: 250.w,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isDark ? const Color(0xFF333333) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search_rounded,
                size: 16.sp,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
              const Gap(8),
              Expanded(
                child: TextField(
                  onChanged: onSearchChanged,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 12.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search resource, finding type, ID...',
                    hintStyle: TextStyle(
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      fontSize: 12.sp,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildDropdown(
          value: selectedSeverity,
          items: const ['ALL', 'CRITICAL', 'HIGH', 'MEDIUM', 'LOW'],
          onChanged: onSeverityChanged,
          isDark: isDark,
        ),
        _buildDropdown(
          value: selectedAccount,
          items: const [
            'All accounts',
            'AWS Production',
            'GCP Production',
            'Azure Production',
            'AWS Development',
          ],
          onChanged: onAccountChanged,
          isDark: isDark,
        ),
        _buildDropdown(
          value: selectedService,
          items: const ['All services', 'S3', 'EC2', 'IAM', 'RDS', 'GKE'],
          onChanged: onServiceChanged,
          isDark: isDark,
        ),
        _buildDropdown(
          value: selectedStatus,
          items: const ['All statuses', 'Open', 'Remediating', 'Resolved'],
          onChanged: onStatusChanged,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? const Color(0xFF333333) : const Color(0xFFE2E8F0),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isDense: true,
          dropdownColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16.sp,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          style: TextStyle(
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
        ),
      ),
    );
  }
}
