import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/auth/presentation/widgets/login_compact_layout.dart';
import 'package:grc/features/auth/presentation/widgets/login_desktop_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginLayoutHandler extends ConsumerWidget {
  const LoginLayoutHandler({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.enterpriseIdController,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    required this.enterpriseIdFocusNode,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
    this.onForgotPasswordTap,
    this.onSsoTap,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController enterpriseIdController;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode enterpriseIdFocusNode;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onLogin;
  final VoidCallback? onForgotPasswordTap;
  final VoidCallback? onSsoTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBreaker(
      builder: (context, layout, _) {
        final shared = (
          usernameController: usernameController,
          passwordController: passwordController,
          enterpriseIdController: enterpriseIdController,
          usernameFocusNode: usernameFocusNode,
          passwordFocusNode: passwordFocusNode,
          enterpriseIdFocusNode: enterpriseIdFocusNode,
          rememberMe: rememberMe,
          onRememberMeChanged: onRememberMeChanged,
          onLogin: onLogin,
          onForgotPasswordTap: onForgotPasswordTap,
          onSsoTap: onSsoTap,
        );

        if (layout.isDesktop) {
          return LoginDesktopLayout(
            usernameController: shared.usernameController,
            passwordController: shared.passwordController,
            enterpriseIdController: shared.enterpriseIdController,
            usernameFocusNode: shared.usernameFocusNode,
            passwordFocusNode: shared.passwordFocusNode,
            enterpriseIdFocusNode: shared.enterpriseIdFocusNode,
            rememberMe: shared.rememberMe,
            onRememberMeChanged: shared.onRememberMeChanged,
            onLogin: shared.onLogin,
            onForgotPasswordTap: shared.onForgotPasswordTap,
          );
        }

        return LoginCompactLayout(
          usernameController: shared.usernameController,
          passwordController: shared.passwordController,
          enterpriseIdController: shared.enterpriseIdController,
          usernameFocusNode: shared.usernameFocusNode,
          passwordFocusNode: shared.passwordFocusNode,
          enterpriseIdFocusNode: shared.enterpriseIdFocusNode,
          rememberMe: shared.rememberMe,
          onRememberMeChanged: shared.onRememberMeChanged,
          onLogin: shared.onLogin,
          onForgotPasswordTap: shared.onForgotPasswordTap,
          onSsoTap: shared.onSsoTap,
        );
      },
    );
  }
}
