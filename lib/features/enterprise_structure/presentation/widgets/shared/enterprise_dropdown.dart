import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnterpriseDropdown extends StatelessWidget {
  final String label;
  final bool isRequired;
  final int? selectedEnterpriseId;
  final List<Enterprise> enterprises;
  final bool isLoading;
  final bool readOnly;
  final ValueChanged<int?>? onChanged;
  final String? errorText;

  const EnterpriseDropdown({
    super.key,
    required this.label,
    this.isRequired = false,
    this.selectedEnterpriseId,
    required this.enterprises,
    this.isLoading = false,
    this.readOnly = false,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifySelectFieldWithLabel<int>(
          label: label,
          hint: 'Select enterprise',
          value: selectedEnterpriseId,
          items: enterprises.map((e) => e.id).toList(),
          itemLabelBuilder: (id) {
            final enterprise = enterprises.firstWhere((e) => e.id == id);
            return enterprise.name;
          },
          onChanged: readOnly ? null : onChanged,
          isRequired: isRequired,
        ),
        if (errorText != null) ...[
          SizedBox(height: 4.h),
          Text(
            errorText!,
            style: TextStyle(fontSize: 12.sp, color: isDark ? AppColors.errorTextDark : const Color(0xFFFB2C36)),
          ),
        ],
      ],
    );
  }
}
