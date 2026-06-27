import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_tab_provider.dart';
import 'package:grc/features/payroll/presentation/screens/element_entries/mixins/element_entries_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ElementEntriesHeaderActions extends ConsumerWidget with ElementEntriesPermissionMixin {
  const ElementEntriesHeaderActions({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    if (compact) {
      return Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        alignment: WrapAlignment.end,
        children: [
          if (canCreateElementEntry)
            AppMobileButton.primary(
              svgPath: Assets.icons.addDivisionIcon.path,
              onPressed: () => _onAddElement(context),
            ),
          if (canUpdateElementEntries) ...[
            AppMobileButton.outline(svgPath: Assets.icons.uploadProcessIcon.path, onPressed: () => _onUpload(context)),
            AppMobileButton.outline(
              svgPath: Assets.icons.downloadTemplateIcon.path,
              onPressed: () => _onExport(context),
            ),
          ],
          AppMobileButton.outline(
            svgPath: Assets.icons.closeIcon.path,
            onPressed: () => ref.read(elementEntriesTabProvider.notifier).clearSelectedEmployee(),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (canCreateElementEntry)
          AppButton.primary(
            label: loc.payrollElementEntriesAddElement,
            svgPath: Assets.icons.addDivisionIcon.path,
            onPressed: () => _onAddElement(context),
          ),
        if (canUpdateElementEntries) ...[
          AppButton.outline(
            label: loc.payrollElementEntriesUpload,
            svgPath: Assets.icons.uploadProcessIcon.path,
            onPressed: () => _onUpload(context),
          ),
          AppButton.outline(
            label: loc.payrollElementEntriesExport,
            svgPath: Assets.icons.downloadTemplateIcon.path,
            onPressed: () => _onExport(context),
          ),
        ],
        AppMobileButton.outline(
          svgPath: Assets.icons.closeIcon.path,
          onPressed: () => ref.read(elementEntriesTabProvider.notifier).clearSelectedEmployee(),
        ),
      ],
    );
  }

  void _onAddElement(BuildContext context) {
    context.push(AppRoutes.payrollAddElement);
  }

  void _onUpload(BuildContext context) {
    ToastService.info(context, AppLocalizations.of(context)!.payrollElementEntriesUpload);
  }

  void _onExport(BuildContext context) {
    ToastService.info(context, AppLocalizations.of(context)!.payrollElementEntriesExport);
  }
}
