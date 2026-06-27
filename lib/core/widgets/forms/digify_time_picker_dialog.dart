import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart' show AppButton, AppButtonType;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class DigifyTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final bool isDark;

  const DigifyTimePickerDialog({super.key, required this.initialTime, required this.isDark});

  static Future<TimeOfDay?> show(BuildContext context, {required TimeOfDay initialTime}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: true,
      builder: (context) => DigifyTimePickerDialog(initialTime: initialTime, isDark: isDark),
    );
  }

  @override
  State<DigifyTimePickerDialog> createState() => _DigifyTimePickerDialogState();
}

class _DigifyTimePickerDialogState extends State<DigifyTimePickerDialog> {
  late int _selectedHour;
  late int _selectedMinute;
  late bool _isAM;

  final TextEditingController _hourTextController = TextEditingController();
  final TextEditingController _minuteTextController = TextEditingController();

  bool _isEditingHour = false;
  bool _isEditingMinute = false;

  final double _boxHeight = 140.h;

  @override
  void initState() {
    super.initState();
    final hour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;
    _isAM = hour < 12;
    _selectedHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  }

  @override
  void dispose() {
    _hourTextController.dispose();
    _minuteTextController.dispose();
    super.dispose();
  }

  void _updateHour(int hour) {
    if (hour < 1) hour = 12;
    if (hour > 12) hour = 1;
    setState(() {
      _selectedHour = hour;
    });
  }

  void _updateMinute(int minute) {
    if (minute < 0) minute = 59;
    if (minute > 59) minute = 0;
    setState(() {
      _selectedMinute = minute;
    });
  }

  void _toggleAMPM(bool isAM) {
    if (_isAM != isAM) {
      setState(() {
        _isAM = isAM;
      });
    }
  }

  TimeOfDay _getSelectedTime() {
    int hour = _selectedHour;
    if (!_isAM && hour != 12) {
      hour += 12;
    } else if (_isAM && hour == 12) {
      hour = 0;
    }
    return TimeOfDay(hour: hour, minute: _selectedMinute);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDark ? AppColors.cardBackgroundDark : Colors.white;
    final textColor = widget.isDark ? context.themeTextPrimary : AppColors.textPrimary;
    final mutedTextColor = widget.isDark ? context.themeTextMuted : AppColors.textSecondary;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 380.w,
          constraints: BoxConstraints(maxWidth: 400.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: widget.isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: widget.isDark ? 0.4 : 0.1),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set Time',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Tap the number to type',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 13.sp, color: mutedTextColor),
                        ),
                      ],
                    ),
                    _buildTimeDisplay(),
                  ],
                ),
              ),

              Divider(height: 1, color: widget.isDark ? Colors.white10 : Colors.black12),

              // Body
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildPickerColumn(
                      label: 'Hour',
                      value: _selectedHour,
                      min: 1,
                      max: 12,
                      isEditing: _isEditingHour,
                      controller: _hourTextController,
                      onToggleEdit: (edit) {
                        setState(() {
                          _isEditingHour = edit;
                          if (edit) {
                            _hourTextController.text = _selectedHour.toString();
                          }
                        });
                      },
                      onChanged: _updateHour,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 22.h),
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w200,
                          color: textColor.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    _buildPickerColumn(
                      label: 'Minute',
                      value: _selectedMinute,
                      min: 0,
                      max: 59,
                      isEditing: _isEditingMinute,
                      controller: _minuteTextController,
                      onToggleEdit: (edit) {
                        setState(() {
                          _isEditingMinute = edit;
                          if (edit) {
                            _minuteTextController.text = _selectedMinute.toString().padLeft(2, '0');
                          }
                        });
                      },
                      onChanged: _updateMinute,
                    ),
                    SizedBox(width: 32.w),
                    _buildPeriodSelector(),
                  ],
                ),
              ),

              // Footer
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Cancel',
                        type: AppButtonType.outline,
                        onPressed: () => Navigator.pop(context),
                        height: 44.h,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppButton(
                        label: 'Update Time',
                        onPressed: () => Navigator.pop(context, _getSelectedTime()),
                        backgroundColor: AppColors.primary,
                        height: 44.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} ${_isAM ? 'AM' : 'PM'}',
        style: TextStyle(fontFamily: 'Inter', fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
      ),
    );
  }

  Widget _buildPickerColumn({
    required String label,
    required int value,
    required int min,
    required int max,
    required bool isEditing,
    required TextEditingController controller,
    required Function(bool) onToggleEdit,
    required ValueChanged<int> onChanged,
  }) {
    final textColor = widget.isDark ? context.themeTextPrimary : AppColors.textPrimary;

    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: textColor.withValues(alpha: 0.4),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: 80.w,
          height: _boxHeight,
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.inputBgDark : AppColors.inputBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: widget.isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              _buildArrowButton(icon: Icons.keyboard_arrow_up_rounded, onTap: () => onChanged(value + 1), top: true),
              Expanded(
                child: Center(
                  child: isEditing
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: TextField(
                            controller: controller,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                              letterSpacing: -1,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (val) {
                              final int? newVal = int.tryParse(val);
                              if (newVal != null && newVal >= min && newVal <= max) {
                                onChanged(newVal);
                              }
                              onToggleEdit(false);
                            },
                            onTapOutside: (_) => onToggleEdit(false),
                          ),
                        )
                      : InkWell(
                          onTap: () => onToggleEdit(true),
                          child: Text(
                            value.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                ),
              ),
              _buildArrowButton(icon: Icons.keyboard_arrow_down_rounded, onTap: () => onChanged(value - 1), top: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArrowButton({required IconData icon, required VoidCallback onTap, required bool top}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: top ? Radius.circular(16.r) : Radius.zero,
          bottom: !top ? Radius.circular(16.r) : Radius.zero,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Icon(
            icon,
            size: 20.sp,
            color: (widget.isDark ? context.themeTextPrimary : AppColors.textPrimary).withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'PERIOD',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: (widget.isDark ? context.themeTextPrimary : AppColors.textPrimary).withValues(alpha: 0.4),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: 55.w,
          height: 100.h,
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.inputBgDark : AppColors.inputBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: widget.isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              Expanded(child: _buildPeriodOption('AM', _isAM, () => _toggleAMPM(true))),
              SizedBox(height: 4.h),
              Expanded(child: _buildPeriodOption('PM', !_isAM, () => _toggleAMPM(false))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodOption(String label, bool isSelected, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.white : (widget.isDark ? context.themeTextMuted : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
