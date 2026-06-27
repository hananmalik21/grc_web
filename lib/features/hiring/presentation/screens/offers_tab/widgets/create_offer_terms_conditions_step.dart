import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'create_offer_section_card.dart';

class CreateOfferTermsConditionsStep extends ConsumerStatefulWidget {
  const CreateOfferTermsConditionsStep({super.key});

  @override
  ConsumerState<CreateOfferTermsConditionsStep> createState() => _CreateOfferTermsConditionsStepState();
}

class _CreateOfferTermsConditionsStepState extends ConsumerState<CreateOfferTermsConditionsStep> {
  late final TextEditingController _probationPeriodController;
  late final TextEditingController _additionalTermsController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createOfferProvider);
    _probationPeriodController = TextEditingController(text: state.probationPeriod);
    _additionalTermsController = TextEditingController(text: state.additionalTerms);
  }

  @override
  void dispose() {
    _probationPeriodController.dispose();
    _additionalTermsController.dispose();
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
    final state = ref.watch(createOfferProvider);
    final notifier = ref.read(createOfferProvider.notifier);

    return Column(
      children: [
        CreateOfferSectionCard(
          title: 'Employment Terms',
          child: Column(
            children: [
              _buildResponsiveRow(
                context: context,
                children: [
                  DigifyTextField(
                    controller: _probationPeriodController,
                    labelText: 'Probation Period',
                    isRequired: true,
                    hintText: 'e.g., 3 months',
                    onChanged: (value) => notifier.updateTermsAndConditions(probationPeriod: value),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DigifyDateField(
                        label: 'Offer Expiry Date',
                        isRequired: true,
                        hintText: 'dd/mm/yyyy',
                        initialDate: state.offerExpiryDate,
                        firstDate: HiringConfig.createRequisitionDatePickerFirstDate,
                        lastDate: HiringConfig.createRequisitionDatePickerLastDate,
                        onDateSelected: (value) => notifier.updateTermsAndConditions(offerExpiryDate: value),
                      ),
                      Gap(4.h),
                      Text(
                        'Candidate must accept before this date',
                        style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Gap(24.h),
        CreateOfferSectionCard(
          title: 'Pre-Employment Requirements',
          child: Column(
            children: [
              _buildToggleItem(
                label: 'Background Check Required',
                value: state.backgroundCheckRequired,
                onChanged: (value) => notifier.updateTermsAndConditions(backgroundCheckRequired: value),
              ),
              Gap(12.h),
              _buildToggleItem(
                label: 'Drug Test Required',
                value: state.drugTestRequired,
                onChanged: (value) => notifier.updateTermsAndConditions(drugTestRequired: value),
              ),
            ],
          ),
        ),
        Gap(24.h),
        CreateOfferSectionCard(
          title: 'Legal Agreements',
          child: Column(
            children: [
              _buildToggleItem(
                label: 'Non-Disclosure Agreement (NDA)',
                value: state.ndaRequired,
                onChanged: (value) => notifier.updateTermsAndConditions(ndaRequired: value),
              ),
              Gap(12.h),
              _buildToggleItem(
                label: 'Non-Compete Agreement',
                value: state.nonCompeteRequired,
                onChanged: (value) => notifier.updateTermsAndConditions(nonCompeteRequired: value),
              ),
            ],
          ),
        ),
        Gap(24.h),
        CreateOfferSectionCard(
          title: 'Additional Terms & Conditions',
          child: Column(
            children: [
              DigifyTextArea(
                controller: _additionalTermsController,
                labelText: 'Terms & Conditions',
                hintText: 'Enter any additional terms, conditions, or special provisions...',
                maxLines: 8,
                onChanged: (value) => notifier.updateTermsAndConditions(additionalTerms: value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem({required String label, required bool value, required ValueChanged<bool?> onChanged}) {
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
