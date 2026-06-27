import 'package:grc/core/enums/position_status.dart';
import 'package:grc/features/time_management/domain/models/assignment_level.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/time_management/data/datasources/schedule_assignment_remote_datasource.dart';
import 'package:grc/features/time_management/data/repositories/schedule_assignment_repository_impl.dart';
import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/domain/repositories/schedule_assignment_repository.dart';
import 'package:grc/features/time_management/domain/usecases/create_schedule_assignment_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/delete_schedule_assignment_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/get_schedule_assignments_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/update_schedule_assignment_usecase.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleAssignmentApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final scheduleAssignmentRemoteDataSourceProvider = Provider<ScheduleAssignmentRemoteDataSource>((ref) {
  final apiClient = ref.watch(scheduleAssignmentApiClientProvider);
  return ScheduleAssignmentRemoteDataSourceImpl(apiClient: apiClient);
});

final scheduleAssignmentRepositoryProvider = Provider.family<ScheduleAssignmentRepository, int>((ref, enterpriseId) {
  final remoteDataSource = ref.watch(scheduleAssignmentRemoteDataSourceProvider);
  return ScheduleAssignmentRepositoryImpl(remoteDataSource: remoteDataSource, tenantId: enterpriseId);
});

final getScheduleAssignmentsUseCaseProvider = Provider.family<GetScheduleAssignmentsUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(scheduleAssignmentRepositoryProvider(enterpriseId));
  return GetScheduleAssignmentsUseCase(repository: repository);
});

final createScheduleAssignmentUseCaseProvider = Provider.family<CreateScheduleAssignmentUseCase, int>((
  ref,
  enterpriseId,
) {
  final repository = ref.watch(scheduleAssignmentRepositoryProvider(enterpriseId));
  return CreateScheduleAssignmentUseCase(repository: repository);
});

final updateScheduleAssignmentUseCaseProvider = Provider.family<UpdateScheduleAssignmentUseCase, int>((
  ref,
  enterpriseId,
) {
  final repository = ref.watch(scheduleAssignmentRepositoryProvider(enterpriseId));
  return UpdateScheduleAssignmentUseCase(repository: repository);
});

final deleteScheduleAssignmentUseCaseProvider = Provider.family<DeleteScheduleAssignmentUseCase, int>((
  ref,
  enterpriseId,
) {
  final repository = ref.watch(scheduleAssignmentRepositoryProvider(enterpriseId));
  return DeleteScheduleAssignmentUseCase(repository: repository);
});

class ScheduleAssignmentState extends PaginationState<ScheduleAssignment> {
  final int? deletingAssignmentId;
  final bool isCreating;

  const ScheduleAssignmentState({
    super.items = const [],
    super.isLoading = false,
    super.isLoadingMore = false,
    super.hasError = false,
    super.errorMessage,
    super.currentPage = 1,
    super.pageSize = 10,
    super.totalItems = 0,
    super.totalPages = 0,
    super.hasNextPage = false,
    super.hasPreviousPage = false,
    super.searchQuery,
    super.status,
    this.deletingAssignmentId,
    this.isCreating = false,
  });

  @override
  ScheduleAssignmentState copyWith({
    List<ScheduleAssignment>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    String? errorMessage,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    String? searchQuery,
    PositionStatus? status,
    bool clearStatus = false,
    int? deletingAssignmentId,
    bool clearDeletingAssignmentId = false,
    bool? isCreating,
  }) {
    return ScheduleAssignmentState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      searchQuery: searchQuery ?? this.searchQuery,
      status: clearStatus ? null : (status ?? this.status),
      deletingAssignmentId: clearDeletingAssignmentId ? null : (deletingAssignmentId ?? this.deletingAssignmentId),
      isCreating: isCreating ?? this.isCreating,
    );
  }
}

final scheduleAssignmentsNotifierProvider =
    StateNotifierProvider.family<ScheduleAssignmentsNotifier, ScheduleAssignmentState, int>((ref, enterpriseId) {
      return ScheduleAssignmentsNotifier(
        ref.read(getScheduleAssignmentsUseCaseProvider(enterpriseId)),
        ref.read(createScheduleAssignmentUseCaseProvider(enterpriseId)),
        ref.read(updateScheduleAssignmentUseCaseProvider(enterpriseId)),
        ref.read(deleteScheduleAssignmentUseCaseProvider(enterpriseId)),
      );
    });

class ScheduleAssignmentsNotifier extends StateNotifier<ScheduleAssignmentState>
    with PaginationMixin<ScheduleAssignment>
    implements PaginationController<ScheduleAssignment> {
  final GetScheduleAssignmentsUseCase _getScheduleAssignmentsUseCase;
  final CreateScheduleAssignmentUseCase _createScheduleAssignmentUseCase;
  final UpdateScheduleAssignmentUseCase _updateScheduleAssignmentUseCase;
  final DeleteScheduleAssignmentUseCase _deleteScheduleAssignmentUseCase;
  int? _currentEnterpriseId;

  ScheduleAssignmentsNotifier(
    this._getScheduleAssignmentsUseCase,
    this._createScheduleAssignmentUseCase,
    this._updateScheduleAssignmentUseCase,
    this._deleteScheduleAssignmentUseCase,
  ) : super(const ScheduleAssignmentState());

  void setEnterpriseId(int enterpriseId) {
    if (_currentEnterpriseId != enterpriseId) {
      _currentEnterpriseId = enterpriseId;
      reset();
      loadFirstPage();
    }
  }

  @override
  Future<void> loadFirstPage() async {
    if (_currentEnterpriseId == null) return;

    final loadingState = handleLoadingState(state, true);
    state = ScheduleAssignmentState(
      items: loadingState.items,
      isLoading: loadingState.isLoading,
      isLoadingMore: loadingState.isLoadingMore,
      hasError: loadingState.hasError,
      errorMessage: loadingState.errorMessage,
      currentPage: loadingState.currentPage,
      pageSize: loadingState.pageSize,
      totalItems: loadingState.totalItems,
      totalPages: loadingState.totalPages,
      hasNextPage: loadingState.hasNextPage,
      hasPreviousPage: loadingState.hasPreviousPage,
      deletingAssignmentId: state.deletingAssignmentId,
      isCreating: state.isCreating,
    );

    try {
      final result = await _getScheduleAssignmentsUseCase.call(
        tenantId: _currentEnterpriseId!,
        page: 1,
        pageSize: state.pageSize,
      );

      final newState = handleSuccessState(
        currentState: state,
        newItems: result.scheduleAssignments,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.pagination.totalItems,
        totalPages: result.pagination.totalPages,
        hasNextPage: result.pagination.hasNext,
        hasPreviousPage: result.pagination.hasPrevious,
        isFirstPage: true,
      );
      state = ScheduleAssignmentState(
        items: newState.items,
        isLoading: newState.isLoading,
        isLoadingMore: newState.isLoadingMore,
        hasError: newState.hasError,
        errorMessage: newState.errorMessage,
        currentPage: newState.currentPage,
        pageSize: newState.pageSize,
        totalItems: newState.totalItems,
        totalPages: newState.totalPages,
        hasNextPage: newState.hasNextPage,
        hasPreviousPage: newState.hasPreviousPage,
        deletingAssignmentId: state.deletingAssignmentId,
        isCreating: state.isCreating,
      );
    } catch (e) {
      final errorState = handleErrorState(state, e.toString());
      state = ScheduleAssignmentState(
        items: errorState.items,
        isLoading: errorState.isLoading,
        isLoadingMore: errorState.isLoadingMore,
        hasError: errorState.hasError,
        errorMessage: errorState.errorMessage,
        currentPage: errorState.currentPage,
        pageSize: errorState.pageSize,
        totalItems: errorState.totalItems,
        totalPages: errorState.totalPages,
        hasNextPage: errorState.hasNextPage,
        hasPreviousPage: errorState.hasPreviousPage,
        deletingAssignmentId: state.deletingAssignmentId,
        isCreating: state.isCreating,
      );
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (_currentEnterpriseId == null || state.isLoadingMore || !state.hasNextPage) {
      return;
    }
    await goToPage(state.currentPage + 1);
  }

  Future<void> goToPage(int page) async {
    if (_currentEnterpriseId == null ||
        state.isLoadingMore ||
        (page < 1 || page > state.totalPages && state.totalPages > 0)) {
      return;
    }

    final loadingState = handleLoadingState(state, false);
    state = ScheduleAssignmentState(
      items: loadingState.items,
      isLoading: loadingState.isLoading,
      isLoadingMore: loadingState.isLoadingMore,
      hasError: loadingState.hasError,
      errorMessage: loadingState.errorMessage,
      currentPage: loadingState.currentPage,
      pageSize: loadingState.pageSize,
      totalItems: loadingState.totalItems,
      totalPages: loadingState.totalPages,
      hasNextPage: loadingState.hasNextPage,
      hasPreviousPage: loadingState.hasPreviousPage,
      deletingAssignmentId: state.deletingAssignmentId,
      isCreating: state.isCreating,
    );

    try {
      final result = await _getScheduleAssignmentsUseCase.call(
        tenantId: _currentEnterpriseId!,
        page: page,
        pageSize: state.pageSize,
      );

      final newState = handleSuccessState(
        currentState: state,
        newItems: result.scheduleAssignments,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.pagination.totalItems,
        totalPages: result.pagination.totalPages,
        hasNextPage: result.pagination.hasNext,
        hasPreviousPage: result.pagination.hasPrevious,
        isFirstPage: false,
      );
      state = ScheduleAssignmentState(
        items: newState.items,
        isLoading: newState.isLoading,
        isLoadingMore: newState.isLoadingMore,
        hasError: newState.hasError,
        errorMessage: newState.errorMessage,
        currentPage: newState.currentPage,
        pageSize: newState.pageSize,
        totalItems: newState.totalItems,
        totalPages: newState.totalPages,
        hasNextPage: newState.hasNextPage,
        hasPreviousPage: newState.hasPreviousPage,
        deletingAssignmentId: state.deletingAssignmentId,
        isCreating: state.isCreating,
      );
    } catch (e) {
      final errorState = handleErrorState(state, e.toString());
      state = ScheduleAssignmentState(
        items: errorState.items,
        isLoading: errorState.isLoading,
        isLoadingMore: errorState.isLoadingMore,
        hasError: errorState.hasError,
        errorMessage: errorState.errorMessage,
        currentPage: errorState.currentPage,
        pageSize: errorState.pageSize,
        totalItems: errorState.totalItems,
        totalPages: errorState.totalPages,
        hasNextPage: errorState.hasNextPage,
        hasPreviousPage: errorState.hasPreviousPage,
        deletingAssignmentId: state.deletingAssignmentId,
        isCreating: state.isCreating,
      );
    }
  }

  Future<void> changePageSize(int newSize) async {
    if (state.pageSize == newSize) return;
    state = state.copyWith(pageSize: newSize);
    await loadFirstPage();
  }

  @override
  Future<void> refresh() async {
    await loadFirstPage();
  }

  @override
  void reset() {
    state = const ScheduleAssignmentState();
  }

  Future<ScheduleAssignment> createScheduleAssignment(Map<String, dynamic> assignmentData) async {
    if (_currentEnterpriseId == null) {
      throw Exception('Enterprise ID is not set. Please ensure the provider is initialized.');
    }

    state = state.copyWith(isCreating: true, hasError: false, errorMessage: null);

    try {
      final createdAssignment = await _createScheduleAssignmentUseCase.call(
        tenantId: _currentEnterpriseId!,
        assignmentData: assignmentData,
      );

      await refresh();

      state = state.copyWith(isCreating: false, hasError: false, errorMessage: null);
      return createdAssignment;
    } catch (e) {
      state = state.copyWith(isCreating: false, hasError: true, errorMessage: e.toString());
      rethrow;
    }
  }

  String? validateCreateInputs({
    required AssignmentLevel? assignmentLevel,
    required String? orgUnitId,
    required int? employeeId,
    required WorkSchedule? workSchedule,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? status,
  }) {
    if (assignmentLevel == null) {
      return 'Please select an assignment level';
    }
    if (assignmentLevel == AssignmentLevel.department && orgUnitId == null) {
      return 'Please select an organizational unit';
    }
    if (assignmentLevel == AssignmentLevel.employee && employeeId == null) {
      return 'Please select an employee';
    }
    if (workSchedule == null) {
      return 'Please select a work schedule';
    }
    if (startDate == null) {
      return 'Please select an effective start date';
    }
    if (endDate == null) {
      return 'Please select an effective end date';
    }
    if (status == null || status.isEmpty) {
      return 'Please select a status';
    }
    if (endDate.isBefore(startDate)) {
      return 'Effective end date cannot be before start date';
    }
    return null;
  }

  Future<ScheduleAssignment> createScheduleAssignmentFromForm({
    required AssignmentLevel assignmentLevel,
    String? orgUnitId,
    int? employeeId,
    required WorkSchedule workSchedule,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    String? notes,
  }) {
    if (_currentEnterpriseId == null) {
      throw Exception('Enterprise ID is not set. Please ensure the provider is initialized.');
    }

    final assignmentData = <String, dynamic>{
      'tenant_id': _currentEnterpriseId!,
      'assignment_level': assignmentLevel == AssignmentLevel.department ? 'DEPARTMENT' : 'EMPLOYEE',
      if (assignmentLevel == AssignmentLevel.department) 'org_unit_id': orgUnitId,
      if (assignmentLevel == AssignmentLevel.employee && employeeId != null) 'employee_id': employeeId,
      'work_schedule_id': workSchedule.workScheduleId,
      'effective_start_date': DateFormat('yyyy-MM-dd').format(startDate),
      'effective_end_date': DateFormat('yyyy-MM-dd').format(endDate),
      'status': status.toUpperCase(),
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
    };

    return createScheduleAssignment(assignmentData);
  }

  Future<String?> submitCreateAssignment({
    required AssignmentLevel? assignmentLevel,
    required String? orgUnitId,
    required int? employeeId,
    required WorkSchedule? workSchedule,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? status,
    String? notes,
  }) async {
    final validationError = validateCreateInputs(
      assignmentLevel: assignmentLevel,
      orgUnitId: orgUnitId,
      employeeId: employeeId,
      workSchedule: workSchedule,
      startDate: startDate,
      endDate: endDate,
      status: status,
    );

    if (validationError != null) {
      return validationError;
    }

    try {
      await createScheduleAssignmentFromForm(
        assignmentLevel: assignmentLevel!,
        orgUnitId: orgUnitId,
        employeeId: employeeId,
        workSchedule: workSchedule!,
        startDate: startDate!,
        endDate: endDate!,
        status: status!,
        notes: notes,
      );

      return null;
    } on AppException catch (e) {
      return e.message;
    } catch (e) {
      return 'Failed to create schedule assignment: $e';
    }
  }

  Future<ScheduleAssignment> updateScheduleAssignment(
    int scheduleAssignmentId,
    Map<String, dynamic> assignmentData,
  ) async {
    if (_currentEnterpriseId == null) {
      throw Exception('Enterprise ID is not set. Please ensure the provider is initialized.');
    }

    state = state.copyWith(isCreating: true, hasError: false, errorMessage: null);

    try {
      final updatedAssignment = await _updateScheduleAssignmentUseCase.call(
        scheduleAssignmentId: scheduleAssignmentId,
        tenantId: _currentEnterpriseId!,
        assignmentData: assignmentData,
      );

      await refresh();

      state = state.copyWith(isCreating: false, hasError: false, errorMessage: null);
      return updatedAssignment;
    } catch (e) {
      state = state.copyWith(isCreating: false, hasError: true, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<String?> submitUpdateAssignment({
    required int scheduleAssignmentId,
    required AssignmentLevel? assignmentLevel,
    required String? orgUnitId,
    required int? employeeId,
    required WorkSchedule? workSchedule,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? status,
    String? notes,
  }) async {
    final validationError = validateCreateInputs(
      assignmentLevel: assignmentLevel,
      orgUnitId: orgUnitId,
      employeeId: employeeId,
      workSchedule: workSchedule,
      startDate: startDate,
      endDate: endDate,
      status: status,
    );

    if (validationError != null) {
      return validationError;
    }

    try {
      final level = assignmentLevel!;
      final schedule = workSchedule!;
      final start = startDate!;
      final end = endDate!;
      final statusValue = status!;

      if (_currentEnterpriseId == null) {
        return 'Enterprise ID is not set. Please try again.';
      }

      final data = <String, dynamic>{
        'tenant_id': _currentEnterpriseId!,
        'assignment_level': level == AssignmentLevel.department ? 'DEPARTMENT' : 'EMPLOYEE',
        if (level == AssignmentLevel.department) 'org_unit_id': orgUnitId,
        if (level == AssignmentLevel.employee && employeeId != null) 'employee_id': employeeId,
        'work_schedule_id': schedule.workScheduleId,
        'effective_start_date': DateFormat('yyyy-MM-dd').format(start),
        'effective_end_date': DateFormat('yyyy-MM-dd').format(end),
        'status': statusValue.toUpperCase(),
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      };

      await updateScheduleAssignment(scheduleAssignmentId, data);
      return null;
    } on AppException catch (e) {
      return e.message;
    } catch (e) {
      return 'Failed to update schedule assignment: $e';
    }
  }

  Future<void> deleteScheduleAssignment(int scheduleAssignmentId, {bool hard = true}) async {
    if (_currentEnterpriseId == null) return;

    state = state.copyWith(deletingAssignmentId: scheduleAssignmentId);

    try {
      await _deleteScheduleAssignmentUseCase.call(
        scheduleAssignmentId: scheduleAssignmentId,
        tenantId: _currentEnterpriseId!,
        hard: hard,
      );

      state = state.copyWith(
        items: state.items.where((a) => a.scheduleAssignmentId != scheduleAssignmentId).toList(),
        totalItems: state.totalItems - 1,
        clearDeletingAssignmentId: true,
      );
    } catch (e) {
      state = state.copyWith(clearDeletingAssignmentId: true);
      rethrow;
    }
  }
}
