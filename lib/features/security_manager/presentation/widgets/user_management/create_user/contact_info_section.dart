import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/services/responsive/responsive_extensions.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../employee_management/domain/models/empl_lookup_value.dart';
import '../../../../../employee_management/presentation/providers/empl_lookups_provider.dart';
import '../../../providers/user_management/user_form_provider.dart';
import '../../../providers/user_management/user_management_enterprise_provider.dart';
import '../user_form_section.dart';

class ContactInfoSection extends ConsumerWidget {
  const ContactInfoSection({super.key});

  static EmplLookupValue? _matchLocation(List<EmplLookupValue> values, String? label, int? id) {
    if (values.isEmpty) return null;
    if (id != null) {
      try {
        return values.firstWhere((v) => v.lookupId == id);
      } catch (_) {}
    }
    if (label != null && label.trim().isNotEmpty) {
      try {
        return values.firstWhere((v) => v.meaningEn.toLowerCase() == label.trim().toLowerCase());
      } catch (_) {}
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    final hasLinkedEmployee = state.selectedEmployeeId != null;
    final hasPrefilledWorkPhone = hasLinkedEmployee && state.hasPrefilledWorkPhone;
    final hasPrefilledMobilePhone = hasLinkedEmployee && state.hasPrefilledMobilePhone;

    final enterpriseId = ref.watch(userManagementEnterpriseIdProvider);
    final workLocationAsync = enterpriseId != null
        ? ref.watch(emplLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: 'WORK_LOCATION')))
        : const AsyncValue<List<EmplLookupValue>>.data([]);
    final workLocationValues = workLocationAsync.valueOrNull ?? [];
    final workLocationLoading = workLocationAsync.isLoading;
    final selectedLocation = _matchLocation(workLocationValues, state.workLocation, state.workLocationId);

    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Contact Information',
        icon: DigifyAsset(
          assetPath: Assets.icons.emailEnvelopeGray.path,
          width: 18.w,
          height: 18.w,
          color: AppColors.primary,
        ),
      ),
      child: Column(
        children: [
          if (context.isMobile) ...[
            DigifyTextField(
              initialValue: state.email,
              labelText: 'Email Address',
              hintText: 'user@digifyhr.com',
              isRequired: true,
              readOnly: hasLinkedEmployee,
              onChanged: hasLinkedEmployee ? null : (v) => notifier.setEmail(v),
            ),
            Gap(16.h),
            DigifyTextField(
              initialValue: state.secondaryEmail,
              labelText: 'Secondary Email',
              hintText: 'secondary@email.com',
              isRequired: false,
              onChanged: (v) => notifier.setSecondaryEmail(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    initialValue: state.email,
                    labelText: 'Email Address',
                    hintText: 'user@digifyhr.com',
                    isRequired: true,
                    readOnly: hasLinkedEmployee,
                    onChanged: hasLinkedEmployee ? null : (v) => notifier.setEmail(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    initialValue: state.secondaryEmail,
                    labelText: 'Secondary Email',
                    hintText: 'secondary@email.com',
                    isRequired: false,
                    onChanged: (v) => notifier.setSecondaryEmail(v),
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyTextField(
              initialValue: state.workPhone,
              labelText: 'Work Phone',
              hintText: '+965 XXXX XXXX',
              isRequired: false,
              readOnly: hasPrefilledWorkPhone,
              onChanged: hasPrefilledWorkPhone ? null : (v) => notifier.setWorkPhone(v),
            ),
            Gap(16.h),
            DigifyTextField(
              initialValue: state.mobilePhone,
              labelText: 'Mobile Phone',
              hintText: '+965 XXXX XXXX',
              isRequired: false,
              readOnly: hasPrefilledMobilePhone,
              onChanged: hasPrefilledMobilePhone ? null : (v) => notifier.setMobilePhone(v),
            ),
            Gap(16.h),
            DigifyTextField(
              initialValue: state.extension,
              labelText: 'Extension',
              hintText: 'Ext. 123',
              isRequired: true,
              onChanged: (v) => notifier.setExtension(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    initialValue: state.workPhone,
                    labelText: 'Work Phone',
                    hintText: '+965 XXXX XXXX',
                    isRequired: false,
                    readOnly: hasPrefilledWorkPhone,
                    onChanged: hasPrefilledWorkPhone ? null : (v) => notifier.setWorkPhone(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    initialValue: state.mobilePhone,
                    labelText: 'Mobile Phone',
                    hintText: '+965 XXXX XXXX',
                    isRequired: false,
                    readOnly: hasPrefilledMobilePhone,
                    onChanged: hasPrefilledMobilePhone ? null : (v) => notifier.setMobilePhone(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    initialValue: state.extension,
                    labelText: 'Extension',
                    hintText: 'Ext. 123',
                    isRequired: true,
                    onChanged: (v) => notifier.setExtension(v),
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifySelectFieldWithLabel<EmplLookupValue>(
              label: l10n.workLocation,
              hint: workLocationLoading ? l10n.pleaseWait : l10n.hintWorkLocation,
              items: workLocationValues,
              itemLabelBuilder: (v) => v.meaningEn,
              value: selectedLocation,
              onChanged: workLocationLoading
                  ? null
                  : (v) {
                      if (v != null) notifier.setWorkLocationFromLookup(v.meaningEn, v.lookupId);
                    },
            ),
            Gap(16.h),
            DigifyTextField(
              initialValue: state.mailingAddress,
              labelText: 'Mailing Address',
              hintText: 'Complete mailing address',
              isRequired: false,
              onChanged: (v) => notifier.setMailingAddress(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifySelectFieldWithLabel<EmplLookupValue>(
                    label: l10n.workLocation,
                    hint: workLocationLoading ? l10n.pleaseWait : l10n.hintWorkLocation,
                    items: workLocationValues,
                    itemLabelBuilder: (v) => v.meaningEn,
                    value: selectedLocation,
                    onChanged: workLocationLoading
                        ? null
                        : (v) {
                            if (v != null) notifier.setWorkLocationFromLookup(v.meaningEn, v.lookupId);
                          },
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    initialValue: state.mailingAddress,
                    labelText: 'Mailing Address',
                    hintText: 'Complete mailing address',
                    isRequired: false,
                    onChanged: (v) => notifier.setMailingAddress(v),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
