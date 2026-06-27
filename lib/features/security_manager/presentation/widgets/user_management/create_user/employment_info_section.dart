import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/services/responsive/responsive_extensions.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../providers/user_management/user_form_provider.dart';
import '../user_form_section.dart';

class EmploymentInfoSection extends ConsumerWidget {
  const EmploymentInfoSection({super.key});

  static String _text(String? v) => v?.trim().isEmpty ?? true ? '' : v!;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);

    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Employment Information',
        icon: DigifyAsset(
          assetPath: Assets.icons.employeeManagement.assignment.path,
          width: 18.w,
          height: 18.w,
          color: AppColors.primary,
        ),
      ),
      child: Column(
        children: [
          if (context.isMobile) ...[
            DigifyTextField(
              key: ValueKey('dept-m-${state.department}'),
              labelText: 'Department',
              hintText: '—',
              initialValue: _text(state.department),
              readOnly: true,
            ),
            Gap(16.h),
            DigifyTextField(
              key: ValueKey('job-m-${state.jobTitle}'),
              labelText: 'Job Title',
              hintText: '—',
              initialValue: _text(state.jobTitle),
              readOnly: true,
            ),
            Gap(16.h),
            DigifyTextField(
              key: ValueKey('type-m-${state.employeeType}'),
              labelText: 'Employee Type',
              hintText: '—',
              initialValue: _text(state.employeeType),
              readOnly: true,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    key: ValueKey('dept-d-${state.department}'),
                    labelText: 'Department',
                    hintText: '—',
                    initialValue: _text(state.department),
                    readOnly: true,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    key: ValueKey('job-d-${state.jobTitle}'),
                    labelText: 'Job Title',
                    hintText: '—',
                    initialValue: _text(state.jobTitle),
                    readOnly: true,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    key: ValueKey('type-d-${state.employeeType}'),
                    labelText: 'Employee Type',
                    hintText: '—',
                    initialValue: _text(state.employeeType),
                    readOnly: true,
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyTextField(
              key: ValueKey('mgr-m-${state.reportToManager}'),
              labelText: 'Reports To (Manager)',
              hintText: '—',
              initialValue: _text(state.reportToManager),
              readOnly: true,
            ),
            Gap(16.h),
            DigifyTextField(
              key: const Key('work-location-mobile'),
              labelText: 'Work Location',
              hintText: '—',
              initialValue: _text(state.workLocation),
              onChanged: (v) => notifier.setWorkLocation(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    key: ValueKey('mgr-d-${state.reportToManager}'),
                    labelText: 'Reports To (Manager)',
                    hintText: '—',
                    initialValue: _text(state.reportToManager),
                    readOnly: true,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    key: const Key('work-location-desktop'),
                    labelText: 'Work Location',
                    hintText: '—',
                    initialValue: _text(state.workLocation),
                    onChanged: (v) => notifier.setWorkLocation(v),
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyDateField(label: 'Hire Date', hintText: 'dd/mm/yyyy', initialDate: state.hireDate, readOnly: true),
            Gap(16.h),
            DigifyDateField(label: 'Start Date', hintText: 'dd/mm/yyyy', initialDate: state.startDate, readOnly: true),
            Gap(16.h),
            DigifyDateField(label: 'End Date', hintText: 'dd/mm/yyyy', initialDate: state.endDate, readOnly: true),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyDateField(
                    label: 'Hire Date',
                    hintText: 'dd/mm/yyyy',
                    initialDate: state.hireDate,
                    readOnly: true,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyDateField(
                    label: 'Start Date',
                    hintText: 'dd/mm/yyyy',
                    initialDate: state.startDate,
                    readOnly: true,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyDateField(
                    label: 'End Date',
                    hintText: 'dd/mm/yyyy',
                    initialDate: state.endDate,
                    readOnly: true,
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
