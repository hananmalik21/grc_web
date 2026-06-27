import 'package:grc/core/config/app_config.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/sidebar/sidebar_provider.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/utils/form_validators.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/auth/presentation/widgets/login_layout_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _enterpriseIdController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _enterpriseIdFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(loginFormStateProvider.notifier).allowPrefillAgain();
    });
    if (kDebugMode) {
      _usernameController.text = AppConfig.debugUsername;
      _passwordController.text = AppConfig.debugPassword;
    }
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _enterpriseIdFocusNode.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _enterpriseIdController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final localizations = AppLocalizations.of(context)!;
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final usernameValidation = FormValidators.combine(username, [
      (value) => FormValidators.required(
        value,
        errorMessage: localizations.fieldRequired,
      ),
    ]);
    if (usernameValidation != null) {
      _usernameFocusNode.requestFocus();
      ToastService.error(
        context,
        usernameValidation,
        title: localizations.loginFailed,
      );
      return;
    }

    final passwordValidation = FormValidators.combine(password, [
      (value) => FormValidators.required(
        value,
        errorMessage: localizations.fieldRequired,
      ),
      (value) => FormValidators.minLength(
        value,
        6,
        errorMessage: localizations.passwordTooShort,
      ),
    ]);
    if (passwordValidation != null) {
      _passwordFocusNode.requestFocus();
      ToastService.error(
        context,
        passwordValidation,
        title: localizations.loginFailed,
      );
      return;
    }

    final enterpriseCode = _enterpriseIdController.text.trim();
    final enterpriseValidation = FormValidators.combine(enterpriseCode, [
      (value) => FormValidators.required(
        value,
        errorMessage: localizations.fieldRequired,
      ),
      (value) => FormValidators.positiveInteger(
        value,
        errorMessage: localizations.loginDesktopEnterpriseCodeInvalid,
      ),
    ]);
    if (enterpriseValidation != null) {
      _enterpriseIdFocusNode.requestFocus();
      ToastService.error(
        context,
        enterpriseValidation,
        title: localizations.loginFailed,
      );
      return;
    }

    final rememberMe = ref.read(loginFormStateProvider).rememberMe;
    final enterpriseId = int.parse(enterpriseCode);

    await ref
        .read(authProvider.notifier)
        .login(
          username,
          password,
          rememberMe: rememberMe,
          enterpriseId: enterpriseId,
        );
  }

  void _showForgotPasswordDialog() {
    final localizations = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.forgotPasswordTitle),
        content: Text(localizations.forgotPasswordDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormStateProvider);

    ref.listen<LoginFormState>(loginFormStateProvider, (prev, next) {
      if (!next.initialLoadDone || next.savedEmailConsumed) return;
      final email = ref
          .read(loginFormStateProvider.notifier)
          .consumeSavedEmailForPrefill();
      if (email != null &&
          email.isNotEmpty &&
          (kReleaseMode || _usernameController.text.isEmpty)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _usernameController.text = email;
        });
      }
    });

    ref.listen<AuthState>(authProvider, (prev, next) {
      final feedback = next.pendingLoginFeedback;
      if (feedback != null) {
        ref.read(authProvider.notifier).clearPendingLoginFeedback();
        final localizations = AppLocalizations.of(context)!;
        if (feedback.success) {
          ToastService.success(context, localizations.loginSuccess);
          ref.read(sidebarProvider.notifier).collapse();
          context.go(AppRoutes.dashboard);
        } else {
          final apiMessage = feedback.errorMessage?.trim();
          final message = apiMessage != null && apiMessage.isNotEmpty
              ? apiMessage
              : switch (feedback.errorCode) {
                  'network_error' => localizations.connectionError,
                  _ => localizations.invalidCredentials,
                };
          ToastService.error(
            context,
            message,
            title: localizations.loginFailed,
          );
        }
        return;
      }
      if (next.isAuthenticated && !next.isRestoring) {
        ref.read(sidebarProvider.notifier).collapse();
        context.go(AppRoutes.dashboard);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.authDesktopBackground,
      body: SizedBox.expand(
        child: LoginLayoutHandler(
          usernameController: _usernameController,
          passwordController: _passwordController,
          enterpriseIdController: _enterpriseIdController,
          usernameFocusNode: _usernameFocusNode,
          passwordFocusNode: _passwordFocusNode,
          enterpriseIdFocusNode: _enterpriseIdFocusNode,
          rememberMe: formState.rememberMe,
          onRememberMeChanged: (value) =>
              ref.read(loginFormStateProvider.notifier).setRememberMe(value),
          onLogin: _handleLogin,
          onForgotPasswordTap: _showForgotPasswordDialog,
        ),
      ),
    );
  }
}
