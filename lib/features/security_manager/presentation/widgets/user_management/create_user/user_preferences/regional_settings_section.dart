import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/section_header_card.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/time_zone_search_field.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_form_provider.dart';
import 'package:grc/features/time_management/domain/models/time_zone.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/user_form_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RegionalSettingsSection extends ConsumerWidget {
  const RegionalSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    final currencyValuesAsync = ref.watch(userFormCurrencyValuesAsyncProvider);
    final currencyValues = ref.watch(userFormCurrencyItemsProvider);
    final selectedCurrency = ref.watch(userFormSelectedCurrencyItemProvider);

    final currencyField = DigifySelectFieldWithLabel<SecurityLookupValue>(
      label: 'Currency',
      value: selectedCurrency,
      items: currencyValues,
      itemLabelBuilder: (item) => '${item.valueCode} - ${item.valueName}',
      onChanged: currencyValuesAsync.isLoading ? null : (v) => notifier.setCurrency(v?.valueCode ?? ''),
    );

    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Regional & Language Settings',
        iconAssetPath: Assets.icons.header.language.path,
      ),
      child: Column(
        children: [
          if (context.isMobile) ...[
            DigifySelectFieldWithLabel<String>(
              label: 'Preferred Language',
              value: state.language,
              items: const ['English', 'Arabic', 'Both (English/Arabic)'],
              itemLabelBuilder: (item) => item,
              onChanged: (v) => notifier.setLanguage(v!),
            ),
            Gap(16.h),
            TimeZoneSearchField(
              label: 'Time Zone',
              selectedTimeZone: (state.timeZone ?? '').trim().isEmpty ? null : TimeZone(tzName: state.timeZone!.trim()),
              onTimeZoneSelected: (v) => notifier.setTimeZone(v.tzName),
            ),
            Gap(16.h),
            currencyField,
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifySelectFieldWithLabel<String>(
                    label: 'Preferred Language',
                    value: state.language,
                    items: const ['English', 'Arabic', 'Both (English/Arabic)'],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) => notifier.setLanguage(v!),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: TimeZoneSearchField(
                    label: 'Time Zone',
                    selectedTimeZone: (state.timeZone ?? '').trim().isEmpty
                        ? null
                        : TimeZone(tzName: state.timeZone!.trim()),
                    onTimeZoneSelected: (v) => notifier.setTimeZone(v.tzName),
                  ),
                ),
              ],
            ),
            Gap(16.h),
            Row(children: [Expanded(child: currencyField)]),
          ],
        ],
      ),
    );
  }
}
