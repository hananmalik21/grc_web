import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';

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
    return Wrap(
      spacing: 12.w,
      runSpacing: 10.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          width: 250.w,
          height: 34.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: AppColors.cyberCardBg,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: AppColors.cyberCardBorder),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 15.sp,
                color: AppColors.textPlaceholderDark,
              ),
              const Gap(8),
              Expanded(
                child: TextField(
                  onChanged: onSearchChanged,
                  style: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 11.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search resource, finding type, ID...',
                    hintStyle: TextStyle(
                      color: AppColors.textPlaceholderDark,
                      fontSize: 11.sp,
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
        _buildSeverityPills(),
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
        ),
        _buildDropdown(
          value: selectedService,
          items: const ['All services', 'S3', 'EC2', 'IAM', 'RDS', 'GKE'],
          onChanged: onServiceChanged,
        ),
        _buildDropdown(
          value: selectedStatus,
          items: const ['All statuses', 'Open', 'Remediating', 'Resolved'],
          onChanged: onStatusChanged,
        ),
      ],
    );
  }

  Widget _buildSeverityPills() {
    final pills = [
      {'key': 'ALL', 'label': 'ALL SEV'},
      {'key': 'CRITICAL', 'label': 'CRITICAL (4)'},
      {'key': 'HIGH', 'label': 'HIGH (5)'},
      {'key': 'MEDIUM', 'label': 'MEDIUM (6)'},
      {'key': 'LOW', 'label': 'LOW (5)'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: pills.map((p) {
          final isSelected = selectedSeverity == p['key'];
          return Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: InkWell(
              onTap: () => onSeverityChanged(p['key']!),
              borderRadius: BorderRadius.circular(4.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.dashCyberSecurity.withValues(alpha: 0.15)
                      : AppColors.cyberCardBg,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.dashCyberSecurity
                        : AppColors.cyberCardBorder,
                  ),
                ),
                child: Text(
                  p['label']!,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.dashCyberSecurity
                        : AppColors.textTertiaryDark,
                    fontSize: 10.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 34.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          dropdownColor: AppColors.cyberCardBg,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16.sp,
            color: AppColors.textPlaceholderDark,
          ),
          style: TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 11.sp,
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
