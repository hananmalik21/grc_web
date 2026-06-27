import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifyCountryCodePickerDialog extends StatefulWidget {
  const DigifyCountryCodePickerDialog({
    super.key,
    required this.countries,
    required this.favoriteCountries,
    this.selected,
  });

  final List<CountryCode> countries;
  final List<CountryCode> favoriteCountries;
  final CountryCode? selected;

  static Future<CountryCode?> show(
    BuildContext context, {
    required List<CountryCode> countries,
    required List<CountryCode> favoriteCountries,
    CountryCode? selected,
  }) {
    return showDialog<CountryCode>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) =>
          DigifyCountryCodePickerDialog(countries: countries, favoriteCountries: favoriteCountries, selected: selected),
    );
  }

  @override
  State<DigifyCountryCodePickerDialog> createState() => _DigifyCountryCodePickerDialogState();
}

class _DigifyCountryCodePickerDialogState extends State<DigifyCountryCodePickerDialog> {
  late List<CountryCode> _filteredCountries;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterCountries(String query) {
    final normalized = query.trim().toUpperCase();
    setState(() {
      if (normalized.isEmpty) {
        _filteredCountries = widget.countries;
        return;
      }

      _filteredCountries = widget.countries
          .where(
            (country) =>
                country.code?.toUpperCase().contains(normalized) == true ||
                country.dialCode?.contains(normalized) == true ||
                country.name?.toUpperCase().contains(normalized) == true,
          )
          .toList();
    });
  }

  List<CountryCode> get _visibleCountries {
    final isSearching = _searchController.text.trim().isNotEmpty;
    if (isSearching) return _filteredCountries;

    final favoriteDialCodes = widget.favoriteCountries.map((c) => c.dialCode).toSet();
    return _filteredCountries.where((country) => !favoriteDialCodes.contains(country.dialCode)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isSearching = _searchController.text.trim().isNotEmpty;
    final backgroundColor = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final textColor = isDark ? context.themeTextPrimary : AppColors.textPrimary;
    final mutedTextColor = isDark ? context.themeTextMuted : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.inputBorderDark : AppColors.inputBorder;
    final hoverColor = isDark ? AppColors.primary.withValues(alpha: 0.12) : AppColors.primary.withValues(alpha: 0.06);
    final selectedColor = isDark
        ? AppColors.primary.withValues(alpha: 0.18)
        : AppColors.primary.withValues(alpha: 0.08);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 16.w : 24.w, vertical: 24.h),
        child: Container(
          width: isMobile ? double.infinity : 440.w,
          constraints: BoxConstraints(maxWidth: 480.w, maxHeight: 560.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: borderColor),
            boxShadow: AppShadows.headerShadow(isDark),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogHeader(
                title: l10n.hintSelectCountry,
                isDark: isDark,
                textColor: textColor,
                mutedTextColor: mutedTextColor,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                child: DigifyTextField.search(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  hintText: l10n.searchCountryPlaceholder,
                  filled: true,
                  fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
                  onChanged: _filterCountries,
                ),
              ),
              Flexible(
                child: _visibleCountries.isEmpty && (isSearching || widget.favoriteCountries.isEmpty)
                    ? _EmptyState(message: l10n.noCountryFound, mutedTextColor: mutedTextColor)
                    : ListView(
                        padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
                        children: [
                          if (!isSearching && widget.favoriteCountries.isNotEmpty) ...[
                            _SectionLabel(label: l10n.frequentlyUsed, mutedTextColor: mutedTextColor),
                            ...widget.favoriteCountries.map(
                              (country) => _CountryListTile(
                                country: country,
                                isSelected: _isSelected(country),
                                textColor: textColor,
                                mutedTextColor: mutedTextColor,
                                hoverColor: hoverColor,
                                selectedColor: selectedColor,
                                onTap: () => Navigator.pop(context, country),
                              ),
                            ),
                            Gap(8.h),
                            Divider(height: 1, color: borderColor),
                            Gap(8.h),
                            _SectionLabel(label: l10n.allCountries, mutedTextColor: mutedTextColor),
                          ],
                          ..._visibleCountries.map(
                            (country) => _CountryListTile(
                              country: country,
                              isSelected: _isSelected(country),
                              textColor: textColor,
                              mutedTextColor: mutedTextColor,
                              hoverColor: hoverColor,
                              selectedColor: selectedColor,
                              onTap: () => Navigator.pop(context, country),
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

  bool _isSelected(CountryCode country) {
    final selected = widget.selected;
    if (selected == null) return false;
    return selected.dialCode == country.dialCode || selected.code == country.code;
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.title,
    required this.isDark,
    required this.textColor,
    required this.mutedTextColor,
  });

  final String title;
  final bool isDark;
  final Color textColor;
  final Color mutedTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 12.w, 16.h),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: textColor, letterSpacing: -0.2),
                ),
                Gap(4.h),
                Text(
                  AppLocalizations.of(context)!.selectDialCodeSubtitle,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: mutedTextColor),
                ),
              ],
            ),
          ),
          DigifyAssetButton(assetPath: Assets.icons.closeIcon.path, onTap: () => context.pop(), color: mutedTextColor),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.mutedTextColor});

  final String label;
  final Color mutedTextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.w, 4.h, 8.w, 8.h),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: mutedTextColor, letterSpacing: 0.6),
      ),
    );
  }
}

class _CountryListTile extends StatefulWidget {
  const _CountryListTile({
    required this.country,
    required this.isSelected,
    required this.textColor,
    required this.mutedTextColor,
    required this.hoverColor,
    required this.selectedColor,
    required this.onTap,
  });

  final CountryCode country;
  final bool isSelected;
  final Color textColor;
  final Color mutedTextColor;
  final Color hoverColor;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  State<_CountryListTile> createState() => _CountryListTileState();
}

class _CountryListTileState extends State<_CountryListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isSelected
        ? widget.selectedColor
        : _isHovered
        ? widget.hoverColor
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10.r),
              border: widget.isSelected ? Border.all(color: AppColors.primary.withValues(alpha: 0.35)) : null,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: Image.asset(
                    widget.country.flagUri!,
                    package: 'country_code_picker',
                    width: 28.w,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: Text(
                    widget.country.name ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: widget.textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gap(8.w),
                Text(
                  widget.country.dialCode ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: widget.isSelected ? AppColors.primary : widget.mutedTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, required this.mutedTextColor});

  final String message;
  final Color mutedTextColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.public_off_outlined, size: 40.sp, color: mutedTextColor),
            Gap(12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: mutedTextColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

List<CountryCode> digifyCountryCodeList() {
  return codes.map(CountryCode.fromJson).toList();
}

List<CountryCode> digifyFavoriteCountryCodes({
  List<String> favorites = const ['+965', '+971', '+966', '+974', '+973', '+968'],
  required List<CountryCode> countries,
}) {
  return countries
      .where(
        (country) => favorites.any(
          (favorite) =>
              country.code?.toUpperCase() == favorite.toUpperCase() ||
              country.dialCode == favorite ||
              country.name?.toUpperCase() == favorite.toUpperCase(),
        ),
      )
      .toList();
}

CountryCode? digifyCountryCodeFromSelection(List<CountryCode> countries, String? selection) {
  if (countries.isEmpty) return null;

  if (selection == null || selection.isEmpty) {
    for (final country in countries) {
      if (country.code == 'KW') return country;
    }
    return countries.first;
  }

  for (final country in countries) {
    if (country.code?.toUpperCase() == selection.toUpperCase() ||
        country.dialCode == selection ||
        country.name?.toUpperCase() == selection.toUpperCase()) {
      return country;
    }
  }

  return countries.first;
}
