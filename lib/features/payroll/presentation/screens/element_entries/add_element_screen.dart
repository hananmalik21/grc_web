import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/features/payroll/application/element_entries/providers/add_element_form_provider.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/add_element_form_body.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/element_entries_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddElementScreen extends ConsumerWidget {
  const AddElementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final padding = ResponsiveHelper.getScreenPadding(context).copyWith(top: 24.h);
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);
    final formState = ref.watch(addElementFormProvider);
    final formNotifier = ref.read(addElementFormProvider.notifier);

    final customActions = Wrap(
      spacing: isMobile ? 8.w : 10.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppButton.outline(
          label: loc.payrollAddElementSaveDraft,
          svgPath: Assets.icons.saveConfigIcon.path,
          isLoading: formState.isSavingDraft,
          onPressed: formState.isSavingDraft || formState.isSubmitting
              ? null
              : () async {
                  final error = await formNotifier.saveDraft(loc);
                  if (!context.mounted) return;
                  if (error != null) {
                    ToastService.error(context, error);
                    return;
                  }
                  ToastService.success(context, loc.payrollAddElementDraftSavedSuccess);
                },
        ),
        AppButton.primary(
          label: loc.payrollAddElementSubmit,
          svgPath: Assets.icons.submitted.path,
          isLoading: formState.isSubmitting,
          onPressed: formState.isSavingDraft || formState.isSubmitting
              ? null
              : () async {
                  final error = await formNotifier.submit(loc);
                  if (!context.mounted) return;
                  if (error != null) {
                    ToastService.error(context, error);
                    return;
                  }
                  ToastService.success(context, loc.payrollAddElementSubmittedSuccess);
                  context.pop();
                },
        ),
        AppMobileButton.outline(
          svgPath: Assets.icons.closeIcon.path,
          onPressed: formState.isSavingDraft || formState.isSubmitting ? null : () => context.pop(),
        ),
      ],
    );

    final header = isMobile
        ? ElementEntriesHeaderMobile(showSwitcher: false, customActions: customActions)
        : ElementEntriesHeader(showSwitcher: false, customActions: customActions);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [header, Gap(sectionSpacing), const AddElementFormBody()],
        ),
      ),
    );
  }
}
