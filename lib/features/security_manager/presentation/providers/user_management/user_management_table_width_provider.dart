import 'package:grc/features/security_manager/data/config/user_management_table_config.dart';
import 'package:grc/features/security_manager/domain/models/system_user.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/user_management_table_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserManagementTableWidthState {
  final List<UserManagementTableColumn> columnOrder;
  final Map<UserManagementTableColumn, double> widthOverrides;

  const UserManagementTableWidthState({required this.columnOrder, required this.widthOverrides});

  factory UserManagementTableWidthState.initial() {
    return const UserManagementTableWidthState(columnOrder: UserManagementTableColumn.values, widthOverrides: {});
  }

  double widthFor(UserManagementTableColumn column) {
    return widthOverrides[column] ?? UserManagementTableConfig.widthFor(column);
  }

  UserManagementTableWidthState copyWith({
    List<UserManagementTableColumn>? columnOrder,
    Map<UserManagementTableColumn, double>? widthOverrides,
  }) {
    return UserManagementTableWidthState(
      columnOrder: columnOrder ?? this.columnOrder,
      widthOverrides: widthOverrides ?? this.widthOverrides,
    );
  }
}

final userManagementTableWidthsProvider =
    StateNotifierProvider<UserManagementTableWidthsNotifier, UserManagementTableWidthState>(
      (ref) => UserManagementTableWidthsNotifier(),
    );

class UserManagementTableWidthsNotifier extends StateNotifier<UserManagementTableWidthState> {
  UserManagementTableWidthsNotifier() : super(UserManagementTableWidthState.initial());

  void updateWidth(UserManagementTableColumn column, double delta) {
    double clamp(double current) => (current + delta).clamp(100.0, 700.0);
    state = state.copyWith(widthOverrides: {...state.widthOverrides, column: clamp(state.widthFor(column))});
  }

  void reorderColumn(UserManagementTableColumn dragged, UserManagementTableColumn target) {
    if (dragged == target) return;

    final updated = List<UserManagementTableColumn>.from(state.columnOrder);
    final oldIndex = updated.indexOf(dragged);
    final newIndex = updated.indexOf(target);
    if (oldIndex == -1 || newIndex == -1) return;

    updated.removeAt(oldIndex);
    final insertIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    updated.insert(insertIndex, dragged);

    state = state.copyWith(columnOrder: updated);
  }
}

final userManagementSkeletonRowsProvider = Provider<List<SystemUser>>((ref) {
  return List.generate(
    UserManagementTableConfig.pageSize,
    (index) => SystemUser(
      id: index,
      userGuid: '',
      username: '',
      name: index % 2 == 0 ? 'John Anderson' : 'Sarah Williams',
      email: index % 2 == 0 ? 'john.anderson@company.com' : 'sarah.williams@company.com',
      employeeNumber: 'EMP-${1000 + index}',
      department: index % 3 == 0 ? 'Information Technology' : (index % 3 == 1 ? 'Human Resources' : 'Finance'),
      designation: index % 2 == 0 ? 'Senior Manager' : 'Team Lead',
      roles: index % 2 == 0 ? ['Admin', 'Manager'] : ['Employee'],
      status: SystemUserStatus.active,
      is2FAEnabled: index % 2 == 0,
    ),
  );
});
