import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/workforce_structure/presentation/providers/employee_providers.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ContactNotesStep extends ConsumerStatefulWidget {
  const ContactNotesStep({super.key});

  @override
  ConsumerState<ContactNotesStep> createState() => _ContactNotesStepState();
}

class _ContactNotesStepState extends ConsumerState<ContactNotesStep> {
  final _reasonController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();
  final _additionalNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(newLeaveRequestProvider);

    _reasonController.text = state.reason ?? '';
    _addressController.text = state.addressDuringLeave ?? '';
    _contactPhoneController.text = state.contactPhoneNumber ?? '';
    _emergencyContactNameController.text = state.emergencyContactName ?? '';
    _emergencyContactPhoneController.text = state.emergencyContactPhone ?? '';
    _additionalNotesController.text = state.additionalNotes ?? '';
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _addressController.dispose();
    _contactPhoneController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final state = ref.watch(newLeaveRequestProvider);
    final notifier = ref.read(newLeaveRequestProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        _buildReasonField(localizations, state, notifier),
        _buildDelegatedToField(localizations, state, notifier),
        _buildContactInformationSection(localizations, state, notifier),
        _buildAdditionalNotesField(localizations, state, notifier),
      ],
    );
  }

  Widget _buildReasonField(
    AppLocalizations localizations,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return DigifyTextArea(
      controller: _reasonController,
      labelText: localizations.reasonForLeave,
      hintText: localizations.pleaseProvideDetailedReason,
      maxLines: 6,
      minLines: 6,
      showCharacterCount: true,
      maxLength: 500,
      isRequired: true,
      characterCountFormatter: (count) => localizations.charactersCount(count),
      onChanged: (value) => notifier.setReason(value),
      fillColor: AppColors.cardBackground,
    );
  }

  Widget _buildDelegatedToField(
    AppLocalizations localizations,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    final enterpriseId = ref.watch(leaveManagementEnterpriseIdProvider) ?? 0;
    final employeesState = ref.watch(employeeNotifierProvider);
    Employee? delegatedToEmployee;
    if (state.delegatedToEmployeeId != null) {
      try {
        delegatedToEmployee = employeesState.employees.firstWhere((emp) => emp.id == state.delegatedToEmployeeId);
      } catch (_) {}
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmployeeSearchField(
          label: localizations.workDelegatedTo,
          enterpriseId: enterpriseId,
          selectedEmployee: delegatedToEmployee,
          onEmployeeSelected: (employee) {
            notifier.setDelegatedTo(employee.id, employee.fullName);
          },
          fillColor: AppColors.cardBackground,
        ),
        Gap(8.h),
        Text(
          localizations.selectColleagueWhoWillHandle,
          style: context.textTheme.bodySmall?.copyWith(color: AppColors.tableHeaderText, fontSize: 12.0.sp),
        ),
      ],
    );
  }

  Widget _buildContactInformationSection(
    AppLocalizations localizations,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyDivider(margin: EdgeInsets.only(bottom: 24.h)),
            Row(
              children: [
                DigifyAsset(assetPath: Assets.icons.leaveManagement.phone.path),
                Gap(8.w),
                Text(
                  localizations.contactInformationDuringLeave,
                  style: context.textTheme.titleSmall?.copyWith(color: AppColors.textPrimary, fontSize: 15.4.sp),
                ),
              ],
            ),
            Gap(16.h),
            _buildAddressField(localizations, state, notifier),
            Gap(16.h),
            if (context.isMobile)
              Column(
                children: [
                  _buildContactPhoneField(localizations, state, notifier),
                  Gap(16.h),
                  _buildEmergencyContactNameField(localizations, state, notifier),
                ],
              )
            else
              Row(
                children: [
                  Expanded(child: _buildContactPhoneField(localizations, state, notifier)),
                  Gap(16.w),
                  Expanded(child: _buildEmergencyContactNameField(localizations, state, notifier)),
                ],
              ),
            Gap(16.h),
            _buildEmergencyContactPhoneField(localizations, state, notifier),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressField(
    AppLocalizations localizations,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return DigifyTextArea(
      controller: _addressController,
      labelText: localizations.addressDuringLeave,
      hintText: localizations.enterAddressOrLocation,
      maxLines: 6,
      minLines: 6,
      isRequired: true,
      onChanged: (value) => notifier.setAddressDuringLeave(value),
      fillColor: AppColors.cardBackground,
    );
  }

  Widget _buildContactPhoneField(
    AppLocalizations localizations,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return DigifyTextField(
      controller: _contactPhoneController,
      labelText: localizations.contactPhoneNumber,
      hintText: '+965 XXXX XXXX',
      keyboardType: TextInputType.phone,
      isRequired: true,
      onChanged: (value) => notifier.setContactPhoneNumber(value),
      filled: true,
      fillColor: AppColors.cardBackground,
      inputFormatters: FieldFormat.phoneFormatters,
    );
  }

  Widget _buildEmergencyContactNameField(
    AppLocalizations localizations,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return DigifyTextField(
      controller: _emergencyContactNameController,
      labelText: localizations.emergencyContactName,
      hintText: localizations.enterEmergencyContactName,
      isRequired: true,
      onChanged: (value) => notifier.setEmergencyContactName(value),
      filled: true,
      fillColor: AppColors.cardBackground,
    );
  }

  Widget _buildEmergencyContactPhoneField(
    AppLocalizations localizations,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return DigifyTextField(
      controller: _emergencyContactPhoneController,
      labelText: localizations.emergencyContactPhone,
      hintText: '+965 XXXX XXXX',
      keyboardType: TextInputType.phone,
      isRequired: true,
      onChanged: (value) => notifier.setEmergencyContactPhone(value),
      filled: true,
      fillColor: AppColors.cardBackground,
      inputFormatters: FieldFormat.phoneFormatters,
    );
  }

  Widget _buildAdditionalNotesField(
    AppLocalizations localizations,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return DigifyTextArea(
      controller: _additionalNotesController,
      labelText: localizations.additionalNotes,
      hintText: localizations.anyAdditionalInformation,
      maxLines: 6,
      minLines: 6,
      onChanged: (value) => notifier.setAdditionalNotes(value),
      fillColor: AppColors.cardBackground,
    );
  }
}
