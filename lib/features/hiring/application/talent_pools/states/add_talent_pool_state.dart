import 'package:grc/features/hiring/application/talent_pools/add_talent_pool_args.dart';
import 'package:grc/features/hiring/domain/models/talent_pools/talent_pool.dart';

class AddTalentPoolState {
  const AddTalentPoolState({
    required this.candidateGuid,
    this.pools = const [],
    this.selectedPoolGuids = const {},
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.pageSize = 10,
    this.hasNext = false,
    this.hasPrevious = false,
    this.isLoading = false,
    this.loadError,
    this.newPoolName = '',
    this.isCreatingPool = false,
    this.createPoolError,
    this.isAssigningPools = false,
    this.assignPoolsError,
  });

  final String candidateGuid;
  final List<TalentPool> pools;
  final Set<String> selectedPoolGuids;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;
  final bool isLoading;
  final String? loadError;
  final String newPoolName;
  final bool isCreatingPool;
  final String? createPoolError;
  final bool isAssigningPools;
  final String? assignPoolsError;

  AddTalentPoolState copyWith({
    String? candidateGuid,
    List<TalentPool>? pools,
    Set<String>? selectedPoolGuids,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? pageSize,
    bool? hasNext,
    bool? hasPrevious,
    bool? isLoading,
    String? loadError,
    bool clearLoadError = false,
    String? newPoolName,
    bool? isCreatingPool,
    String? createPoolError,
    bool clearCreatePoolError = false,
    bool? isAssigningPools,
    String? assignPoolsError,
    bool clearAssignPoolsError = false,
  }) {
    return AddTalentPoolState(
      candidateGuid: candidateGuid ?? this.candidateGuid,
      pools: pools ?? this.pools,
      selectedPoolGuids: selectedPoolGuids ?? this.selectedPoolGuids,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      pageSize: pageSize ?? this.pageSize,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      isLoading: isLoading ?? this.isLoading,
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
      newPoolName: newPoolName ?? this.newPoolName,
      isCreatingPool: isCreatingPool ?? this.isCreatingPool,
      createPoolError: clearCreatePoolError ? null : (createPoolError ?? this.createPoolError),
      isAssigningPools: isAssigningPools ?? this.isAssigningPools,
      assignPoolsError: clearAssignPoolsError ? null : (assignPoolsError ?? this.assignPoolsError),
    );
  }

  bool isPoolSelected(String poolGuid) {
    return selectedPoolGuids.contains(normalizeTalentPoolGuid(poolGuid));
  }
}
