import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/dialogs/bulk_upload_dialog.dart';
import 'package:grc/features/leave_management/presentation/providers/document_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request/documents_review/document_item.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DocumentsSection extends ConsumerStatefulWidget {
  final NewLeaveRequestState state;
  final NewLeaveRequestNotifier notifier;

  const DocumentsSection({super.key, required this.state, required this.notifier});

  @override
  ConsumerState<DocumentsSection> createState() => _DocumentsSectionState();
}

class _DocumentsSectionState extends ConsumerState<DocumentsSection> {
  Future<void> _pickFiles() async {
    final documentRepository = ref.read(documentRepositoryProvider);
    try {
      final documents = await documentRepository.pickFiles();
      if (!mounted) return;
      if (documents.isNotEmpty) {
        widget.notifier.addDocuments(documents);
        ToastService.success(context, '${documents.length} file(s) uploaded successfully');
      }
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.supportingDocuments,
          style: context.textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
        ),
        Gap(8.h),
        InkWell(
          onTap: _pickFiles,
          borderRadius: BorderRadius.circular(14.r),
          child: SizedBox(
            width: double.infinity,
            child: DashedBorder(
              color: AppColors.borderGrey,
              strokeWidth: 2,
              dashLength: 4,
              gapLength: 4,
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    Container(
                      width: 52.w,
                      height: 52.h,
                      decoration: BoxDecoration(color: AppColors.infoBg, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: DigifyAsset(
                        assetPath: Assets.icons.bulkUploadIconFigma.path,
                        color: AppColors.primary,
                        width: 32,
                        height: 32,
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      localizations.clickToUploadOrDragDrop,
                      style: context.textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
                    ),
                    Gap(4.h),
                    Text(
                      localizations.pdfDocDocxJpgPngUpTo10MB,
                      style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.state.documents.isNotEmpty) ...[
          Gap(16.h),
          UploadedDocumentsList(state: widget.state, notifier: widget.notifier),
        ],
        Gap(8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.warningBg,
            border: Border.all(color: AppColors.warningBorder),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.requiredDocuments,
                style: context.textTheme.labelMedium?.copyWith(color: AppColors.warningText),
              ),
              Gap(4.h),
              Text(
                localizations.supportingDocumentsIfApplicable,
                style: context.textTheme.labelSmall?.copyWith(color: AppColors.yellowSubtitle, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UploadedDocumentsList extends ConsumerWidget {
  final NewLeaveRequestState state;
  final NewLeaveRequestNotifier notifier;

  const UploadedDocumentsList({super.key, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...state.documents.map((document) => DocumentItem(document: document, notifier: notifier))],
    );
  }
}
