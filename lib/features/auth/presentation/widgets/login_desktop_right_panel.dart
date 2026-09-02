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

  static const double _formMaxWidth = 480;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.r),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _formMaxWidth.w),
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
            ),
          ),
        ),
      ),
    );
  }
}
