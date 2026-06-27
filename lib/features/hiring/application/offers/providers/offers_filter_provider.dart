import 'package:grc/core/services/debouncer.dart';
import 'package:grc/features/hiring/application/offers/config/offers_list_config.dart';
import 'package:grc/features/hiring/application/offers/providers/offers_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OffersFilterState {
  const OffersFilterState({this.searchQuery = '', this.status});

  final String searchQuery;
  final String? status;

  OffersFilterState copyWith({String? searchQuery, String? status, bool clearStatus = false}) {
    return OffersFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  bool get hasActiveFilters => status != null;
}

class OffersFilterNotifier extends Notifier<OffersFilterState> {
  final _debouncer = Debouncer();

  @override
  OffersFilterState build() {
    ref.onDispose(_debouncer.dispose);
    return const OffersFilterState();
  }

  void setSearch(String query) {
    _debouncer.run(() {
      ref.read(offersCurrentPageProvider.notifier).state = offersDefaultPage;
      state = state.copyWith(searchQuery: query);
    });
  }

  void setStatus(String? value) {
    ref.read(offersCurrentPageProvider.notifier).state = offersDefaultPage;
    state = value == null ? state.copyWith(clearStatus: true) : state.copyWith(status: value);
  }

  void reset() {
    ref.read(offersCurrentPageProvider.notifier).state = offersDefaultPage;
    state = const OffersFilterState();
  }
}

final offersFilterProvider = NotifierProvider<OffersFilterNotifier, OffersFilterState>(OffersFilterNotifier.new);
