import 'package:country_code_picker/country_code_picker.dart';
import 'package:digify_grc_suite/digify_grc_suite.dart';
import 'package:grc/core/config/app_config.dart';
import 'package:grc/core/integration/grc_suite_integration.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/localization/locale_provider.dart';
import 'package:grc/core/router/app_router.dart';
import 'package:grc/core/services/hive_service.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_theme.dart';
import 'package:grc/core/theme/app_mobile_theme.dart';
import 'package:grc/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(
    ProviderScope(
      overrides: buildGrcSuiteHostOverrides(),
      child: const DigifyHrSystemApp(),
    ),
  );
}

class DigifyHrSystemApp extends ConsumerWidget {
  const DigifyHrSystemApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final designSize = ResponsiveService.getScreenUtilDesignSizeFromContext(context);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          rebuildFactor: RebuildFactors.orientation,
          builder: (context, child) {
            return MaterialApp.router(
              title: AppConfig.appName,
              debugShowCheckedModeBanner: false,
              locale: locale,
              theme: ResponsiveHelper.isMobile(context) ? AppMobileTheme.lightTheme : AppTheme.lightTheme,
              darkTheme: ResponsiveHelper.isMobile(context) ? AppMobileTheme.darkTheme : AppTheme.darkTheme,
              themeMode: themeMode,
              localizationsDelegates: [
                ...AppLocalizations.localizationsDelegates,
                GrcSuiteLocalizations.delegate,
                CountryLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: router,

              builder: (context, child) {
                if (child == null) return const SizedBox.shrink();
                return GrcSuiteAssetScope(child: child);
              },
            );
          },
        );
      },
    );
  }
}
