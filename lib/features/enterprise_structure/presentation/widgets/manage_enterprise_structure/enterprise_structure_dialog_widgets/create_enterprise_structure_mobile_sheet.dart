import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_enterprise_structure_enterprise_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'create_form_body.dart';
import 'enterprise_structure_dialog_providers.dart';

class CreateEnterpriseStructureMobileSheet extends ConsumerStatefulWidget {
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider;

  const CreateEnterpriseStructureMobileSheet({super.key, required this.provider});

  static Future<bool> show(
    BuildContext context, {
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) async {
    final localizations = AppLocalizations.of(context)!;
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: localizations.createEnterpriseStructureConfiguration,
      barrierDismissible: false,
      child: ProviderScope(child: CreateEnterpriseStructureMobileSheet(provider: provider)),
    );
    return result == true;
  }

  @override
  ConsumerState<CreateEnterpriseStructureMobileSheet> createState() => _CreateEnterpriseStructureMobileSheetState();
}

class _CreateEnterpriseStructureMobileSheetState extends ConsumerState<CreateEnterpriseStructureMobileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final formState = ref.read(createEnterpriseStructureProvider);
    final enterpriseId = ref.read(manageEnterpriseStructureEnterpriseIdProvider);

    if (enterpriseId == null) {
      ToastService.error(context, 'Please select an enterprise');
      return;
    }
    if (formState.structureName.trim().isEmpty) {
      ToastService.error(context, 'Structure name is required');
      return;
    }
    if (formState.levels.isEmpty) {
      ToastService.error(context, 'At least one level is required');
      return;
    }

    final saveNotifier = ref.read(saveEnterpriseStructureDialogProvider.notifier);
    try {
      final success = await saveNotifier.saveStructure(
        structureName: formState.structureName.trim(),
        description: formState.description.trim(),
        levels: formState.levels,
        enterpriseId: enterpriseId,
        isActive: formState.isActive,
        structureId: null,
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
    final formState = ref.watch(createEnterpriseStructureProvider);
    final formNotifier = ref.read(createEnterpriseStructureProvider.notifier);
    final saveState = ref.watch(saveEnterpriseStructureDialogProvider);

    ref.listen(structureLevelsForCreateProvider, (prev, next) {
      next.whenData((levels) {
        ref.read(createEnterpriseStructureProvider.notifier).setLevelsFromApiOnce(levels);
      });
      next.whenOrNull(
        error: (_, _) => WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) ToastService.error(context, 'Failed to load hierarchy levels');
        }),
      );
    });

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 16.h),
            child: CreateFormBody(
              formState: formState,
              formNotifier: formNotifier,
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
