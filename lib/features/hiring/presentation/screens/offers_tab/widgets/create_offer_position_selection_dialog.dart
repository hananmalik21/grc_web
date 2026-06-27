import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOfferPositionSelectionDialog extends ConsumerWidget {
  const CreateOfferPositionSelectionDialog({super.key, this.selectedPosition});

  final Position? selectedPosition;

  static Future<Position?> show({required BuildContext context, Position? selectedPosition}) {
    return DigifySingleSelectDialog.showAdaptive<Position>(
      context: context,
      child: CreateOfferPositionSelectionDialog(selectedPosition: selectedPosition),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createOfferPositionNotifierProvider);
    final notifier = ref.read(createOfferPositionNotifierProvider.notifier);
    final errorMessage = state.hasError ? state.errorMessage : null;

    return DigifySingleSelectDialog<Position>(
      title: 'Job Title',
      subtitle: 'Select position',
      headerIcon: Icons.badge_rounded,
      items: state.items,
      selectedId: selectedPosition?.id,
      idBuilder: (position) => position.id,
      labelBuilder: (position) => position.titleEnglish,
      descriptionBuilder: (position) => position.code,
      searchHint: 'Search positions...',
      emptyMessage: 'No positions found',
      isLoading: state.isLoading,
      errorMessage: errorMessage,
      onRetry: () => notifier.loadFirstPage(),
      pagination: DigifySingleSelectPagination(
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        totalItems: state.totalItems,
        pageSize: state.pageSize,
        hasNext: state.hasNextPage,
        hasPrevious: state.hasPreviousPage,
      ),
      onPreviousPage: state.hasPreviousPage ? () => notifier.goToPage(state.currentPage - 1) : null,
      onNextPage: state.hasNextPage ? () => notifier.goToPage(state.currentPage + 1) : null,
      onPageTap: (page) => notifier.goToPage(page),
    );
  }
}
