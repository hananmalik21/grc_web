import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/hiring/application/applications/config/applications_list_config.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_api_providers.dart';
import 'package:grc/features/hiring/application/offers/providers/offers_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/domain/models/applications/application.dart';
import 'package:grc/features/hiring/domain/usecases/get_applications_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOfferApplicationsNotifier extends StateNotifier<PaginationState<Application>>
    with PaginationMixin<Application> {
  CreateOfferApplicationsNotifier({required GetApplicationsUseCase getApplicationsUseCase, required this.enterpriseId})
    : _getApplicationsUseCase = getApplicationsUseCase,
      super(const PaginationState(pageSize: ApplicationsListConfig.pageSize));

  final GetApplicationsUseCase _getApplicationsUseCase;
  final int? enterpriseId;

  Future<void> loadFirstPage() async {
    await _loadPage(1);
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || state.isLoading) return;
    await _loadPage(page);
  }

  Future<void> _loadPage(int page) async {
    final resolvedEnterpriseId = enterpriseId;

    if (resolvedEnterpriseId == null || resolvedEnterpriseId <= 0) {
      state = const PaginationState(pageSize: ApplicationsListConfig.pageSize);
      return;
    }

    state = handleLoadingState(state, true);

    try {
      final response = await _getApplicationsUseCase(
        enterpriseId: resolvedEnterpriseId,
        page: page,
        limit: state.pageSize,
      );

      final pagination = response.pagination;

      state = handleSuccessState(
        currentState: state,
        newItems: response.items,
        currentPage: pagination?.page ?? page,
        pageSize: pagination?.pageSize ?? state.pageSize,
        totalItems: pagination?.total ?? response.items.length,
        totalPages: pagination?.totalPages ?? 1,
        hasNextPage: pagination?.hasNext ?? false,
        hasPreviousPage: pagination?.hasPrevious ?? false,
        isFirstPage: true,
      );
    } on AppException catch (e) {
      state = handleErrorState(state, e.message);
    } catch (_) {
      state = handleErrorState(state, 'Failed to load applications. Please try again.');
    }
  }
}

final createOfferApplicationsNotifierProvider =
    StateNotifierProvider.autoDispose<CreateOfferApplicationsNotifier, PaginationState<Application>>((ref) {
      final notifier = CreateOfferApplicationsNotifier(
        getApplicationsUseCase: ref.watch(getApplicationsUseCaseProvider),
        enterpriseId: ref.watch(offersTabEnterpriseIdProvider),
      );
      Future.microtask(notifier.loadFirstPage);
      return notifier;
    });
