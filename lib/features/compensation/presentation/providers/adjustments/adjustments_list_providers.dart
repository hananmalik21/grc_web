import 'package:grc/features/compensation/domain/models/adjustments/adjustments_page.dart';
import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_tab_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_tab_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustmentsListProviders {
  const AdjustmentsListProviders({
    required this.tabProvider,
    required this.dataPageProvider,
    required this.rowsProvider,
    required this.totalItemsProvider,
    required this.totalPagesProvider,
    required this.isLoadingProvider,
    required this.errorProvider,
    required this.showMobileFiltersProvider,
  });

  final NotifierProvider<AdjustmentsTabNotifier, AdjustmentsTabState> tabProvider;
  final AutoDisposeFutureProvider<AdjustmentsPage> dataPageProvider;
  final AutoDisposeProvider<List<AdjustmentRowData>> rowsProvider;
  final AutoDisposeProvider<int> totalItemsProvider;
  final AutoDisposeProvider<int> totalPagesProvider;
  final AutoDisposeProvider<bool> isLoadingProvider;
  final AutoDisposeProvider<String?> errorProvider;
  final StateProvider<bool> showMobileFiltersProvider;
}

final adjustmentsListProviders = AdjustmentsListProviders(
  tabProvider: adjustmentsTabProvider,
  dataPageProvider: adjustmentsDataPageProvider,
  rowsProvider: adjustmentsRowsProvider,
  totalItemsProvider: adjustmentsTotalItemsProvider,
  totalPagesProvider: adjustmentsTotalPagesProvider,
  isLoadingProvider: adjustmentsIsLoadingProvider,
  errorProvider: adjustmentsErrorProvider,
  showMobileFiltersProvider: adjustmentsShowMobileFiltersProvider,
);

final bulkAdjustmentsListProviders = AdjustmentsListProviders(
  tabProvider: bulkAdjustmentsTabProvider,
  dataPageProvider: bulkAdjustmentsDataPageProvider,
  rowsProvider: bulkAdjustmentsRowsProvider,
  totalItemsProvider: bulkAdjustmentsTotalItemsProvider,
  totalPagesProvider: bulkAdjustmentsTotalPagesProvider,
  isLoadingProvider: bulkAdjustmentsIsLoadingProvider,
  errorProvider: bulkAdjustmentsErrorProvider,
  showMobileFiltersProvider: bulkAdjustmentsShowMobileFiltersProvider,
);
