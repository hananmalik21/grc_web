import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/responsive_field_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DaysAndNoticePeriodSubsection extends ConsumerStatefulWidget {
  final AdvancedRules advanced;
  final bool isDark;
  final bool isEditing;

  const DaysAndNoticePeriodSubsection({
    super.key,
    required this.advanced,
    required this.isDark,
    required this.isEditing,
  });

  @override
  ConsumerState<DaysAndNoticePeriodSubsection> createState() => _DaysAndNoticePeriodSubsectionState();
}

class _DaysAndNoticePeriodSubsectionState extends ConsumerState<DaysAndNoticePeriodSubsection> {
  late TextEditingController _maxConsecutiveController;
  late TextEditingController _minNoticeController;

  static String _display(String? v) => (v == null || v.isEmpty || v == '-') ? '' : v;

  @override
  void initState() {
    super.initState();
    _maxConsecutiveController = TextEditingController(text: _display(widget.advanced.maxConsecutiveDays));
    _minNoticeController = TextEditingController(text: _display(widget.advanced.minNoticePeriod));
  }

  @override
  void didUpdateWidget(DaysAndNoticePeriodSubsection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.advanced != widget.advanced) {
      final maxStr = _display(widget.advanced.maxConsecutiveDays);
      if (int.tryParse(_maxConsecutiveController.text) != int.tryParse(widget.advanced.maxConsecutiveDays)) {
        _maxConsecutiveController.text = maxStr;
      }
      final minStr = _display(widget.advanced.minNoticePeriod);
      if (int.tryParse(_minNoticeController.text) != int.tryParse(widget.advanced.minNoticePeriod)) {
        _minNoticeController.text = minStr;
      }
    }
  }

  @override
  void dispose() {
    _maxConsecutiveController.dispose();
    _minNoticeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isEditing = widget.isEditing;
    final draftNotifier = ref.read(policyDraftProvider.notifier);

    return ResponsiveFieldRow(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.h,
          children: [
            DigifyTextField.number(
              controller: _maxConsecutiveController,
              labelText: 'Maximum Consecutive Days',
              hintText: '0',
              filled: true,
              fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
              readOnly: !isEditing,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: isEditing ? (v) => draftNotifier.updateMaxConsecutiveDays(int.tryParse(v)) : null,
            ),
            Text(
              'Maximum days in a single request',
              style: context.textTheme.labelSmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.h,
          children: [
            DigifyTextField.number(
              controller: _minNoticeController,
              labelText: 'Minimum Notice Period (days)',
              hintText: '0',
              filled: true,
              fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
              readOnly: !isEditing,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: isEditing ? (v) => draftNotifier.updateMinNoticeDays(int.tryParse(v)) : null,
            ),
            Text(
              'Days before leave start date',
              style: context.textTheme.labelSmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
