import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DigifySelectField<T> extends StatefulWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?>? onChanged;
  final bool isRequired;
  final Color? color;
  final Color? fillColor;

  const DigifySelectField({
    super.key,
    this.label,
    required this.items,
    required this.itemLabelBuilder,
    this.hint,
    this.value,
    this.onChanged,
    this.isRequired = false,
    this.color,
    this.fillColor,
  });

  @override
  State<DigifySelectField<T>> createState() => _DigifySelectFieldState<T>();
}

class _DigifySelectFieldState<T> extends State<DigifySelectField<T>> {
  late final ValueNotifier<T?> _valueNotifier;

  @override
  void initState() {
    super.initState();
    _valueNotifier = ValueNotifier<T?>(widget.value);
  }

  @override
  void didUpdateWidget(covariant DigifySelectField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _valueNotifier.value = widget.value;
    }
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveFillColor = widget.fillColor ?? (isDark ? AppColors.inputBgDark : Colors.transparent);
    final effectiveTextColor = isDark ? context.themeTextPrimary : AppColors.textPrimary;
    final effectiveHintColor = isDark ? context.themeTextMuted : const Color(0xFF0A0A0A).withValues(alpha: 0.5);
    final effectiveBorderColor = isDark ? AppColors.inputBorderDark : AppColors.inputBorder;

    final safeItems = widget.value != null && !widget.items.contains(widget.value)
        ? [widget.value as T, ...widget.items]
        : widget.items;

    return SizedBox(
      height: 40.w,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isExpanded: true,
          hint: Text(
            widget.hint ?? 'Select an option',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: effectiveHintColor),
          ),
          items: safeItems
              .map(
                (item) => DropdownItem<T>(
                  value: item,
                  height: 48.w,
                  child: Text(
                    widget.itemLabelBuilder(item),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: effectiveTextColor),
                  ),
                ),
              )
              .toList(),
          valueListenable: _valueNotifier,
          onChanged: widget.onChanged == null
              ? null
              : (value) {
                  _valueNotifier.value = value;
                  widget.onChanged!(value);
                },
          buttonStyleData: ButtonStyleData(
            height: 40.w,
            decoration: BoxDecoration(
              color: effectiveFillColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: effectiveBorderColor, width: 1.0.w),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: DigifyAsset(
              assetPath: Assets.icons.workforce.chevronDown.path,
              height: 20,
              color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
            ),
            iconSize: 24.sp,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: isDark ? AppColors.cardBackgroundDark : Colors.white,
              boxShadow: AppShadows.primaryShadow,
            ),
            scrollbarTheme: ScrollbarThemeData(
              radius: Radius.circular(10.r),
              thickness: WidgetStateProperty.all(6),
              thumbVisibility: WidgetStateProperty.all(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16.w)),
        ),
      ),
    );
  }
}
