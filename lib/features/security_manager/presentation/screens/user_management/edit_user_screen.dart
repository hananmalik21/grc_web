import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/common/app_loading_indicator.dart';
import '../../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../domain/models/system_user.dart';
import '../../providers/user_management/user_detail_provider.dart';
import '../../providers/user_management/user_form_provider.dart';
import '../../providers/user_management/user_management_enterprise_provider.dart';
import '../../providers/user_management/user_management_provider.dart';
import 'tabs/account_information_tab.dart';
import 'tabs/roles_and_responsibilities_tab.dart';
import 'tabs/access_and_permissions_tab.dart';
import 'tabs/user_preferences_tab.dart';
import 'tabs/security_settings_tab.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  static const String routeName = 'security-manager-user-edit';

  const EditUserScreen({required this.user, super.key});

  final SystemUser user;

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final detailAsync = ref.watch(userDetailProvider(widget.user.userGuid));
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    final selectedEnterpriseId = ref.watch(userManagementEnterpriseIdProvider);
    final isLastStep = notifier.stepIndex == notifier.stepCount - 1;
    final canGoBack = notifier.stepIndex > 0;

    detailAsync.whenData((detail) {
      if (!state.hasEditInitialized) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) notifier.initFromUserDetail(detail);
        });
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      body: detailAsync.when(
        loading: () => const Center(child: AppLoadingIndicator(type: LoadingType.circle)),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (_) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 24.h, bottom: 40.h),
          child: Column(
            children: [
              DigifyTabHeader(
                title: 'Edit User',
                description: 'Update account details, roles, and security permissions for this user.',
                trailing: Row(
                  children: [
                    AppButton.outline(label: 'Back', onPressed: canGoBack ? notifier.previousStep : null),
                    Gap(12.w),
                    AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
                    Gap(12.w),
                    AppButton.primary(
                      label: isLastStep ? 'Update User' : 'Continue',
                      svgPath: isLastStep ? Assets.icons.checkIconGreen.path : null,
                      isLoading: state.isSubmitting,
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              if (!notifier.validateCurrentStep(context)) return;
                              if (isLastStep) {
                                if (selectedEnterpriseId == null) return;
                                notifier.updateUser(
                                  enterpriseId: selectedEnterpriseId,
                                  context: context,
                                  onSuccess: () {
                                    ref.read(userManagementProvider.notifier).getUsers();
                                    context.pop();
                                  },
                                );
                                return;
                              }
                              notifier.nextStep();
                            },
                    ),
                  ],
                ),
              ),
              Gap(24.h),
              _EditUserStepper(currentStep: state.step, maxStepIndex: state.maxStepIndex),
              Gap(24.h),
              _buildStepBody(state.step),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepBody(CreateUserStep step) {
    return switch (step) {
      CreateUserStep.accountInformation => AccountInformationTab(),
      CreateUserStep.rolesAndResponsibilities => RolesAndResponsibilitiesTab(),
      CreateUserStep.accessAndPermissions => AccessAndPermissionsTab(),
      CreateUserStep.userPreferences => UserPreferencesTab(),
      CreateUserStep.securitySettings => SecuritySettingsTab(),
    };
  }
}

class _EditUserStepper extends StatelessWidget {
  final CreateUserStep currentStep;
  final int maxStepIndex;

  const _EditUserStepper({required this.currentStep, required this.maxStepIndex});

  @override
  Widget build(BuildContext context) {
    final currentIndex = createUserVisibleSteps.indexOf(currentStep);
    final isDark = context.isDark;
    final stepCount = createUserVisibleSteps.length;
    final progressFraction = stepCount == 0 ? 0.0 : ((currentIndex + 1).clamp(0, stepCount) / stepCount).toDouble();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fillWidth = (constraints.maxWidth * progressFraction).clamp(0.0, constraints.maxWidth);

          return Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                  width: fillWidth,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(100.r)),
                ),
              ),
              Row(
                children: createUserVisibleSteps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  final isSelected = currentIndex == index;
                  final isCompleted = index < currentIndex;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: _StepChip(step: step, isSelected: isSelected, isCompleted: isCompleted),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  final CreateUserStep step;
  final bool isSelected;
  final bool isCompleted;

  const _StepChip({required this.step, required this.isSelected, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final icons = Assets.icons;
    final iconPath = switch (step) {
      CreateUserStep.accountInformation => icons.registrationCardIcon.path,
      CreateUserStep.rolesAndResponsibilities => icons.securityManager.applicationRoles.path,
      CreateUserStep.userPreferences => icons.settingsIcon.path,
      CreateUserStep.securitySettings => icons.securityIcon.path,
      CreateUserStep.accessAndPermissions => icons.lockIcon.path,
    };
    final effectiveIconPath = isCompleted ? icons.activeCheckIcon.path : iconPath;

    final isDark = context.isDark;
    final fg = (isSelected || isCompleted)
        ? Colors.white
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DigifyAsset(assetPath: effectiveIconPath, width: 16.w, height: 16.w, color: fg),
          Gap(8.w),
          Text(
            step.label,
            style: context.textTheme.titleSmall?.copyWith(
              color: fg,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
