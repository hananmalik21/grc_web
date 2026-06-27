import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/hiring/application/offers/controllers/create_offer_applications_notifier.dart';
import 'package:grc/features/hiring/domain/models/applications/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOfferApplicationSelectionDialog extends ConsumerWidget {
  const CreateOfferApplicationSelectionDialog({super.key, this.selectedApplication});

  final Application? selectedApplication;

  static Future<Application?> show({required BuildContext context, Application? selectedApplication}) {
    return DigifySingleSelectDialog.showAdaptive<Application>(
      context: context,
      child: CreateOfferApplicationSelectionDialog(selectedApplication: selectedApplication),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createOfferApplicationsNotifierProvider);
    final notifier = ref.read(createOfferApplicationsNotifierProvider.notifier);
    final errorMessage = state.hasError ? state.errorMessage : null;

    return DigifySingleSelectDialog<Application>(
      title: 'Application',
      subtitle: 'Select application',
      headerIcon: Icons.description_outlined,
      items: state.items,
      selectedId: selectedApplication?.applicationGuid,
      idBuilder: (application) => application.applicationGuid,
      labelBuilder: (application) => application.applicationNumber,
      descriptionBuilder: (application) => '${application.postingTitle} • ${application.candidateName}',
      searchHint: 'Search applications...',
      emptyMessage: 'No applications found',
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
