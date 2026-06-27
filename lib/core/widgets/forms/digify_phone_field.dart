import 'package:country_code_picker/country_code_picker.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/utils/phone_number_utils.dart';
import 'package:grc/core/widgets/forms/digify_country_code_picker_dialog.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifyPhoneField extends StatefulWidget {
  const DigifyPhoneField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.initialDialCode,
    required this.initialNumber,
    required this.onDialCodeChanged,
    required this.onNumberChanged,
    this.isRequired = false,
    this.prefixIcon,
    this.inputFormatters,
  });

  final String labelText;
  final String hintText;
  final bool isRequired;
  final String? initialDialCode;
  final String? initialNumber;
  final ValueChanged<String> onDialCodeChanged;
  final ValueChanged<String?> onNumberChanged;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<DigifyPhoneField> createState() => _DigifyPhoneFieldState();
}

class _DigifyPhoneFieldState extends State<DigifyPhoneField> {
  late final List<CountryCode> _countries;
  late final List<CountryCode> _favoriteCountries;
  CountryCode? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _countries = digifyCountryCodeList();
    _favoriteCountries = digifyFavoriteCountryCodes(countries: _countries);
    _selectedCountry = digifyCountryCodeFromSelection(
      _countries,
      PhoneNumberUtils.initialSelectionForPicker(widget.initialDialCode),
    );
  }

  @override
  void didUpdateWidget(DigifyPhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDialCode != widget.initialDialCode) {
      _selectedCountry = digifyCountryCodeFromSelection(
        _countries,
        PhoneNumberUtils.initialSelectionForPicker(widget.initialDialCode),
      );
    }
  }

  BorderRadius _dialCodeTapBorderRadius(BuildContext context) {
    return BorderRadiusDirectional.horizontal(start: Radius.circular(10.r)).resolve(Directionality.of(context));
  }

  Future<void> _openCountryPicker() async {
    final selected = await DigifyCountryCodePickerDialog.show(
      context,
      countries: _countries,
      favoriteCountries: _favoriteCountries,
      selected: _selectedCountry,
    );

    if (selected == null || !mounted) return;

    setState(() => _selectedCountry = selected);
    widget.onDialCodeChanged(selected.dialCode ?? PhoneNumberUtils.defaultDialCode);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark ? AppColors.inputBorderDark : AppColors.inputBorder;
    final textColor = isDark ? context.themeTextPrimary : AppColors.textPrimary;
    final dialCode = _selectedCountry?.dialCode ?? PhoneNumberUtils.defaultDialCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.labelText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.deleteIconRed,
                    fontFamily: 'Inter',
                  ),
                ),
            ],
          ),
        ),
        Gap(8.h),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: borderColor, width: 1.w),
            color: isDark ? AppColors.inputBgDark : Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _openCountryPicker,
                  borderRadius: _dialCodeTapBorderRadius(context),
                  child: Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dialCode,
                          style: TextStyle(fontSize: 15.sp, color: textColor, fontWeight: FontWeight.w600),
                        ),
                        Gap(2.w),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18.sp,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(4.w),
              Container(width: 1.w, height: 28.h, color: borderColor),
              Expanded(
                child: DigifyTextField(
                  hintText: widget.hintText,
                  keyboardType: TextInputType.phone,
                  prefixIcon: widget.prefixIcon,
                  initialValue: widget.initialNumber,
                  onChanged: widget.onNumberChanged,
                  inputFormatters: widget.inputFormatters ?? FieldFormat.phoneFormatters,
                  filled: true,
                  fillColor: Colors.transparent,
                  showBorder: false,
                  borderColor: Colors.transparent,
                  focusedBorderColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
