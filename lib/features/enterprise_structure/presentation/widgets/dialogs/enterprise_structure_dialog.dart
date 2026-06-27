import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/enterprise_structure_dialog_widgets/create_enterprise_structure_dialog.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/enterprise_structure_dialog_widgets/create_enterprise_structure_mobile_sheet.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/enterprise_structure_dialog_widgets/edit_enterprise_structure_dialog.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/enterprise_structure_dialog_widgets/edit_enterprise_structure_mobile_sheet.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/enterprise_structure_dialog_widgets/view_enterprise_structure_dialog.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/enterprise_structure_dialog_widgets/view_enterprise_structure_mobile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterpriseStructureDialog {
  EnterpriseStructureDialog._();

  static Future<void> showView(
    BuildContext context, {
    required String structureName,
    required String description,
    int? enterpriseId,
    List<HierarchyLevel>? initialLevels,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return ViewEnterpriseStructureDialog.show(
      context,
      structureName: structureName,
      description: description,
      enterpriseId: enterpriseId,
      initialLevels: initialLevels,
      provider: provider,
    );
  }

  static Future<void> showEdit(
    BuildContext context, {
    required String structureName,
    required String description,
    required List<HierarchyLevel> initialLevels,
    String? structureId,
    bool? isActive,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return EditEnterpriseStructureDialog.show(
      context,
      structureName: structureName,
      description: description,
      initialLevels: initialLevels,
      structureId: structureId,
      isActive: isActive,
      provider: provider,
    );
  }

  static Future<T?> showCreate<T>(
    BuildContext context, {
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return CreateEnterpriseStructureDialog.show<T>(context, provider: provider);
  }

  static Future<bool> showCreateMobile(
    BuildContext context, {
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return CreateEnterpriseStructureMobileSheet.show(context, provider: provider);
  }

  static Future<bool> showEditMobile(
    BuildContext context, {
    required String structureName,
    required String description,
    required List<HierarchyLevel> initialLevels,
    String? structureId,
    bool? isActive,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return EditEnterpriseStructureMobileSheet.show(
      context,
      structureName: structureName,
      description: description,
      initialLevels: initialLevels,
      structureId: structureId,
      isActive: isActive,
      provider: provider,
    );
  }

  static Future<void> showViewMobile(
    BuildContext context, {
    required String structureName,
    required String description,
    int? enterpriseId,
    List<HierarchyLevel>? initialLevels,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return ViewEnterpriseStructureMobileSheet.show(
      context,
      structureName: structureName,
      description: description,
      enterpriseId: enterpriseId,
      initialLevels: initialLevels,
      provider: provider,
    );
  }
}
