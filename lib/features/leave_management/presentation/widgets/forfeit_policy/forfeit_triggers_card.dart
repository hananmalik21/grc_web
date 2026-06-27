import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ForfeitTrigger {
  final String id;
  final String label;
  final String description;
  final bool isSelected;

  const ForfeitTrigger({required this.id, required this.label, required this.description, this.isSelected = false});
}

class ForfeitTriggersCard extends StatefulWidget {
  final bool isDark;
  final List<ForfeitTrigger> triggers;
  final ValueChanged<String>? onTriggerChanged;

  const ForfeitTriggersCard({super.key, required this.isDark, this.triggers = const [], this.onTriggerChanged});

  @override
  State<ForfeitTriggersCard> createState() => _ForfeitTriggersCardState();
}

class _ForfeitTriggersCardState extends State<ForfeitTriggersCard> {
  late List<ForfeitTrigger> _triggers;

  @override
  void initState() {
    super.initState();
    _triggers = widget.triggers.isEmpty ? _getDefaultTriggers() : List.from(widget.triggers);
  }

  List<ForfeitTrigger> _getDefaultTriggers() {
    return const [
      ForfeitTrigger(id: '1', label: 'Year End', description: 'Forfeit excess leave at the end of calendar year'),
      ForfeitTrigger(
        id: '2',
        label: 'Maximum Carry Forward Exceeded',
        description: 'Forfeit days exceeding maximum carry forward limit',
      ),
      ForfeitTrigger(id: '3', label: 'Probation Period End', description: 'Forfeit leave accumulated during probation'),
      ForfeitTrigger(id: '4', label: 'Employee Resignation', description: 'Forfeit or encash leave upon resignation'),
      ForfeitTrigger(id: '5', label: 'Contract End', description: 'Forfeit leave at the end of employment contract'),
    ];
  }

  void _onTriggerToggled(String triggerId) {
    setState(() {
      _triggers = _triggers.map((trigger) {
        if (trigger.id == triggerId) {
          final updated = ForfeitTrigger(
            id: trigger.id,
            label: trigger.label,
            description: trigger.description,
            isSelected: !trigger.isSelected,
          );
          widget.onTriggerChanged?.call(triggerId);
          return updated;
        }
        return trigger;
      }).toList();
    });
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
                assetPath: Assets.icons.leaveManagement.marker.path,
                width: 20,
                height: 20,
                color: AppColors.primary,
              ),
              Gap(7.w),
              Text(
                'Forfeit Triggers',
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
            spacing: 14.h,
            children: [
              Text(
                'Select when automatic forfeit should be triggered',
                style: context.textTheme.bodySmall?.copyWith(
                  color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _triggers.length; i++) ...[
                    _ForfeitTriggerItem(
                      trigger: _triggers[i],
                      isDark: widget.isDark,
                      onChanged: (value) => _onTriggerToggled(_triggers[i].id),
                    ),
                    if (i < _triggers.length - 1) Gap(16.h),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ForfeitTriggerItem extends StatelessWidget {
  final ForfeitTrigger trigger;
  final bool isDark;
  final ValueChanged<bool>? onChanged;

  const _ForfeitTriggerItem({required this.trigger, required this.isDark, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyCheckbox(
            value: trigger.isSelected,
            onChanged: onChanged != null ? (value) => onChanged!(value ?? false) : null,
          ),
          Gap(11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trigger.label,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Gap(3.h),
                Text(
                  trigger.description,
                  style: context.textTheme.labelSmall?.copyWith(
                    fontSize: 12.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
