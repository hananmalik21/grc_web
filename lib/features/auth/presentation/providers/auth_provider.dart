import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/jwt_utils.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/auth/data/datasources/auth_local_storage.dart';
import 'package:grc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:grc/features/auth/data/datasources/dio_auth_remote_data_source.dart';
import 'package:grc/features/auth/data/datasources/hive_auth_local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginFeedback {
  const LoginFeedback({
    required this.success,
    this.errorCode,
    this.errorMessage,
  });
  final bool success;
  final String? errorCode;
  final String? errorMessage;
}

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool isRestoring;
  final String? error;
  final LoginFeedback? pendingLoginFeedback;
  final int? enterpriseId;
  final List<String> permissions;

  AuthState({
    required this.isAuthenticated,
    this.isLoading = false,
    this.isRestoring = false,
    this.error,
    this.pendingLoginFeedback,
    this.enterpriseId,
    this.permissions = const [],
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? isRestoring,
    String? error,
    Object? pendingLoginFeedback = _undefined,
    Object? enterpriseId = _undefined,
    List<String>? permissions,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isRestoring: isRestoring ?? this.isRestoring,
      error: error ?? this.error,
      pendingLoginFeedback: identical(pendingLoginFeedback, _undefined)
          ? this.pendingLoginFeedback
          : pendingLoginFeedback as LoginFeedback?,
      enterpriseId: identical(enterpriseId, _undefined)
          ? this.enterpriseId
          : enterpriseId as int?,
      permissions: permissions ?? this.permissions,
    );
  }
}

const _undefined = Object();

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._storage, this._remoteDataSource)
    : super(AuthState(isAuthenticated: false, isRestoring: true)) {
    _restoreSession();
  }

  final AuthLocalStorage _storage;
  final AuthRemoteDataSource _remoteDataSource;

  Future<void> _restoreSession() async {
    try {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty && looksLikeJwt(token)) {
        final enterpriseId = await _storage.getEnterpriseId();
        final permissions = await _storage.getPermissions();
        state = state.copyWith(
          isAuthenticated: true,
          isRestoring: false,
          enterpriseId: enterpriseId,
          permissions: permissions,
        );
        return;
      }
      if (token != null && token.isNotEmpty) {
        await _storage.clearToken();
      }
      state = state.copyWith(isRestoring: false);
    } catch (_) {
      state = state.copyWith(isRestoring: false);
    }
  }

  Future<void> login(
    String username,
    String password, {
    required bool rememberMe,
    required int enterpriseId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _remoteDataSource.login(
        loginId: username.trim(),
        password: password.trim(),
        enterpriseId: enterpriseId,
      );

      if (response.success) {
        final access = response.accessToken;
        if (access == null || access.isEmpty) {
          state = state.copyWith(
            isLoading: false,
            error: 'invalid_credentials',
            pendingLoginFeedback: LoginFeedback(
              success: false,
              errorCode: 'invalid_credentials',
              errorMessage: response.message,
            ),
          );
          return;
        }
        await _storage.saveToken(access);
        if (response.refreshToken != null &&
            response.refreshToken!.isNotEmpty) {
          await _storage.saveRefreshToken(response.refreshToken!);
        }

        await _storage.saveUserGuid(response.data.userGuid);
        await _storage.saveEnterpriseId(response.data.enterpriseId);
        await _storage.setRememberMe(rememberMe);
        await _storage.setSavedEmail(rememberMe ? username.trim() : null);
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          enterpriseId: response.data.enterpriseId,
          permissions: response.data.permissions,
          pendingLoginFeedback: const LoginFeedback(success: true),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'invalid_credentials',
          pendingLoginFeedback: LoginFeedback(
            success: false,
            errorCode: 'invalid_credentials',
            errorMessage: response.message,
          ),
        );
      }
    } on UnauthorizedException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'invalid_credentials',
        pendingLoginFeedback: LoginFeedback(
          success: false,
          errorCode: 'invalid_credentials',
          errorMessage: e.message,
        ),
      );
    } on ConnectionException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'network_error',
        pendingLoginFeedback: LoginFeedback(
          success: false,
          errorCode: 'network_error',
          errorMessage: e.message,
        ),
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'network_error',
        pendingLoginFeedback: LoginFeedback(
          success: false,
          errorCode: 'network_error',
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'network_error',
        pendingLoginFeedback: const LoginFeedback(
          success: false,
          errorCode: 'network_error',
        ),
      );
    }
  }

  Future<void> registerTenant({
    required String orgName,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? country,
    String? industry,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _remoteDataSource.registerTenant(
        orgName: orgName.trim(),
        email: email.trim(),
        password: password.trim(),
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        country: country?.trim(),
        industry: industry?.trim(),
      );

      if (response.success &&
          response.accessToken != null &&
          response.accessToken!.isNotEmpty) {
        final access = response.accessToken!;
        await _storage.saveToken(access);
        if (response.refreshToken != null &&
            response.refreshToken!.isNotEmpty) {
          await _storage.saveRefreshToken(response.refreshToken!);
        }
        await _storage.saveUserGuid(response.data.userGuid);
        await _storage.saveOrgId(response.data.orgId);
        await _storage.savePermissions(response.data.permissions);
        await _storage.saveEnterpriseId(response.data.enterpriseId);

        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          enterpriseId: response.data.enterpriseId,
          permissions: response.data.permissions,
          pendingLoginFeedback: const LoginFeedback(success: true),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'registration_failed',
          pendingLoginFeedback: LoginFeedback(
            success: false,
            errorCode: 'registration_failed',
            errorMessage: response.message,
          ),
        );
      }
    } on ConflictException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'email_exists',
        pendingLoginFeedback: LoginFeedback(
          success: false,
          errorCode: 'email_exists',
          errorMessage: e.message,
        ),
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'network_error',
        pendingLoginFeedback: LoginFeedback(
          success: false,
          errorCode: 'network_error',
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'network_error',
        pendingLoginFeedback: LoginFeedback(
          success: false,
          errorCode: 'network_error',
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void clearPendingLoginFeedback() {
    state = state.copyWith(pendingLoginFeedback: null);
  }

  Future<void> logout() async {
    await _storage.clearToken();
    state = AuthState(isAuthenticated: false);
  }
}

final authLocalStorageProvider = Provider<AuthLocalStorage>((ref) {
  return HiveAuthLocalStorage();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return DioAuthRemoteDataSource(
    apiClient: ApiClient(baseUrl: ApiConfig.baseUrl),
  );
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final storage = ref.watch(authLocalStorageProvider);
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthNotifier(storage, remoteDataSource);
});

class LoginFormState {
  final bool rememberMe;
  final String? savedEmail;
  final bool initialLoadDone;
  final bool savedEmailConsumed;

  const LoginFormState({
    this.rememberMe = false,
    this.savedEmail,
    this.initialLoadDone = false,
    this.savedEmailConsumed = false,
  });

  LoginFormState copyWith({
    bool? rememberMe,
    String? savedEmail,
    bool? initialLoadDone,
    bool? savedEmailConsumed,
  }) {
    return LoginFormState(
      rememberMe: rememberMe ?? this.rememberMe,
      savedEmail: savedEmail ?? this.savedEmail,
      initialLoadDone: initialLoadDone ?? this.initialLoadDone,
      savedEmailConsumed: savedEmailConsumed ?? this.savedEmailConsumed,
    );
  }
}

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier(this._storage) : super(const LoginFormState()) {
    _loadInitial();
  }

  final AuthLocalStorage _storage;

  Future<void> _loadInitial() async {
    try {
      final rememberMe = await _storage.getRememberMe();
      final savedEmail = await _storage.getSavedEmail();
      state = state.copyWith(
        rememberMe: rememberMe,
        savedEmail: savedEmail,
        initialLoadDone: true,
      );
    } catch (_) {
      state = state.copyWith(initialLoadDone: true);
    }
  }

  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  String? consumeSavedEmailForPrefill() {
    if (state.savedEmailConsumed || state.savedEmail == null) return null;
    final email = state.savedEmail;
    state = state.copyWith(savedEmailConsumed: true);
    return email;
  }

  void allowPrefillAgain() {
    state = state.copyWith(savedEmailConsumed: false);
  }
}

final loginFormStateProvider =
    StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) {
      final storage = ref.watch(authLocalStorageProvider);
      return LoginFormNotifier(storage);
    });
