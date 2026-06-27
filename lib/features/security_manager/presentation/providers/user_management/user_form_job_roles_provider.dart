import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/features/security_manager/domain/models/job_role.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_management_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserFormJobRolesPage {
  const UserFormJobRolesPage({
    required this.roles,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<JobRole> roles;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}

final userFormJobRolesCurrentPageProvider = StateProvider.autoDispose<int>((ref) => 1);

final userFormJobRolesPageSizeProvider = Provider.autoDispose<int>((ref) => 10);

final userFormJobRolesProvider = FutureProvider.autoDispose<UserFormJobRolesPage>((ref) async {
  final enterpriseId = ref.watch(userManagementEnterpriseIdProvider);
  if (enterpriseId == null) {
    return const UserFormJobRolesPage(
      roles: [],
      currentPage: 1,
      pageSize: 10,
      totalItems: 0,
      totalPages: 1,
      hasNext: false,
      hasPrevious: false,
    );
  }

  final currentPage = ref.watch(userFormJobRolesCurrentPageProvider);
  final pageSize = ref.watch(userFormJobRolesPageSizeProvider);

  final client = ApiClient(baseUrl: ApiConfig.baseUrl);
  final response = await client.get(
    ApiEndpoints.securityJobRoles,
    queryParameters: {
      'enterprise_id': enterpriseId.toString(),
      'page': currentPage.toString(),
      'page_size': pageSize.toString(),
    },
  );

  final pagination = (response['meta'] as Map<String, dynamic>?)?['pagination'] as Map<String, dynamic>? ?? {};
  final data = response['data'] as List<dynamic>? ?? [];
  final roles = data.map((e) => JobRole.fromJson(e as Map<String, dynamic>)).toList();

  return UserFormJobRolesPage(
    roles: roles,
    currentPage: (pagination['page'] as num?)?.toInt() ?? currentPage,
    pageSize: (pagination['page_size'] as num?)?.toInt() ?? pageSize,
    totalItems: (pagination['total'] as num?)?.toInt() ?? roles.length,
    totalPages: (pagination['total_pages'] as num?)?.toInt() ?? 1,
    hasNext: pagination['has_next'] as bool? ?? false,
    hasPrevious: pagination['has_previous'] as bool? ?? false,
  );
});
