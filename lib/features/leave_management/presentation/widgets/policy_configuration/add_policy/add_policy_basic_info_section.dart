import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/domain/models/api_leave_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPolicyBasicInfoSection extends StatelessWidget {
  const AddPolicyBasicInfoSection({
    super.key,
    required this.policyName,
    required this.selectedLeaveType,
    required this.leaveTypes,
    required this.onPolicyNameChanged,
    required this.onLeaveTypeChanged,
  });

  final String policyName;
  final ApiLeaveType? selectedLeaveType;
  final List<ApiLeaveType> leaveTypes;
  final ValueChanged<String?> onPolicyNameChanged;
  final ValueChanged<ApiLeaveType?> onLeaveTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 14.h,
      children: [
        DigifyTextField(
          labelText: 'Policy name',
          initialValue: policyName,
          isRequired: true,
          hintText: 'Enter policy name',
          onChanged: (v) => onPolicyNameChanged(v.isEmpty ? null : v),
        ),
        DigifySelectFieldWithLabel<ApiLeaveType>(
          label: 'Leave type',
          hint: 'Select leave type',
          items: leaveTypes,
          value: selectedLeaveType,
          itemLabelBuilder: (t) => t.nameEn,
          onChanged: onLeaveTypeChanged,
          isRequired: true,
        ),
      ],
    );
  }
}
