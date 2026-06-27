import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'login_desktop_left_panel.dart';
import 'login_desktop_right_panel.dart';

class LoginDesktopLayout extends StatelessWidget {
  const LoginDesktopLayout({
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

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.authDesktopBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: LoginDesktopLeftPanel()),
          Expanded(
            child: LoginDesktopRightPanel(
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
            ),
          ),
        ],
      ),
    );
  }
}
