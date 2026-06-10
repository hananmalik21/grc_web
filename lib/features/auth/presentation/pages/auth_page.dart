import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grc_web/core/router/app_routes.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/locale_provider.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/theme/theme_provider.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_error_view.dart';
import 'package:grc_web/core/widgets/app_loading_indicator.dart';
import 'package:grc_web/features/auth/application/providers/auth_providers.dart';
import 'package:grc_web/features/auth/domain/entities/app_user.dart';
import 'package:grc_web/features/auth/presentation/widgets/auth_header.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final userAsync = ref.watch(authUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.authTitle),
        actions: [
          IconButton(
            tooltip: l10n.toggleLanguage,
            onPressed: () => ref.read(localeProvider.notifier).toggleEnglishArabic(),
            icon: const Icon(Icons.language),
          ),
          IconButton(
            tooltip: l10n.toggleTheme,
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
            icon: const Icon(Icons.brightness_6),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(title: l10n.authTitle),
              SizedBox(height: 16.h),
              _UserCard(
                userAsync: userAsync,
                onRetry: () => ref.read(authUserProvider.notifier).loadCurrentUser(),
              ),
              SizedBox(height: 16.h),
              AppButton(
                label: userAsync.value != null ? 'Go to Dashboard' : l10n.loadUser,
                variant: AppButtonVariant.primary,
                fullWidth: true,
                onPressed: () {
                  if (userAsync.value != null) {
                    context.go(AppRoutes.dashboard);
                  } else {
                    ref.read(authUserProvider.notifier).loadCurrentUser();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.userAsync,
    required this.onRetry,
  });

  final AsyncValue<AppUser?> userAsync;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return userAsync.when(
      loading: () => Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: colorScheme.surfaceContainerHighest,
        ),
        child: Row(
          children: [
            const AppLoadingIndicator(),
            SizedBox(width: 12.w),
            Expanded(child: Text(l10n.loading, style: textTheme.bodyMedium)),
          ],
        ),
      ),
      error: (error, stackTrace) => Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: colorScheme.errorContainer,
        ),
        child: AppErrorView(
          message: error is Failure ? error.message : l10n.errorGeneric,
          onRetry: onRetry,
        ),
      ),
      data: (user) => Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user == null ? l10n.noUserYet : l10n.userGreeting(user.name),
              style: textTheme.titleMedium,
            ),
            SizedBox(height: 6.h),
            Text(
              user == null ? '' : l10n.userId(user.id),
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

