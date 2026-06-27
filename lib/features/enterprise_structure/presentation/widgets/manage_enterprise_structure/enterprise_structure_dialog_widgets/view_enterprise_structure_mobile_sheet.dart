import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'view_mode_content.dart';

class ViewEnterpriseStructureMobileSheet extends StatelessWidget {
  final String structureName;
  final String description;
  final List<HierarchyLevel> initialLevels;
  final int? enterpriseId;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider;

  const ViewEnterpriseStructureMobileSheet({
    super.key,
    required this.structureName,
    required this.description,
    this.initialLevels = const [],
    this.enterpriseId,
    required this.provider,
  });

  static Future<void> show(
    BuildContext context, {
    required String structureName,
    required String description,
    int? enterpriseId,
    List<HierarchyLevel>? initialLevels,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: localizations.viewEnterpriseStructureConfiguration,
      child: ViewEnterpriseStructureMobileSheet(
        structureName: structureName,
        description: description,
        enterpriseId: enterpriseId,
        initialLevels: initialLevels ?? const [],
        provider: provider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 24.h),
      child: ViewModeContent(
        localizations: localizations,
        levels: initialLevels,
        structureName: structureName,
        description: description,
      ),
    );
  }
}
