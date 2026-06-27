import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'edit_form_body.dart';
import 'enterprise_structure_dialog_actions.dart';
import 'enterprise_structure_dialog_providers.dart';

class EditEnterpriseStructureDialog extends ConsumerStatefulWidget {
  final String structureName;
  final String description;
  final List<HierarchyLevel> initialLevels;
  final String? structureId;
  final bool? isActive;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider;

  const EditEnterpriseStructureDialog({
    super.key,
    required this.structureName,
    required this.description,
    required this.initialLevels,
    this.structureId,
    this.isActive,
    required this.provider,
  });

  static Future<void> show(
    BuildContext context, {
    required String structureName,
    required String description,
    required List<HierarchyLevel> initialLevels,
    String? structureId,
    bool? isActive,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ProviderScope(
        child: EditEnterpriseStructureDialog(
          structureName: structureName,
          description: description,
          initialLevels: initialLevels,
          structureId: structureId,
          isActive: isActive,
          provider: provider,
        ),
      ),
    );
  }

  @override
  ConsumerState<EditEnterpriseStructureDialog> createState() => _EditEnterpriseStructureDialogState();
}

class _EditEnterpriseStructureDialogState extends ConsumerState<EditEnterpriseStructureDialog> {
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final editState = ref.watch(editEnterpriseStructureDialogProvider(_params));

    return AppDialog(
      title: localizations.editEnterpriseStructureConfiguration,
      subtitle: localizations.defineOrganizationalHierarchy,
      width: 900.w,
      onClose: () => context.pop(),
      content: EditFormBody(
        editState: editState,
        params: _params,
        nameController: _nameController,
        descriptionController: _descriptionController,
        localizations: localizations,
      ),
      actions: [
        EnterpriseStructureDialogActions(
          editState: editState,
          structureId: widget.structureId,
          provider: widget.provider,
        ),
      ],
    );
  }
}
