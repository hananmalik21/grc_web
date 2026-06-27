import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifySwitchFieldWithLabel extends StatelessWidget {
  const DigifySwitchFieldWithLabel({
    required this.label,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 40.h,
          child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Gap(8.h),
        SizedBox(
          height: 40.w,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: DigifySwitch(value: value, onChanged: onChanged, trackOutlineColor: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
