import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/locale_provider.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value_extensions.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'create_requisition_rec_lookup_select_field.dart';
import 'create_requisition_section_card.dart';

class CreateRequisitionSkillsQualsStep extends ConsumerStatefulWidget {
  const CreateRequisitionSkillsQualsStep({super.key});

  @override
  ConsumerState<CreateRequisitionSkillsQualsStep> createState() => _CreateRequisitionSkillsQualsStepState();
}

class _CreateRequisitionSkillsQualsStepState extends ConsumerState<CreateRequisitionSkillsQualsStep> {
  String? _pendingSkillCode;

  void _addSkillFromLookup() {
    final code = _pendingSkillCode?.trim();
    if (code == null || code.isEmpty) return;
    ref.read(createRequisitionProvider.notifier).addRequiredSkill(code);
    setState(() => _pendingSkillCode = null);
  }

  Widget _buildResponsiveRow({required List<Widget> children, required BuildContext context}) {
    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final widget = entry.value;
          final isLast = index == children.length - 1;

          Widget effectiveWidget = widget;
          if (widget is Expanded) {
            effectiveWidget = widget.child;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [effectiveWidget, if (!isLast) Gap(16.h)],
          );
        }).toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final widget = entry.value;
        final isLast = index == children.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(child: widget is Expanded ? widget.child : widget),
              if (!isLast) Gap(16.w),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createRequisitionProvider);
    final notifier = ref.read(createRequisitionProvider.notifier);
    final isRtl = ref.watch(localeProvider).languageCode == 'ar';

    final skillLookups = ref.watch(createRequisitionSkillsLookupValuesProvider).valueOrNull ?? const [];
    final minEduLookups = ref.watch(createRequisitionMinEduLevelLookupValuesProvider).valueOrNull ?? const [];
    final expYearLookups = ref.watch(createRequisitionExpYearLookupValuesProvider).valueOrNull ?? const [];
    final prefFieldLookups = ref.watch(createRequisitionPrefFieldLookupValuesProvider).valueOrNull ?? const [];
    final managExpLookups = ref.watch(createRequisitionManagExpLookupValuesProvider).valueOrNull ?? const [];

    final availableSkillCodes = skillLookups
        .map((v) => v.lookupCode)
        .where((code) => code.trim().isNotEmpty && !state.requiredSkills.contains(code))
        .toList();

    String skillLabel(String code) => skillLookups.labelForCode(code, isRtl: isRtl) ?? code;

    final validPendingSkill = _pendingSkillCode != null && availableSkillCodes.contains(_pendingSkillCode!)
        ? _pendingSkillCode
        : null;

    final requiredSkillsCard = CreateRequisitionSectionCard(
      title: 'Required Skills',
      subtitle: 'Add skills required for this position',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifySelectField<String>(
                  value: validPendingSkill,
                  hint: 'Select a skill to add',
                  items: availableSkillCodes,
                  itemLabelBuilder: skillLabel,
                  onChanged: availableSkillCodes.isEmpty ? null : (value) => setState(() => _pendingSkillCode = value),
                ),
              ),
              Gap(12.w),
              AppButton.primary(
                label: 'Add',
                onPressed: (validPendingSkill != null && availableSkillCodes.isNotEmpty) ? _addSkillFromLookup : null,
              ),
            ],
          ),
          if (state.requiredSkills.isNotEmpty) ...[
            Gap(16.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: state.requiredSkills.map((code) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: context.isDark ? AppColors.cardBackgroundDark : const Color(0xFFECEEF2),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        skillLabel(code),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.isDark ? Colors.white : const Color(0xFF030213),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap(8.w),
                      GestureDetector(
                        onTap: () => notifier.removeRequiredSkill(code),
                        child: Icon(
                          Icons.close,
                          size: 14.w,
                          color: context.isDark ? Colors.white70 : const Color(0xFF030213),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );

    final educationExperienceCard = CreateRequisitionSectionCard(
      title: 'Education & Experience',
      subtitle: 'Define the required background for candidates',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResponsiveRow(
            context: context,
            children: [
              CreateRequisitionRecLookupSelectField(
                label: 'Minimum Education Level',
                selectedKey: state.minimumEducationLevel,
                hint: 'Select education level',
                lookups: minEduLookups,
                onChanged: (value) => notifier.updateSkillsAndQuals(minimumEducationLevel: value),
              ),
              CreateRequisitionRecLookupSelectField(
                label: 'Years of Experience Required',
                selectedKey: state.yearsOfExperience,
                hint: 'Select experience range',
                lookups: expYearLookups,
                onChanged: (value) => notifier.updateSkillsAndQuals(yearsOfExperience: value),
              ),
            ],
          ),
          Gap(16.h),
          _buildResponsiveRow(
            context: context,
            children: [
              CreateRequisitionRecLookupSelectField(
                label: 'Preferred Field of Study',
                selectedKey: state.preferredFieldOfStudy,
                hint: 'Select field of study',
                lookups: prefFieldLookups,
                onChanged: (value) => notifier.updateSkillsAndQuals(preferredFieldOfStudy: value),
              ),
              CreateRequisitionRecLookupSelectField(
                label: 'Management Experience',
                selectedKey: state.managementExperience,
                hint: 'Select requirement',
                lookups: managExpLookups,
                onChanged: (value) => notifier.updateSkillsAndQuals(managementExperience: value),
              ),
            ],
          ),
        ],
      ),
    );

    if (context.isMobile) {
      return Column(children: [requiredSkillsCard, Gap(20.h), educationExperienceCard]);
    }

    return Column(children: [requiredSkillsCard, Gap(24.h), educationExperienceCard]);
  }
}
