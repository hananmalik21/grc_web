import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_tab_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_table_selection_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_form_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_metadata_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/create_bulk_adjustment_submit_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_employee_components_provider.dart';
import 'package:grc/features/compensation/presentation/mappers/bulk_adjustment_request_mapper.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/bulk_adjustments_desktop_layout.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/bulk_adjustments_mobile_layout.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/bulk_adjustments_permission_mixin.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/bulk_adjustments_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BulkAdjustmentsTab extends ConsumerStatefulWidget {
  const BulkAdjustmentsTab({super.key});

  @override
  ConsumerState<BulkAdjustmentsTab> createState() => _BulkAdjustmentsTabState();
}

class _BulkAdjustmentsTabState extends ConsumerState<BulkAdjustmentsTab> with BulkAdjustmentsPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(bulkAdjustmentsDataPageProvider);
      ref.read(bulkAdjustmentsTableSelectionProvider.notifier).clear();
      ref.read(bulkEmployeeComponentsSyncKeyProvider.notifier).state = null;
      ref.read(bulkAdjustmentsFormProvider.notifier).reset();
      ref.read(bulkAdjustmentsMetadataProvider.notifier).reset();
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(bulkAdjustmentsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  Future<void> _onCreatePressed() async {
    final localizations = AppLocalizations.of(context)!;
    final metadataNotifier = ref.read(bulkAdjustmentsMetadataProvider.notifier);
    final metadataError = metadataNotifier.firstValidationError();
    if (metadataError != null) {
      ToastService.error(context, metadataError);
      return;
    }

    final formState = ref.read(bulkAdjustmentsFormProvider);
    if (!bulkAdjustmentFormHasSubmittableChanges(formState)) {
      ToastService.error(context, localizations.bulkAdjustmentsSubmitNoChanges);
      return;
    }

    try {
      await ref.read(createBulkAdjustmentSubmitProvider.notifier).submit();
      if (!mounted) return;

      ref.invalidate(bulkAdjustmentsDataPageProvider);
      ref.invalidate(bulkEmployeeComponentsProvider);
      ref.read(bulkAdjustmentsTableSelectionProvider.notifier).clear();
      ref.read(bulkEmployeeComponentsSyncKeyProvider.notifier).state = null;
      ref.read(bulkAdjustmentsFormProvider.notifier).reset();
      ref.read(bulkAdjustmentsMetadataProvider.notifier).reset();

      ToastService.success(context, localizations.bulkAdjustmentsSubmitSuccess);
    } catch (error) {
      if (!mounted) return;
      final message = error is AppException ? error.message : error.toString();
      ToastService.error(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int?>(bulkAdjustmentsTabEnterpriseIdProvider, (previous, next) {
      if (previous != next) {
        ref.read(bulkAdjustmentsTableSelectionProvider.notifier).clear();
        ref.read(bulkEmployeeComponentsPageIndexProvider.notifier).state = 1;
        ref.read(bulkEmployeeComponentsSyncKeyProvider.notifier).state = null;
        ref.read(bulkAdjustmentsFormProvider.notifier).reset();
        ref.read(bulkAdjustmentsMetadataProvider.notifier).reset();
      }
    });
    ref.listen(bulkAdjustmentsTabProvider.select((state) => state.currentPage), (previous, next) {
      if (previous != next) {
        ref.read(bulkAdjustmentsTableSelectionProvider.notifier).clear();
        ref.read(bulkEmployeeComponentsPageIndexProvider.notifier).state = 1;
        ref.read(bulkEmployeeComponentsSyncKeyProvider.notifier).state = null;
        ref.read(bulkAdjustmentsFormProvider.notifier).reset();
        ref.read(bulkAdjustmentsMetadataProvider.notifier).reset();
      }
    });
    ref.listen(bulkAdjustmentsTableSelectionProvider, (previous, next) {
      if (previous?.entries.keys.toSet() == next.entries.keys.toSet()) return;

      ref.read(bulkEmployeeComponentsPageIndexProvider.notifier).state = 1;
      ref.read(bulkEmployeeComponentsSyncKeyProvider.notifier).state = null;
      ref.read(bulkAdjustmentsFormProvider.notifier).reset();
      ref.invalidate(bulkEmployeeComponentsProvider);
      if (next.isEmpty) {
        ref.read(bulkAdjustmentsMetadataProvider.notifier).reset();
      }
    });

    if (!canViewBulkAdjustments) return const AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(bulkAdjustmentsTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return BulkAdjustmentsMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
      );
    }

    if (layout.isTablet) {
      return BulkAdjustmentsTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
      );
    }

    return BulkAdjustmentsDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreatePressed: _onCreatePressed,
    );
  }
}
