import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/services/responsive/responsive_extensions.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../domain/models/system_user.dart';
import '../../../providers/user_management/user_form_provider.dart';
import '../user_form_section.dart';

class AccountInfoSection extends ConsumerWidget {
  const AccountInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    final l = AppLocalizations.of(context)!;
    final hasLinkedEmployee = state.selectedEmployeeId != null;

    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Account Information',
        icon: DigifyAsset(
          assetPath: Assets.icons.employeeManagement.user.path,
          width: 18.w,
          height: 18.w,
          color: AppColors.primary,
        ),
      ),
      child: Column(
        children: [
          DigifyTextField(
            initialValue: state.userCode,
            labelText: 'User Code',
            hintText: 'USR01',
            isRequired: true,
            onChanged: (v) => notifier.setUserCode(v),
          ),
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyTextField(
              initialValue: state.userName,
              labelText: 'Username',
              hintText: 'username',
              isRequired: true,
              onChanged: (v) => notifier.setUserName(v),
            ),
            Gap(16.h),
            DigifySelectFieldWithLabel<SystemUserStatus>(
              label: l.accountStatus,
              value: state.accountStatus,
              items: SystemUserStatus.values,
              itemLabelBuilder: (status) => switch (status) {
                SystemUserStatus.active => l.active,
                SystemUserStatus.locked => l.inactive,
              },
              onChanged: (v) => notifier.setAccountStatus(v!),
              isRequired: true,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    initialValue: state.userName,
                    labelText: 'Username',
                    hintText: 'username',
                    isRequired: true,
                    onChanged: (v) => notifier.setUserName(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectFieldWithLabel<SystemUserStatus>(
                    label: l.accountStatus,
                    value: state.accountStatus,
                    items: SystemUserStatus.values,
                    itemLabelBuilder: (status) => switch (status) {
                      SystemUserStatus.active => l.active,
                      SystemUserStatus.locked => l.inactive,
                    },
                    onChanged: (v) => notifier.setAccountStatus(v!),
                    isRequired: true,
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyTextField(
              initialValue: state.firstName,
              labelText: 'First Name',
              hintText: 'First name',
              isRequired: true,
              readOnly: hasLinkedEmployee,
              onChanged: hasLinkedEmployee ? null : (v) => notifier.setFirstName(v),
            ),
            Gap(16.h),
            DigifyTextField(
              initialValue: state.lastName,
              labelText: 'Last Name',
              hintText: 'Last name',
              isRequired: true,
              readOnly: hasLinkedEmployee,
              onChanged: hasLinkedEmployee ? null : (v) => notifier.setLastName(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    initialValue: state.firstName,
                    labelText: 'First Name',
                    hintText: 'First name',
                    isRequired: true,
                    readOnly: hasLinkedEmployee,
                    onChanged: hasLinkedEmployee ? null : (v) => notifier.setFirstName(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    initialValue: state.lastName,
                    labelText: 'Last Name',
                    hintText: 'Last name',
                    isRequired: true,
                    readOnly: hasLinkedEmployee,
                    onChanged: hasLinkedEmployee ? null : (v) => notifier.setLastName(v),
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyTextField(
              initialValue: state.password,
              labelText: 'Password',
              hintText: 'Enter password',
              isRequired: true,
              obscureText: true,
              onChanged: (v) => notifier.setPassword(v),
            ),
            Gap(16.h),
            DigifyTextField(
              initialValue: state.confirmPassword,
              labelText: 'Confirm Password',
              hintText: 'Confirm password',
              isRequired: true,
              obscureText: true,
              onChanged: (v) => notifier.setConfirmPassword(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    initialValue: state.password,
                    labelText: 'Password',
                    hintText: 'Enter password',
                    isRequired: true,
                    obscureText: true,
                    onChanged: (v) => notifier.setPassword(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    initialValue: state.confirmPassword,
                    labelText: 'Confirm Password',
                    hintText: 'Confirm password',
                    isRequired: true,
                    obscureText: true,
                    onChanged: (v) => notifier.setConfirmPassword(v),
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyDateField(
              label: 'Password Expiration',
              hintText: 'dd/mm/yyyy',
              initialDate: state.passwordExpiration,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100, 12, 31),
              displayTextOverride: (state.neverExpire ?? false) ? l.infiniteDisplay : null,
              onDateSelected: (v) => notifier.setPasswordExpiration(v),
            ),
            Gap(12.h),
            DigifyCheckbox(
              value: state.neverExpire ?? false,
              onChanged: (v) => notifier.setNeverExpire(v!),
              label: l.neverExpires,
            ),
            Gap(16.h),
            DigifyDateField(
              label: 'Account Expiration',
              hintText: 'dd/mm/yyyy',
              initialDate: state.accountExpiration,
              firstDate: DateTime(1900, 1, 1),
              lastDate: DateTime(2100, 12, 31),
              onDateSelected: (v) => notifier.setAccountExpiration(v),
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DigifyDateField(
                        label: 'Password Expiration',
                        hintText: 'dd/mm/yyyy',
                        initialDate: state.passwordExpiration,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100, 12, 31),
                        displayTextOverride: (state.neverExpire ?? false) ? l.infiniteDisplay : null,
                        onDateSelected: (v) => notifier.setPasswordExpiration(v),
                      ),
                      Gap(12.h),
                      DigifyCheckbox(
                        value: state.neverExpire ?? false,
                        onChanged: (v) => notifier.setNeverExpire(v!),
                        label: l.neverExpires,
                      ),
                    ],
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyDateField(
                    label: 'Account Expiration',
                    hintText: 'dd/mm/yyyy',
                    initialDate: state.accountExpiration,
                    firstDate: DateTime(1900, 1, 1),
                    lastDate: DateTime(2100, 12, 31),
                    onDateSelected: (v) => notifier.setAccountExpiration(v),
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
