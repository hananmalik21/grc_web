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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(loginFormStateProvider.notifier).allowPrefillAgain();
    });
    if (kDebugMode) {
      _emailController.text = AppConfig.debugUsername;
      _passwordController.text = AppConfig.debugPassword;
    }
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final localizations = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final emailValidation = FormValidators.combine(email, [
      (value) => FormValidators.required(
        value,
        errorMessage: localizations.fieldRequired,
      ),
      (value) => FormValidators.email(
        value,
        errorMessage: localizations.invalidCredentials,
      ),
    ]);
    if (emailValidation != null) {
      _emailFocusNode.requestFocus();
      ToastService.error(
        context,
        emailValidation,
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
        8,
        errorMessage: 'Password must be at least 8 characters',
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

    final rememberMe = ref.read(loginFormStateProvider).rememberMe;

    await ref
        .read(authProvider.notifier)
        .login(
          email,
          password,
          rememberMe: rememberMe,
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
          (kReleaseMode || _emailController.text.isEmpty)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _emailController.text = email;
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
          emailController: _emailController,
          passwordController: _passwordController,
          emailFocusNode: _emailFocusNode,
          passwordFocusNode: _passwordFocusNode,
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
