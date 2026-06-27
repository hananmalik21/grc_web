import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/responsive_field_row.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YearsOfServiceSubsection extends ConsumerStatefulWidget {
  final EligibilityCriteria eligibility;
  final bool isDark;
  final bool isEditing;

  const YearsOfServiceSubsection({super.key, required this.eligibility, required this.isDark, required this.isEditing});

  @override
  ConsumerState<YearsOfServiceSubsection> createState() => _YearsOfServiceSubsectionState();
}

class _YearsOfServiceSubsectionState extends ConsumerState<YearsOfServiceSubsection> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  static String _maxDisplay(String? v) => (v == null || v.isEmpty || v == 'No limit') ? '' : v;

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController(text: widget.eligibility.minYearsRequired ?? '');
    _maxController = TextEditingController(text: _maxDisplay(widget.eligibility.maxYearsAllowed));
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draftNotifier = ref.read(policyDraftProvider.notifier);
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          EligibilitySubsectionHeader(
            title: 'Years of Service',
            iconPath: Assets.icons.gradeIcon.path,
            isDark: widget.isDark,
          ),
          ResponsiveFieldRow(
            children: [
              DigifyTextField.number(
                controller: _minController,
                labelText: 'Minimum Years Required',
                hintText: '1',
                readOnly: !widget.isEditing,
                filled: true,
                fillColor: AppColors.cardBackground,
                onChanged: widget.isEditing ? (v) => draftNotifier.updateMinServiceYears(int.tryParse(v)) : null,
              ),
              DigifyTextField.number(
                controller: _maxController,
                labelText: 'Maximum Years (Optional)',
                hintText: '0',
                readOnly: !widget.isEditing,
                filled: true,
                fillColor: AppColors.cardBackground,
                onChanged: widget.isEditing
                    ? (v) => draftNotifier.updateMaxServiceYears(v.isEmpty ? null : int.tryParse(v))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
