import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/data/datasources/time_zone_remote_datasource.dart';
import 'package:grc/features/time_management/domain/models/time_zone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _timeZoneApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final timeZoneRemoteDataSourceProvider = Provider<TimeZoneRemoteDataSource>((ref) {
  return TimeZoneRemoteDataSourceImpl(apiClient: ref.watch(_timeZoneApiClientProvider));
});

class TimeZoneState {
  final List<TimeZone> timeZones;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final int currentPage;
  final int pageSize;
  final int total;
  final bool hasMore;
  final String? searchQuery;

  const TimeZoneState({
    this.timeZones = const [],
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.currentPage = 1,
    this.pageSize = 25,
    this.total = 0,
    this.hasMore = false,
    this.searchQuery,
  });

  TimeZoneState copyWith({
    List<TimeZone>? timeZones,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    int? currentPage,
    int? pageSize,
    int? total,
    bool? hasMore,
    String? searchQuery,
    bool clearTimeZones = false,
  }) {
    return TimeZoneState(
      timeZones: clearTimeZones ? [] : (timeZones ?? this.timeZones),
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TimeZoneNotifier extends StateNotifier<TimeZoneState> {
  final TimeZoneRemoteDataSource dataSource;

  TimeZoneNotifier({required this.dataSource}) : super(const TimeZoneState());

  Future<void> loadTimeZones({String? name, int page = 1, bool append = false}) async {
    if (!append) {
      state = state.copyWith(isLoading: true, hasError: false, errorMessage: null, clearTimeZones: true);
    }

    try {
      final result = await dataSource.getTimeZones(name: name, page: page, pageSize: state.pageSize);

      final timeZones = result.data.map((dto) => TimeZone(tzName: dto.tzName)).toList();
      state = state.copyWith(
        timeZones: append ? [...state.timeZones, ...timeZones] : timeZones,
        isLoading: false,
        hasError: false,
        currentPage: result.meta.pagination.page,
        total: result.meta.pagination.total,
        hasMore: result.meta.pagination.hasMore,
        searchQuery: name,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load time zones: ${e.toString()}',
      );
    }
  }

  Future<void> searchTimeZones({String? name}) async {
    await loadTimeZones(name: name, page: 1);
  }

  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isLoading) return;
    await loadTimeZones(name: state.searchQuery, page: state.currentPage + 1, append: true);
  }
}

final timeZoneNotifierProvider = StateNotifierProvider<TimeZoneNotifier, TimeZoneState>((ref) {
  return TimeZoneNotifier(dataSource: ref.watch(timeZoneRemoteDataSourceProvider));
});
