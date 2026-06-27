import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/date_selection_field.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/providers/role_delegation/create_role_delegation_form_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/role_delegation/create_role_delegation_form_state.dart';
import 'package:grc/features/security_manager/presentation/providers/role_delegation/role_delegation_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/role_delegation/role_delegation_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateRoleDelegationDialog extends ConsumerStatefulWidget {
  const CreateRoleDelegationDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (context) => const CreateRoleDelegationDialog(),
    );
  }

  @override
  ConsumerState<CreateRoleDelegationDialog> createState() => _CreateRoleDelegationDialogState();
}

class _CreateRoleDelegationDialogState extends ConsumerState<CreateRoleDelegationDialog> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(createRoleDelegationFormProvider);
    final notifier = ref.read(createRoleDelegationFormProvider.notifier);

    if (_notesController.text != state.notes) {
      _notesController.value = _notesController.value.copyWith(
        text: state.notes,
        selection: TextSelection.collapsed(offset: state.notes.length),
      );
    }

    return AppDialog(
      title: 'Create New Delegation',
      subtitle: 'Assign temporary role access to another user',
      width: 600.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delegator (Your Role)',
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
              fontFamily: 'Inter',
            ),
          ),
          Gap(8.h),
          _DelegatorCard(user: state.currentUser, isDark: isDark),
          Gap(16.h),
          DigifySelectFieldWithLabel<RoleDelegationUser>(
            label: 'Delegate To',
            isRequired: true,
            hint: 'Select user to delegate to...',
            items: CreateRoleDelegationFormNotifier.availableDelegatees,
            value: state.delegatee,
            itemLabelBuilder: (user) => '${user.name} • ${user.title}',
            onChanged: notifier.setDelegatee,
          ),
          Gap(16.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Roles to Delegate',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                    fontFamily: 'Inter',
                  ),
                ),
                TextSpan(
                  text: ' *',
                  style: context.textTheme.bodyMedium?.copyWith(
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
          Column(
            spacing: 8.h,
            children: [
              for (final role in CreateRoleDelegationFormNotifier.availableRoles)
                _RoleOptionTile(
                  role: role,
                  isDark: isDark,
                  value: state.selectedRoles.contains(role),
                  onChanged: () => notifier.toggleRole(role),
                ),
            ],
          ),
          Gap(16.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isTwoColumn = constraints.maxWidth >= 420.w;
              if (!isTwoColumn) {
                return Column(
                  children: [
                    DateSelectionField(
                      label: 'Start Date',
                      isRequired: true,
                      date: state.startDate,
                      firstDate: DateTime(2026, 1, 1),
                      lastDate: DateTime(2027, 12, 31),
                      onDateSelected: notifier.setStartDate,
                    ),
                    Gap(12.h),
                    DateSelectionField(
                      label: 'End Date',
                      isRequired: true,
                      date: state.endDate,
                      firstDate: state.startDate ?? DateTime(2026, 1, 1),
                      lastDate: DateTime(2027, 12, 31),
                      onDateSelected: notifier.setEndDate,
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DateSelectionField(
                      label: 'Start Date',
                      isRequired: true,
                      date: state.startDate,
                      firstDate: DateTime(2026, 1, 1),
                      lastDate: DateTime(2027, 12, 31),
                      onDateSelected: notifier.setStartDate,
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: DateSelectionField(
                      label: 'End Date',
                      isRequired: true,
                      date: state.endDate,
                      firstDate: state.startDate ?? DateTime(2026, 1, 1),
                      lastDate: DateTime(2027, 12, 31),
                      onDateSelected: notifier.setEndDate,
                    ),
                  ),
                ],
              );
            },
          ),
          Gap(16.h),
          DigifySelectFieldWithLabel<String>(
            label: 'Reason for Delegation',
            isRequired: true,
            hint: 'Select reason...',
            items: CreateRoleDelegationFormNotifier.availableReasons,
            value: state.reason,
            itemLabelBuilder: (item) => item,
            onChanged: notifier.setReason,
          ),
          Gap(16.h),
          DigifyTextArea(
            controller: _notesController,
            labelText: 'Additional Notes (Optional)',
            hintText: 'Add any additional context or instructions...',
            maxLines: 3,
            onChanged: notifier.setNotes,
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Cancel', height: 40.h, onPressed: () => Navigator.of(context).pop()),
        Gap(10.w),
        AppButton.primary(
          label: 'Create Delegation',
          svgPath: Assets.icons.addNewIconFigma.path,
          height: 40.h,
          onPressed: () => _handleCreate(context, state),
        ),
      ],
    );
  }

  void _handleCreate(BuildContext context, CreateRoleDelegationFormState state) {
    if (!state.isValid) {
      ToastService.warning(context, 'Please complete the required delegation details.', title: 'Create Delegation');
      return;
    }

    final delegatee = state.delegatee;
    final startDate = state.startDate;
    final endDate = state.endDate;
    final reason = state.reason;

    if (delegatee == null || startDate == null || endDate == null || reason == null) {
      return;
    }

    ref
        .read(roleDelegationProvider.notifier)
        .createDelegation(
          delegator: state.currentUser,
          delegatee: delegatee,
          delegatedRoles: state.selectedRoles.toList(),
          startDate: startDate,
          endDate: endDate,
          reason: reason,
        );

    Navigator.of(context).pop();
    ToastService.success(context, 'Delegation request created successfully.', title: 'Role Delegation');
  }
}

class _DelegatorCard extends StatelessWidget {
  final RoleDelegationUser user;
  final bool isDark;

  const _DelegatorCard({required this.user, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        children: [
          AppAvatar(image: null, fallbackInitial: user.name, size: 34.w, backgroundColor: AppColors.primary),
          Gap(10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(2.h),
              Text(
                user.title,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleOptionTile extends StatelessWidget {
  final String role;
  final bool value;
  final bool isDark;
  final VoidCallback onChanged;

  const _RoleOptionTile({required this.role, required this.value, required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 44.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: DigifyCheckbox(value: value, onChanged: (_) => onChanged(), label: role),
        ),
      ),
    );
  }
}
