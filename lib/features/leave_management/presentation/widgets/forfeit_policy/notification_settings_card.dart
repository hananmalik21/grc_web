import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NotificationSettingsCard extends StatefulWidget {
  final bool isDark;
  final bool notifyEmployees;
  final bool notifyDirectManagers;
  final bool notifyHRDepartment;
  final String? advanceNotificationDays;
  final ValueChanged<bool>? onNotifyEmployeesChanged;
  final ValueChanged<bool>? onNotifyDirectManagersChanged;
  final ValueChanged<bool>? onNotifyHRDepartmentChanged;
  final ValueChanged<String>? onAdvanceNotificationDaysChanged;

  const NotificationSettingsCard({
    super.key,
    required this.isDark,
    this.notifyEmployees = true,
    this.notifyDirectManagers = true,
    this.notifyHRDepartment = true,
    this.advanceNotificationDays,
    this.onNotifyEmployeesChanged,
    this.onNotifyDirectManagersChanged,
    this.onNotifyHRDepartmentChanged,
    this.onAdvanceNotificationDaysChanged,
  });

  @override
  State<NotificationSettingsCard> createState() => _NotificationSettingsCardState();
}

class _NotificationSettingsCardState extends State<NotificationSettingsCard> {
  late bool _notifyEmployees;
  late bool _notifyDirectManagers;
  late bool _notifyHRDepartment;
  late TextEditingController _advanceNotificationDaysController;

  @override
  void initState() {
    super.initState();
    _notifyEmployees = widget.notifyEmployees;
    _notifyDirectManagers = widget.notifyDirectManagers;
    _notifyHRDepartment = widget.notifyHRDepartment;
    _advanceNotificationDaysController = TextEditingController(text: widget.advanceNotificationDays ?? '90, 60, 30, 7');
  }

  @override
  void didUpdateWidget(NotificationSettingsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notifyEmployees != oldWidget.notifyEmployees) {
      _notifyEmployees = widget.notifyEmployees;
    }
    if (widget.notifyDirectManagers != oldWidget.notifyDirectManagers) {
      _notifyDirectManagers = widget.notifyDirectManagers;
    }
    if (widget.notifyHRDepartment != oldWidget.notifyHRDepartment) {
      _notifyHRDepartment = widget.notifyHRDepartment;
    }
    if (widget.advanceNotificationDays != oldWidget.advanceNotificationDays) {
      _advanceNotificationDaysController.text = widget.advanceNotificationDays ?? '90, 60, 30, 7';
    }
  }

  @override
  void dispose() {
    _advanceNotificationDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.notificationsIcon.path,
                width: 20,
                height: 20,
                color: AppColors.primary,
              ),
              Gap(7.w),
              Text(
                'Notification Settings',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 14.sp,
                  color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Gap(14.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.h,
            children: [
              _NotificationToggleItem(
                label: 'Notify Employees',
                isSelected: _notifyEmployees,
                isDark: widget.isDark,
                onChanged: (value) {
                  setState(() {
                    _notifyEmployees = value;
                  });
                  widget.onNotifyEmployeesChanged?.call(_notifyEmployees);
                },
              ),
              _NotificationToggleItem(
                label: 'Notify Direct Managers',
                isSelected: _notifyDirectManagers,
                isDark: widget.isDark,
                onChanged: (value) {
                  setState(() {
                    _notifyDirectManagers = value;
                  });
                  widget.onNotifyDirectManagersChanged?.call(_notifyDirectManagers);
                },
              ),
              _NotificationToggleItem(
                label: 'Notify HR Department',
                isSelected: _notifyHRDepartment,
                isDark: widget.isDark,
                onChanged: (value) {
                  setState(() {
                    _notifyHRDepartment = value;
                  });
                  widget.onNotifyHRDepartmentChanged?.call(_notifyHRDepartment);
                },
              ),
            ],
          ),
          Gap(16.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.h,
            children: [
              DigifyTextField(
                controller: _advanceNotificationDaysController,
                labelText: 'Advance Notification Days',
                hintText: 'Enter days',
                filled: true,
                fillColor: AppColors.cardBackground,
                onChanged: widget.onAdvanceNotificationDaysChanged,
              ),
              Text(
                'Comma-separated days before forfeit to send notifications',
                style: context.textTheme.labelSmall?.copyWith(
                  color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationToggleItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final ValueChanged<bool>? onChanged;

  const _NotificationToggleItem({required this.label, required this.isSelected, required this.isDark, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!isSelected) : null,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DigifyCheckbox(
              value: isSelected,
              onChanged: onChanged != null ? (value) => onChanged!(value ?? false) : null,
            ),
            Gap(11.w),
            Expanded(
              child: Text(
                label,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
