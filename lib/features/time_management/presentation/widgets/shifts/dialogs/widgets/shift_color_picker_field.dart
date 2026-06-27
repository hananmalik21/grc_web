import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftColorPickerField extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final bool isDark;

  const ShiftColorPickerField({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    required this.isDark,
  });

  Future<void> _showColorPicker(BuildContext context) async {
    final Color? pickedColor = await showDialog<Color>(
      context: context,
      builder: (context) => _ColorPickerDialog(initialColor: selectedColor, isDark: isDark),
    );

    if (pickedColor != null) {
      onColorChanged(pickedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8.sp,
            fontWeight: FontWeight.w500,
            height: 20 / 13.8,
            color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () => _showColorPicker(context),
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            height: 40.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: selectedColor,
                border: Border.all(color: AppColors.colorBorder, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final bool isDark;

  const _ColorPickerDialog({required this.initialColor, required this.isDark});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Select Color',
      width: 360.w,
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Theme(
                data: ThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
                    isDense: true,
                  ),
                ),
                child: ColorPicker(
                  pickerColor: _selectedColor,
                  onColorChanged: (color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  colorPickerWidth: 300.w,
                  pickerAreaHeightPercent: 0.4,
                  enableAlpha: false,
                  labelTypes: const [],
                  displayThumbColor: true,
                  paletteType: PaletteType.hsv,
                  pickerAreaBorderRadius: BorderRadius.circular(10.r),
                  hexInputBar: true,
                  portraitOnly: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
          type: AppButtonType.outline,
          width: null,
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        SizedBox(width: 12.w),
        AppButton(
          label: 'Select',
          onPressed: () => Navigator.of(context).pop(_selectedColor),
          type: AppButtonType.primary,
          width: null,
          height: 36.h,
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
        ),
      ],
    );
  }
}
