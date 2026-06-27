import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/auth/presentation/widgets/login_desktop_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginDesktopRightPanel extends StatelessWidget {
  const LoginDesktopRightPanel({
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
    this.onCreateAccountTap,
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
  final VoidCallback? onCreateAccountTap;

  static const double _cardMaxWidth = 450;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.authBgEnd,
        border: Border(left: BorderSide(color: AppColors.authInputBorder, width: 1)),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _cardMaxWidth.w),
            child: LoginDesktopCard(
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
              onCreateAccountTap: onCreateAccountTap,
            ),
          ),
        ),
      ),
    );
  }
}
