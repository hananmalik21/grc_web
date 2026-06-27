import 'package:grc/features/security_manager/data/models/access_management/access_role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccessAssignUserFormState {
  final List<int> assignedUserIds;
  final List<AccessAssignedUser> users;
  final List<AccessAssignedUser> filteredUsers;
  final String? searchQuery;
  final bool dataLoading;
  final bool isLoading;
  final String? error;

  AccessAssignUserFormState({
    this.assignedUserIds = const [],
    this.users = const [],
    this.filteredUsers = const [],
    this.searchQuery,
    this.dataLoading = false,
    this.isLoading = false,
    this.error,
  });

  AccessAssignUserFormState copyWith({
    List<int>? assignedUserIds,
    List<AccessAssignedUser>? users,
    List<AccessAssignedUser>? filteredUsers,
    String? searchQuery,
    bool? dataLoading,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return AccessAssignUserFormState(
      assignedUserIds: assignedUserIds ?? this.assignedUserIds,
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchQuery: searchQuery ?? this.searchQuery,
      dataLoading: dataLoading ?? this.dataLoading,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AccessAssignUserFormProvider
    extends StateNotifier<AccessAssignUserFormState> {
  AccessAssignUserFormProvider() : super(AccessAssignUserFormState()) {
    fetchUsers();
  }

  void fetchUsers() {
    state = state.copyWith(dataLoading: true);
    final users = [
      AccessAssignedUser(
        id: 1,
        name: "Employee 1",
        email: "employee1@mail.com",
        code: "EMP001",
        status: "Active",
      ),
      AccessAssignedUser(
        id: 2,
        name: "Employee 2",
        email: "employee2@mail.com",
        code: "EMP002",
        status: "Active",
      ),
      AccessAssignedUser(
        id: 3,
        name: "Employee 3",
        email: "employee3@mail.com",
        code: "EMP003",
        status: "Active",
      ),
      AccessAssignedUser(
        id: 4,
        name: "Employee 4",
        email: "employee4@mail.com",
        code: "EMP004",
        status: "Active",
      ),
      AccessAssignedUser(
        id: 5,
        name: "Employee 5",
        email: "employee5@mail.com",
        code: "EMP005",
        status: "Active",
      ),
      AccessAssignedUser(
        id: 6,
        name: "Employee 6",
        email: "employee6@mail.com",
        code: "EMP006",
        status: "Active",
      ),
    ];
    state = state.copyWith(users: users, filteredUsers: users);
    state = state.copyWith(dataLoading: false);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    filterUsers();
  }

  void filterUsers() {
    final searchQuery = state.searchQuery?.toLowerCase() ?? "";
    final filteredUsers = state.users.where((user) {
      return user.name?.toLowerCase().contains(searchQuery) ??
          user.email?.toLowerCase().contains(searchQuery) ??
          user.code?.toLowerCase().contains(searchQuery) ??
          false;
    }).toList();
    state = state.copyWith(filteredUsers: filteredUsers);
  }

  void selectUser(int userId) {
    if (state.assignedUserIds.contains(userId)) {
      state = state.copyWith(
        assignedUserIds: state.assignedUserIds
            .where((id) => id != userId)
            .toList(),
      );
    } else {
      state = state.copyWith(
        assignedUserIds: [...state.assignedUserIds, userId],
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = AccessAssignUserFormState();
    fetchUsers();
  }
}

final accessAssignUserFormProvider =
    StateNotifierProvider<
      AccessAssignUserFormProvider,
      AccessAssignUserFormState
    >((ref) => AccessAssignUserFormProvider());
