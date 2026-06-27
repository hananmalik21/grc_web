import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompactInputField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const CompactInputField({super.key, required this.value, required this.onChanged});

  @override
  State<CompactInputField> createState() => _CompactInputFieldState();
}

class _CompactInputFieldState extends State<CompactInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant CompactInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.borderGrey;

    return SizedBox(
      width: 108.w,
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        onChanged: widget.onChanged,
        style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
          filled: true,
          fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11.r),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11.r),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11.r),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
