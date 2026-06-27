import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/create_adjustment_form_provider.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustment_lookups_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/dialogs/bulk_upload_dialog.dart';
import 'package:grc/features/leave_management/presentation/providers/document_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdditionalInformationSection extends ConsumerWidget {
  const AdditionalInformationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final formState = ref.watch(createAdjustmentFormProvider);
    final formNotifier = ref.read(createAdjustmentFormProvider.notifier);
    final performanceRatingsAsync = ref.watch(performanceRatingLookupProvider);

    final documentUploadView = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supporting Documentation',
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
          ),
        ),
        Gap(8.h),
        InkWell(
          onTap: () async {
            final documentRepository = ref.read(documentRepositoryProvider);
            try {
              final doc = await documentRepository.pickFile();
              if (doc != null) {
                formNotifier.setDocument(doc.path, doc.name, bytes: doc.bytes);
                if (context.mounted) {
                  ToastService.success(context, 'Document added successfully');
                }
              }
            } catch (e) {
              if (context.mounted) {
                ToastService.error(context, e.toString());
              }
            }
          },
          borderRadius: BorderRadius.circular(10.r),
          child: DashedBorder(
            color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey,
            strokeWidth: 2,
            dashLength: 4,
            gapLength: 4,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.all(26.w),
              width: double.infinity,
              child: Column(
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.bulkUploadIconFigma.path,
                    color: AppColors.primary,
                    width: 32.w,
                    height: 32.h,
                  ),
                  Gap(4.h),
                  Text(
                    formState.documentName.isNotEmpty ? formState.documentName : 'Click to upload or drag and drop',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  if (formState.documentName.isEmpty) ...[
                    Text(
                      'PDF, DOC, XLS up to 10MB',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );

    final performanceAndNotesView = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        performanceRatingsAsync.when(
          data: (ratings) => DigifySelectFieldWithLabel<String>(
            label: 'Performance Rating (if applicable)',
            value: ratings.any((e) => e.valueCode == formState.performanceRating) ? formState.performanceRating : null,
            items: ratings.map((e) => e.valueCode).toList(),
            itemLabelBuilder: (code) => ratings.firstWhere((e) => e.valueCode == code).valueName,
            hint: 'Select Performance Rating',
            onChanged: (v) {
              if (v != null) formNotifier.setPerformanceRating(v);
            },
          ),
          loading: () => DigifySelectFieldWithLabel<String>(
            label: 'Performance Rating (if applicable)',
            items: const [],
            itemLabelBuilder: (v) => v,
            hint: 'Loading...',
          ),
          error: (_, _) => DigifySelectFieldWithLabel<String>(
            label: 'Performance Rating (if applicable)',
            items: const [],
            itemLabelBuilder: (v) => v,
            hint: 'Error loading ratings',
          ),
        ),
        Gap(16.h),
        DigifyTextArea(
          labelText: 'Internal Notes',
          hintText: 'Internal notes visible only to HR and approvers...',
          maxLines: 4,
          initialValue: formState.internalNotes,
          onChanged: formNotifier.setInternalNotes,
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.sectionIconSmall.path,
                width: 20.w,
                height: 20.w,
                color: AppColors.primary,
              ),
              Gap(8.w),
              Text(
                'Additional Information',
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 18.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Gap(24.h),
          DigifyTextArea(
            labelText: 'Justification / Business Case',
            isRequired: true,
            hintText:
                'Provide detailed justification for this salary adjustment including performance metrics, market data, retention risk, or other relevant factors...',
            maxLines: 4,
            initialValue: formState.justification,
            onChanged: formNotifier.setJustification,
          ),
          Gap(24.h),
          if (context.isMobileLayout) ...[
            documentUploadView,
            Gap(24.h),
            performanceAndNotesView,
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: documentUploadView),
                Gap(24.w),
                Expanded(child: performanceAndNotesView),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
