import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'create_offer_section_card.dart';

class CreateOfferBenefitsStep extends ConsumerStatefulWidget {
  const CreateOfferBenefitsStep({super.key});

  @override
  ConsumerState<CreateOfferBenefitsStep> createState() => _CreateOfferBenefitsStepState();
}

class _CreateOfferBenefitsStepState extends ConsumerState<CreateOfferBenefitsStep> {
  late final TextEditingController _retirementPlanController;
  late final TextEditingController _ptoDaysController;
  late final TextEditingController _sickDaysController;
  late final TextEditingController _personalDaysController;
  late final TextEditingController _parentalLeaveController;
  late final TextEditingController _additionalBenefitController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createOfferProvider);
    _retirementPlanController = TextEditingController(text: state.retirementPlan);
    _ptoDaysController = TextEditingController(text: state.ptoDays);
    _sickDaysController = TextEditingController(text: state.sickDays);
    _personalDaysController = TextEditingController(text: state.personalDays);
    _parentalLeaveController = TextEditingController(text: state.parentalLeave);
    _additionalBenefitController = TextEditingController();
  }

  @override
  void dispose() {
    _retirementPlanController.dispose();
    _ptoDaysController.dispose();
    _sickDaysController.dispose();
    _personalDaysController.dispose();
    _parentalLeaveController.dispose();
    _additionalBenefitController.dispose();
    super.dispose();
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
    final isMobile = context.isMobile;
    final state = ref.watch(createOfferProvider);
    final notifier = ref.read(createOfferProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateOfferSectionCard(
          title: 'Insurance & Health Benefits',
          child: GridView.count(
            crossAxisCount: isMobile ? 1 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: isMobile ? 6.5 : 5,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            children: [
              _buildBenefitToggle(
                label: 'Health Insurance',
                value: state.healthInsurance,
                onChanged: (value) => notifier.updateBenefits(healthInsurance: value),
              ),
              _buildBenefitToggle(
                label: 'Dental Insurance',
                value: state.dentalInsurance,
                onChanged: (value) => notifier.updateBenefits(dentalInsurance: value),
              ),
              _buildBenefitToggle(
                label: 'Vision Insurance',
                value: state.visionInsurance,
                onChanged: (value) => notifier.updateBenefits(visionInsurance: value),
              ),
              _buildBenefitToggle(
                label: 'Life Insurance',
                value: state.lifeInsurance,
                onChanged: (value) => notifier.updateBenefits(lifeInsurance: value),
              ),
            ],
          ),
        ),
        Gap(24.h),
        CreateOfferSectionCard(
          title: 'Retirement & Savings',
          child: DigifyTextField(
            controller: _retirementPlanController,
            labelText: 'Retirement Plan',
            isRequired: true,
            hintText: 'e.g., 401(k) - 4% match',
            onChanged: (value) => notifier.updateBenefits(retirementPlan: value),
          ),
        ),
        Gap(24.h),
        CreateOfferSectionCard(
          title: 'Time Off',
          child: _buildResponsiveRow(
            context: context,
            children: [
              Expanded(
                child: DigifyTextField(
                  controller: _ptoDaysController,
                  labelText: 'PTO Days',
                  isRequired: true,
                  hintText: '20',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => notifier.updateBenefits(ptoDays: value),
                ),
              ),
              Expanded(
                child: DigifyTextField(
                  controller: _sickDaysController,
                  labelText: 'Sick Days',
                  isRequired: true,
                  hintText: '10',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => notifier.updateBenefits(sickDays: value),
                ),
              ),
              Expanded(
                child: DigifyTextField(
                  controller: _personalDaysController,
                  labelText: 'Personal Days',
                  isRequired: true,
                  hintText: '3',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => notifier.updateBenefits(personalDays: value),
                ),
              ),
              Expanded(
                child: DigifyTextField(
                  controller: _parentalLeaveController,
                  labelText: 'Parental Leave',
                  isRequired: true,
                  hintText: '12 weeks',
                  onChanged: (value) => notifier.updateBenefits(parentalLeave: value),
                ),
              ),
            ],
          ),
        ),
        Gap(24.h),
        CreateOfferSectionCard(
          title: 'Additional Benefits',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMobile) ...[
                DigifyTextField(
                  controller: _additionalBenefitController,
                  labelText: 'Benefit',
                  isRequired: true,
                  hintText: 'Add a benefit (e.g., Gym Membership)',
                ),
                Gap(12.h),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.primary(
                    label: 'Add',
                    onPressed: () {
                      if (_additionalBenefitController.text.isNotEmpty) {
                        notifier.addAdditionalBenefit(_additionalBenefitController.text);
                        _additionalBenefitController.clear();
                      }
                    },
                  ),
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: DigifyTextField(
                        controller: _additionalBenefitController,
                        labelText: 'Benefit',
                        isRequired: true,
                        hintText: 'Add a benefit (e.g., Gym Membership)',
                      ),
                    ),
                    Gap(12.w),
                    AppButton.primary(
                      label: 'Add',
                      onPressed: () {
                        if (_additionalBenefitController.text.isNotEmpty) {
                          notifier.addAdditionalBenefit(_additionalBenefitController.text);
                          _additionalBenefitController.clear();
                        }
                      },
                    ),
                  ],
                ),
              if (state.additionalBenefits.isNotEmpty) ...[
                Gap(16.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: state.additionalBenefits.map((benefit) {
                    return DigifyCapsule(
                      label: benefit,
                      iconPath: Assets.icons.closeDialogIcon.path,
                      onTap: () => notifier.removeAdditionalBenefit(benefit),
                      borderRadius: 8.r,
                      backgroundColor: AppColors.grayBg,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitToggle({required String label, required bool value, required ValueChanged<bool?> onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.textTheme.titleSmall?.copyWith(color: AppColors.textDarkSlate)),
          DigifyCheckbox(value: value, onChanged: onChanged, size: 20.w),
        ],
      ),
    );
  }
}
