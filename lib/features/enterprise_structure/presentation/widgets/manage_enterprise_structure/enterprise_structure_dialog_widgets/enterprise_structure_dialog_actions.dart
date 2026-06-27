import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_enterprise_structure_enterprise_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'enterprise_structure_dialog_providers.dart';

class EnterpriseStructureDialogActions extends ConsumerWidget {
  final EditEnterpriseStructureState? editState;
  final String? structureId;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider;

  const EnterpriseStructureDialogActions({
    super.key,
    required this.editState,
    this.structureId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveState = ref.watch(saveEnterpriseStructureDialogProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.outline(label: 'Cancel', onPressed: saveState.isSaving ? null : () => context.pop()),
        Gap(16.w),
        AppButton.primary(
          label: 'Save Configuration',
          svgPath: Assets.icons.saveConfigIcon.path,
          isLoading: saveState.isSaving,
          onPressed: saveState.isSaving
              ? null
              : () async {
                  final currentEditState = editState;
                  if (currentEditState == null) return;
                  final enterpriseId = ref.read(manageEnterpriseStructureEnterpriseIdProvider);
                  if (enterpriseId == null) {
                    ToastService.error(context, 'Please select an enterprise');
                    return;
                  }
                  if (currentEditState.structureName.trim().isEmpty) {
                    ToastService.error(context, 'Structure name is required');
                    return;
                  }
                  if (currentEditState.levels.isEmpty) {
                    ToastService.error(context, 'At least one level is required');
                    return;
                  }

                  final saveNotifier = ref.read(saveEnterpriseStructureDialogProvider.notifier);
                  try {
                    final success = await saveNotifier.saveStructure(
                      structureName: currentEditState.structureName.trim(),
                      description: currentEditState.description.trim(),
                      levels: currentEditState.levels,
                      enterpriseId: enterpriseId,
                      isActive: currentEditState.isActive,
                      structureId: structureId,
                    );

                    if (!context.mounted) return;
                    if (success) {
                      context.pop(true);
                      ToastService.success(context, 'Structure saved successfully');
                    }
                  } on AppException catch (e) {
                    if (!context.mounted) return;
                    ToastService.error(context, e.message);
                  } catch (e) {
                    if (!context.mounted) return;
                    ToastService.error(context, 'Failed to save structure: ${e.toString()}');
                  }
                },
        ),
      ],
    );
  }
}
