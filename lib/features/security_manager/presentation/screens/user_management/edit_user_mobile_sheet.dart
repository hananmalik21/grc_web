import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/security_manager/domain/models/system_user.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_detail_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_form_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_management_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_management_provider.dart';
import 'package:grc/features/security_manager/presentation/screens/user_management/tabs/account_information_tab.dart';
import 'package:grc/features/security_manager/presentation/screens/user_management/tabs/roles_and_responsibilities_tab.dart';
import 'package:grc/features/security_manager/presentation/screens/user_management/tabs/security_settings_tab.dart';
import 'package:grc/features/security_manager/presentation/screens/user_management/tabs/user_preferences_tab.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditUserMobileSheet extends ConsumerWidget {
  const EditUserMobileSheet({required this.user, super.key});

  final SystemUser user;

  static Future<bool> show(BuildContext context, SystemUser user) async {
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Edit User',
      barrierDismissible: false,
      child: ProviderScope(child: EditUserMobileSheet(user: user)),
    );
    return result == true;
  }

  void _onNext(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(userFormProvider.notifier);
    if (!notifier.validateCurrentStep(context)) return;
    notifier.nextStep();
  }

  void _onSave(BuildContext context, WidgetRef ref) {
    final state = ref.read(userFormProvider);
    if (state.isSubmitting) return;

    final notifier = ref.read(userFormProvider.notifier);
    if (!notifier.validateCurrentStep(context)) return;

    final selectedEnterpriseId = ref.read(userManagementEnterpriseIdProvider);
    if (selectedEnterpriseId == null) {
      ToastService.error(context, 'No enterprise selected.');
      return;
    }

    notifier.updateUser(
      enterpriseId: selectedEnterpriseId,
      context: context,
      onSuccess: () {
        ref.read(userManagementProvider.notifier).getUsers();
        context.pop(true);
      },
    );
  }

  Widget _buildStepBody(CreateUserStep step) {
    return switch (step) {
      CreateUserStep.accountInformation => AccountInformationTab(),
      CreateUserStep.rolesAndResponsibilities => RolesAndResponsibilitiesTab(),
      CreateUserStep.accessAndPermissions => const SizedBox.shrink(),
      CreateUserStep.userPreferences => UserPreferencesTab(),
      CreateUserStep.securitySettings => SecuritySettingsTab(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(userDetailProvider(user.userGuid));
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);

    detailAsync.whenData((detail) {
      if (!state.hasEditInitialized) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifier.initFromUserDetail(detail);
        });
      }
    });

    if (detailAsync.isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: AppLoadingIndicator(type: LoadingType.circle)),
      );
    }

    if (detailAsync.hasError) {
      return SizedBox(height: 200, child: Center(child: Text(detailAsync.error.toString())));
    }

    final stepIndex = notifier.stepIndex;
    final stepCount = notifier.stepCount;

    return DigifyStepperSheetContent(
      currentStep: stepIndex,
      totalSteps: stepCount,
      stepLabel: state.step.label,
      isDark: context.isDark,
      canGoPrevious: stepIndex > 0,
      isLastStep: stepIndex == stepCount - 1,
      isLoading: state.isSubmitting,
      previousLabel: 'Back',
      nextLabel: 'Continue',
      saveLabel: 'Update User',
      onPrevious: notifier.previousStep,
      onNext: () => _onNext(context, ref),
      onSave: () => _onSave(context, ref),
      body: _buildStepBody(state.step),
    );
  }
}
