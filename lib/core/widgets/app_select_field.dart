import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/services/responsive/breakpoints.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';

/// Dropdown styled to match [AppTextField].
class AppSelectField<T> extends StatelessWidget {
  const AppSelectField({
    super.key,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.label,
    this.isRequired = false,
    this.hint,
    this.prefixIcon,
    this.contentPadding,
    this.enabled = true,
    this.labelSpacing,
  });

  final T value;
  final List<T> items;
  final String Function(T value) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? label;
  final bool isRequired;
  final String? hint;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final double? labelSpacing;

  /// Filter / category row style with filter icon prefix.
  static AppSelectField<String> filter({
    Key? key,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? prefixIconAsset,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return AppSelectField<String>(
      key: key,
      value: value,
      items: items,
      itemLabel: (v) => v,
      onChanged: onChanged,
      prefixIcon: prefixIconAsset == null
          ? null
          : Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
              child: SvgPicture.asset(
                prefixIconAsset,
                width: 16.r,
                height: 16.r,
              ),
            ),
    );
  }

  static TextStyle _itemStyle(BuildContext context) {
    final fontSize = AppTextField.fontSizeFor(context);
    return Theme.of(context).textTheme.titleSmall!.copyWith(
      color: AppColors.textDark,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.32,
      fontSize: fontSize,
      height: 20 / 14,
    );
  }

  EdgeInsetsGeometry _defaultContentPadding(BuildContext context) {
    final hasPrefix = prefixIcon != null;
    final layout = AppBreakpoints.fromContext(context);
    final vertical = layout.isMobile ? 12.h : 11.5.h;
    return EdgeInsets.fromLTRB(
      hasPrefix ? 44.w : (layout.isMobile ? 14.w : 17.w),
      vertical,
      layout.isMobile ? 32.w : 29.w,
      vertical,
    );
  }

  static Widget prefixIconAsset(BuildContext context, String asset) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: SvgPicture.asset(asset, width: 20.r, height: 20.r),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layout = AppBreakpoints.fromContext(context);
    final height = AppTextField.fieldHeightFor(context);
    final itemStyle = _itemStyle(context);
    final resolvedPadding = contentPadding ?? _defaultContentPadding(context);
    final arrowSize = layout.isMobile ? 22.r : 20.r;

    final field = SizedBox(
      height: height.w,
      child: InputDecorator(
        decoration: AppTextField.decoration(
          context: context,
          hint: hint,
          prefixIcon: prefixIcon,
          contentPadding: resolvedPadding,
          fixedHeight: true,
          fontSize: AppTextField.fontSizeFor(context),
        ),
        isEmpty: false,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            isDense: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textDark,
              size: arrowSize,
            ),
            style: itemStyle,
            selectedItemBuilder: (context) => items
                .map(
                  (item) => Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      itemLabel(item),
                      style: itemStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      itemLabel(item),
                      style: itemStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ),
    );

    if (label == null) {
      return field;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppFieldLabel(label: label!, isRequired: isRequired),
        SizedBox(height: (labelSpacing ?? 8).h),
        field,
      ],
    );
  }
}
