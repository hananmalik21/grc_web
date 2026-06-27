import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_enterprise_structure_enterprise_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'edit_form_body.dart';
import 'enterprise_structure_dialog_providers.dart';

class EditEnterpriseStructureMobileSheet extends ConsumerStatefulWidget {
  final String structureName;
  final String description;
  final List<HierarchyLevel> initialLevels;
  final String? structureId;
  final bool? isActive;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider;

  const EditEnterpriseStructureMobileSheet({
    super.key,
    required this.structureName,
    required this.description,
    required this.initialLevels,
    this.structureId,
    this.isActive,
    required this.provider,
  });

  static Future<bool> show(
    BuildContext context, {
    required String structureName,
    required String description,
    required List<HierarchyLevel> initialLevels,
    String? structureId,
    bool? isActive,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) async {
    final localizations = AppLocalizations.of(context)!;
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: localizations.editEnterpriseStructureConfiguration,
      barrierDismissible: false,
      child: ProviderScope(
        child: EditEnterpriseStructureMobileSheet(
          structureName: structureName,
          description: description,
          initialLevels: initialLevels,
          structureId: structureId,
          isActive: isActive,
          provider: provider,
        ),
      ),
    );
    return result == true;
  }

  @override
  ConsumerState<EditEnterpriseStructureMobileSheet> createState() => _EditEnterpriseStructureMobileSheetState();
}

class _EditEnterpriseStructureMobileSheetState extends ConsumerState<EditEnterpriseStructureMobileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final EditDialogParams _params;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.structureName);
    _descriptionController = TextEditingController(text: widget.description);
    _params = EditDialogParams(
      structureName: widget.structureName,
      description: widget.description,
      initialLevels: widget.initialLevels,
      isActive: widget.isActive ?? true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final editNotifier = ref.read(editEnterpriseStructureDialogProvider(_params).notifier);
      editNotifier.setLevels(widget.initialLevels);
      if (widget.isActive != null) {
        editNotifier.updateIsActive(widget.isActive!);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final editState = ref.read(editEnterpriseStructureDialogProvider(_params));
    final enterpriseId = ref.read(manageEnterpriseStructureEnterpriseIdProvider);

    if (enterpriseId == null) {
      ToastService.error(context, 'Please select an enterprise');
      return;
    }
    if (editState.structureName.trim().isEmpty) {
      ToastService.error(context, 'Structure name is required');
      return;
    }
    if (editState.levels.isEmpty) {
      ToastService.error(context, 'At least one level is required');
      return;
    }

    final saveNotifier = ref.read(saveEnterpriseStructureDialogProvider.notifier);
    try {
      final success = await saveNotifier.saveStructure(
        structureName: editState.structureName.trim(),
        description: editState.description.trim(),
        levels: editState.levels,
        enterpriseId: enterpriseId,
        isActive: editState.isActive,
        structureId: widget.structureId,
      );

      if (!mounted) return;
      if (success) {
        Navigator.of(context).pop(true);
        ToastService.success(context, 'Structure saved successfully');
      }
    } on AppException catch (e) {
      if (!mounted) return;
      ToastService.error(context, e.message);
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to save structure: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final editState = ref.watch(editEnterpriseStructureDialogProvider(_params));
    final saveState = ref.watch(saveEnterpriseStructureDialogProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 16.h),
            child: EditFormBody(
              editState: editState,
              params: _params,
              nameController: _nameController,
              descriptionController: _descriptionController,
              localizations: localizations,
            ),
          ),
        ),
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
          child: Row(
            children: [
              AppButton.outline(
                label: 'Cancel',
                onPressed: saveState.isSaving ? null : () => Navigator.of(context).pop(false),
              ),
              Gap(12.w),
              Expanded(
                child: AppButton.primary(
                  label: 'Save Configuration',
                  isLoading: saveState.isSaving,
                  onPressed: saveState.isSaving ? null : _onSave,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
