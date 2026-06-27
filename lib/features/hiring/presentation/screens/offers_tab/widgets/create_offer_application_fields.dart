import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/hiring/application/offers/controllers/create_offer_applications_notifier.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_provider.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_application_details_panel.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_application_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateOfferApplicationFields extends ConsumerWidget {
  const CreateOfferApplicationFields({super.key});

  String? _selectionLabel(String? applicationNumber, String? postingTitle) {
    if (applicationNumber == null || applicationNumber.isEmpty) return null;
    if (postingTitle == null || postingTitle.isEmpty) return applicationNumber;
    return '$applicationNumber • $postingTitle';
  }

  Future<void> _openSelectionDialog(BuildContext context, WidgetRef ref) async {
    final selectedApplication = ref.read(createOfferProvider.select((state) => state.selectedApplication));
    final selected = await CreateOfferApplicationSelectionDialog.show(
      context: context,
      selectedApplication: selectedApplication,
    );

    if (selected != null && context.mounted) {
      ref.read(createOfferProvider.notifier).setSelectedApplication(selected);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final selectedApplication = ref.watch(createOfferProvider.select((state) => state.selectedApplication));

    ref.watch(createOfferApplicationsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifySelectionFieldWithLabel(
          label: 'Application',
          hint: 'Select application',
          isRequired: true,
          value: _selectionLabel(selectedApplication?.applicationNumber, selectedApplication?.postingTitle),
          onTap: () => _openSelectionDialog(context, ref),
        ),
        if (selectedApplication == null) ...[
          Gap(12.h),
          Text(
            'Select an application to link this offer to the hiring pipeline.',
            style: context.textTheme.bodySmall?.copyWith(color: secondaryText),
          ),
        ] else ...[
          Gap(20.h),
          CreateOfferApplicationDetailsPanel(application: selectedApplication),
        ],
      ],
    );
  }
}
