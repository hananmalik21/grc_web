import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/auth/presentation/widgets/login_compact_layout.dart';
import 'package:grc/features/auth/presentation/widgets/login_desktop_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginLayoutHandler extends ConsumerWidget {
  const LoginLayoutHandler({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
    this.onForgotPasswordTap,
    this.onSsoTap,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onLogin;
  final VoidCallback? onForgotPasswordTap;
  final VoidCallback? onSsoTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBreaker(
      builder: (context, layout, _) {
        if (layout.isDesktop) {
          return LoginDesktopLayout(
            emailController: emailController,
            passwordController: passwordController,
            emailFocusNode: emailFocusNode,
            passwordFocusNode: passwordFocusNode,
            rememberMe: rememberMe,
            onRememberMeChanged: onRememberMeChanged,
            onLogin: onLogin,
            onForgotPasswordTap: onForgotPasswordTap,
          );
        }

        return LoginCompactLayout(
          emailController: emailController,
          passwordController: passwordController,
          emailFocusNode: emailFocusNode,
          passwordFocusNode: passwordFocusNode,
          rememberMe: rememberMe,
          onRememberMeChanged: onRememberMeChanged,
          onLogin: onLogin,
          onForgotPasswordTap: onForgotPasswordTap,
          onSsoTap: onSsoTap,
        );
      },
    );
  }
}
