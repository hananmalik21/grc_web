import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_documents_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_editing_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_document_card.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/dialogs/bulk_upload_dialog.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:grc/features/leave_management/presentation/providers/document_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddEmployeeDocumentUploadSection extends ConsumerStatefulWidget {
  const AddEmployeeDocumentUploadSection({super.key});

  @override
  ConsumerState<AddEmployeeDocumentUploadSection> createState() => _AddEmployeeDocumentUploadSectionState();
}

class _AddEmployeeDocumentUploadSectionState extends ConsumerState<AddEmployeeDocumentUploadSection> {
  Future<void> _pickFileForAdd() async {
    final documentRepository = ref.read(documentRepositoryProvider);
    final notifier = ref.read(addEmployeeDocumentsProvider.notifier);
    try {
      final doc = await documentRepository.pickFile();
      if (!mounted) return;
      if (doc != null) {
        notifier.setDocument(doc);
        final state = ref.read(addEmployeeDocumentsProvider);
        if (state.documentTypeCode == null || state.documentTypeCode!.trim().isEmpty) {
          final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider) ?? 0;
          final items = ref
              .read(emplLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: 'DOCUMENT_TYPE')))
              .valueOrNull;
          if (items != null && items.isNotEmpty) {
            notifier.setDocumentTypeCode(items.first.lookupCode);
          }
        }
        ToastService.success(context, 'Document added');
      }
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, e.toString());
    }
  }

  Future<void> _pickFileForReplace(DocumentItem existingDoc) async {
    final documentRepository = ref.read(documentRepositoryProvider);
    final notifier = ref.read(addEmployeeDocumentsProvider.notifier);
    try {
      final doc = await documentRepository.pickFile();
      if (!mounted) return;
      if (doc != null) {
        notifier.setPendingReplace(
          replaceDocumentId: existingDoc.documentId,
          documentTypeCode: existingDoc.documentTypeCode ?? '',
          file: doc,
        );
        ToastService.success(context, 'Document will be replaced on save');
      }
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, e.toString());
    }
  }

  Future<void> _pickFileForAddInEdit(String documentTypeCode) async {
    final documentRepository = ref.read(documentRepositoryProvider);
    final notifier = ref.read(addEmployeeDocumentsProvider.notifier);
    try {
      final doc = await documentRepository.pickFile();
      if (!mounted) return;
      if (doc != null) {
        notifier.setPendingAdd(documentTypeCode: documentTypeCode, file: doc);
        ToastService.success(context, 'Document will be added on save');
      }
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(addEmployeeDocumentsProvider);
    final notifier = ref.read(addEmployeeDocumentsProvider.notifier);
    final isEditing = ref.watch(addEmployeeEditingEmployeeIdProvider) != null;
    final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId == null) {
      return Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: Text(
          localizations.supportingDocuments,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      );
    }
    final documentTypeLookup = ref.watch(
      emplLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: 'DOCUMENT_TYPE')),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.supportingDocuments,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(8.h),
        if (isEditing)
          ..._buildEditModeContent(context, state, notifier, documentTypeLookup, localizations, isDark)
        else
          ..._buildAddModeContent(context, state, notifier, documentTypeLookup, localizations, isDark),
      ],
    );
  }

  List<Widget> _buildEditModeContent(
    BuildContext context,
    AddEmployeeDocumentsState state,
    AddEmployeeDocumentsNotifier notifier,
    AsyncValue<List<EmplLookupValue>> documentTypeLookup,
    AppLocalizations localizations,
    bool isDark,
  ) {
    final list = <Widget>[];

    if (state.existingDocuments.isNotEmpty) {
      list.add(
        Text(
          'Existing documents',
          style: context.textTheme.labelMedium?.copyWith(
            color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
          ),
        ),
      );
      list.add(Gap(8.h));
      for (final doc in state.existingDocuments) {
        final isBeingReplaced =
            state.pendingDocOp?.isReplace == true && state.pendingDocOp?.replaceDocumentId == doc.documentId;
        list.add(
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: _buildExistingDocumentItem(
                    context,
                    doc.documentTypeCode ?? '',
                    doc.fileName ?? 'Document ${doc.documentId}',
                    onReplace: isBeingReplaced ? () => notifier.clearPendingDocOp() : () => _pickFileForReplace(doc),
                    isReplacing: isBeingReplaced,
                  ),
                ),
                if (!isBeingReplaced && state.pendingDocOp == null)
                  TextButton(onPressed: () => _pickFileForReplace(doc), child: Text(localizations.replaceDocument)),
              ],
            ),
          ),
        );
      }
      list.add(Gap(16.h));
    }

    if (state.pendingDocOp != null) {
      list.add(
        _buildUploadedDocumentItem(
          context,
          state.pendingDocOp!.file,
          () => notifier.clearPendingDocOp(),
          subtitle: state.pendingDocOp!.isAdd ? 'Add on save' : 'Replace on save',
        ),
      );
      return list;
    }

    final documentTypeItems = documentTypeLookup.valueOrNull ?? [];
    final effectiveTypeCode = state.documentTypeCode != null && state.documentTypeCode!.trim().isNotEmpty
        ? state.documentTypeCode!.trim()
        : (documentTypeItems.isNotEmpty ? documentTypeItems.first.lookupCode : null);

    list.add(
      Text(
        'Add document',
        style: context.textTheme.labelMedium?.copyWith(
          color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
        ),
      ),
    );
    list.add(Gap(8.h));
    list.add(
      _buildDocumentTypeFieldFromLookup(
        context,
        documentTypeLookup,
        state.documentTypeCode,
        (v) => notifier.setDocumentTypeCode(v?.lookupCode),
        localizations.documentType,
        isRequired: true,
      ),
    );
    list.add(Gap(12.h));
    list.add(
      InkWell(
        onTap: effectiveTypeCode != null ? () => _pickFileForAddInEdit(effectiveTypeCode) : null,
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          width: double.infinity,
          child: DashedBorder(
            color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey,
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
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    localizations.pdfDocDocxJpgPngUpTo10MB,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return list;
  }

  List<Widget> _buildAddModeContent(
    BuildContext context,
    AddEmployeeDocumentsState state,
    AddEmployeeDocumentsNotifier notifier,
    AsyncValue<List<EmplLookupValue>> documentTypeLookup,
    AppLocalizations localizations,
    bool isDark,
  ) {
    final list = <Widget>[
      InkWell(
        onTap: _pickFileForAdd,
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          width: double.infinity,
          child: DashedBorder(
            color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey,
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
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    localizations.pdfDocDocxJpgPngUpTo10MB,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];

    if (state.document != null || state.existingDocumentFileName != null) {
      list.addAll([
        Gap(16.h),
        _buildDocumentTypeFieldFromLookup(
          context,
          documentTypeLookup,
          state.documentTypeCode,
          (v) => notifier.setDocumentTypeCode(v?.lookupCode),
          localizations.documentType,
          isRequired: true,
        ),
        Gap(12.h),
        if (state.document != null)
          _buildUploadedDocumentItem(context, state.document!, () => notifier.setDocument(null))
        else
          _buildExistingDocumentItem(
            context,
            state.documentTypeCode ?? '',
            state.existingDocumentFileName!,
            onReplace: _pickFileForAdd,
          ),
      ]);
    }

    return list;
  }
}

Widget _buildDocumentTypeFieldFromLookup(
  BuildContext context,
  AsyncValue<List<EmplLookupValue>> lookupAsync,
  String? selectedCode,
  ValueChanged<EmplLookupValue?> onChanged,
  String label, {
  bool isRequired = true,
}) {
  final localizations = AppLocalizations.of(context)!;
  final items = lookupAsync.valueOrNull ?? [];
  final isLoading = lookupAsync.isLoading;
  if (!isLoading && items.isEmpty) return const SizedBox.shrink();
  if (lookupAsync.hasError) return const SizedBox.shrink();

  EmplLookupValue? value;
  if (selectedCode != null && selectedCode.trim().isNotEmpty && items.isNotEmpty) {
    try {
      value = items.firstWhere((v) => v.lookupCode == selectedCode);
    } catch (_) {
      value = null;
    }
  } else {
    value = items.isNotEmpty ? items.first : null;
  }

  return DigifySelectFieldWithLabel<EmplLookupValue>(
    label: label,
    isRequired: isRequired,
    hint: isLoading ? localizations.pleaseWait : null,
    items: items,
    itemLabelBuilder: (v) => v.meaningEn,
    value: value,
    onChanged: isLoading ? null : onChanged,
  );
}

Widget _buildUploadedDocumentItem(BuildContext context, Document document, VoidCallback onRemove, {String? subtitle}) {
  return EmployeeDocumentCard(
    title: document.name,
    subtitle: subtitle ?? document.formattedSize,
    icon: Icons.close,
    iconBackgroundColor: AppColors.errorBg,
    iconColor: AppColors.error,
    onTap: onRemove,
  );
}

Widget _buildExistingDocumentItem(
  BuildContext context,
  String documentTypeCode,
  String fileName, {
  required VoidCallback onReplace,
  bool isReplacing = false,
}) {
  final isDark = context.isDark;

  return EmployeeDocumentCard(
    title: fileName,
    subtitle: documentTypeCode,
    icon: isReplacing ? Icons.close : Icons.upload_file,
    iconBackgroundColor: isReplacing
        ? AppColors.errorBg
        : (isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.infoBg),
    iconColor: isReplacing ? AppColors.error : AppColors.primary,
    onTap: onReplace,
  );
}
