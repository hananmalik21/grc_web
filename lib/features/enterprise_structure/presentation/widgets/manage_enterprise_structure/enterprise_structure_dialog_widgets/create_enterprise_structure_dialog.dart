import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'create_form_body.dart';
import 'enterprise_structure_dialog_actions.dart';
import 'enterprise_structure_dialog_providers.dart';

class CreateEnterpriseStructureDialog extends ConsumerStatefulWidget {
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider;

  const CreateEnterpriseStructureDialog({super.key, required this.provider});

  static Future<T?> show<T>(
    BuildContext context, {
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ProviderScope(child: CreateEnterpriseStructureDialog(provider: provider)),
    );
  }

  @override
  ConsumerState<CreateEnterpriseStructureDialog> createState() => _CreateEnterpriseStructureDialogState();
}

class _CreateEnterpriseStructureDialogState extends ConsumerState<CreateEnterpriseStructureDialog> {
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final formState = ref.watch(createEnterpriseStructureProvider);
    final formNotifier = ref.read(createEnterpriseStructureProvider.notifier);
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

    return AppDialog(
      title: localizations.createEnterpriseStructureConfiguration,
      subtitle: localizations.defineOrganizationalHierarchy,
      width: 900.w,
      onClose: () => context.pop(),
      content: CreateFormBody(
        formState: formState,
        formNotifier: formNotifier,
        nameController: _nameController,
        descriptionController: _descriptionController,
        localizations: localizations,
      ),
      actions: [EnterpriseStructureDialogActions(editState: formState, structureId: null, provider: widget.provider)],
    );
  }
}
