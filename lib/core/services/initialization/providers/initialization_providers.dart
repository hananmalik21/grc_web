import 'package:digify_enterprise_structure/digify_enterprise_structure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/services/initialization/app_initialization_service.dart';
import 'package:grc/core/services/location_provider.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';

final appInitializationServiceProvider = Provider<AppInitializationService>((
  ref,
) {
  final getEnterprisesUseCase = ref.watch(getEnterprisesUseCaseProvider);
  void onActiveEnterpriseReady(int? id) {
    if (id != null) {
      ref
          .read(activeEnterpriseIdNotifierProvider.notifier)
          .setActiveEnterpriseId(id);
    }
  }

  void initializeLocation() {
    ref.read(locationProvider);
  }

  return AppInitializationService(
    getEnterprisesUseCase: getEnterprisesUseCase,
    onActiveEnterpriseReady: onActiveEnterpriseReady,
    initializeLocation: initializeLocation,
  );
});

final enterprisesCacheProvider = Provider<List<Enterprise>?>((ref) {
  return ref.watch(appInitializationServiceProvider).enterprises;
});

final enterprisesCacheStateProvider = Provider<EnterprisesState>((ref) {
  ref.watch(appInitializationAfterAuthProvider);
  final enterprises = ref.watch(enterprisesCacheProvider);
  return EnterprisesState(
    enterprises: enterprises ?? [],
    isLoading: enterprises == null,
    hasError: false,
  );
});

class ActiveEnterpriseIdNotifier extends StateNotifier<int?> {
  ActiveEnterpriseIdNotifier() : super(null);

  void setActiveEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final activeEnterpriseIdNotifierProvider =
    StateNotifierProvider<ActiveEnterpriseIdNotifier, int?>((ref) {
      return ActiveEnterpriseIdNotifier();
    });

final activeEnterpriseIdProvider = Provider<int?>((ref) {
  final authEnterpriseId = ref.watch(authProvider).enterpriseId;
  if (authEnterpriseId != null) return authEnterpriseId;
  return ref.watch(activeEnterpriseIdNotifierProvider);
});

final showEnterpriseSelectorProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).enterpriseId == null;
});

final enterpriseBootstrapProvider = Provider<void>((ref) {
  ref.listen<AuthState>(authProvider, (previous, next) {
    if (!next.isAuthenticated) {
      ref
          .read(activeEnterpriseIdNotifierProvider.notifier)
          .setActiveEnterpriseId(null);
      ref.read(appInitializationServiceProvider).clearCache();
      ref.invalidate(appInitializationAfterAuthProvider);
      ref.invalidate(enterprisesCacheProvider);
      return;
    }

    if (next.isRestoring) return;

    final enterpriseId = next.enterpriseId;
    if (enterpriseId != null) {
      ref
          .read(activeEnterpriseIdNotifierProvider.notifier)
          .setActiveEnterpriseId(enterpriseId);
    }

    final shouldReinitialize =
        previous?.isAuthenticated != true ||
        previous?.enterpriseId != enterpriseId;
    if (shouldReinitialize) {
      ref.invalidate(appInitializationAfterAuthProvider);
    }
  });
});

final appInitializationAfterAuthProvider = FutureProvider<void>((ref) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated || authState.isRestoring) {
    return;
  }

  await ref
      .read(appInitializationServiceProvider)
      .initializeAfterAuth(
        preferredEnterpriseId: authState.enterpriseId,
        onEnterprisesLoaded: () => ref.invalidate(enterprisesCacheProvider),
      );
  ref.invalidate(enterprisesCacheProvider);
});
