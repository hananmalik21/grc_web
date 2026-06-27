import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddPolicyBasicInfoSkeleton extends StatelessWidget {
  const AddPolicyBasicInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 14.h,
      children: [
        DigifyTextField(
          labelText: 'Policy name',
          initialValue: '',
          isRequired: true,
          hintText: 'Enter policy name',
          onChanged: null,
          enabled: false,
        ),
        Skeletonizer(
          enabled: true,
          child: DigifySelectFieldWithLabel(
            label: 'Leave type',
            hint: 'Select leave type',
            items: const [],
            itemLabelBuilder: (t) => '',
            onChanged: null,
            isRequired: true,
          ),
        ),
      ],
    );
  }
}
