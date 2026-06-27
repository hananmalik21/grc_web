import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_preview_employee.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_processing_summary.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_schedule_entry.dart';
import 'package:grc/features/leave_management/presentation/providers/forfeit_schedule_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/forfeit_processing_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_processing/confirm_run_content.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_processing/forfeit_processing_stepper.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_processing/preview_review_content.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_processing/processing_summary_card.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_processing/upcoming_forfeits_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForfeitProcessingTab extends ConsumerStatefulWidget {
  const ForfeitProcessingTab({super.key});

  @override
  ConsumerState<ForfeitProcessingTab> createState() => _ForfeitProcessingTabState();
}

class _ForfeitProcessingTabState extends ConsumerState<ForfeitProcessingTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(forfeitProcessingTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.invalidate(forfeitScheduleEntriesProvider);
        ref.invalidate(forfeitPreviewEmployeesProvider);
        ref.invalidate(forfeitProcessingSummaryProvider);
        ref.read(forfeitProcessingStepProvider.notifier).setStep(ForfeitProcessingStep.upcomingForfeits);
      }
    });
  }

  String _getButtonLabel(ForfeitProcessingStep step) {
    switch (step) {
      case ForfeitProcessingStep.upcomingForfeits:
        return 'Continue to Preview';
      case ForfeitProcessingStep.previewReview:
        return 'Confirm & Run';
      case ForfeitProcessingStep.confirmRun:
        return 'View Results';
      case ForfeitProcessingStep.resultsSummary:
        return 'Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final effectiveEnterpriseId = ref.watch(forfeitProcessingTabEnterpriseIdProvider);
    final scheduleEntriesAsync = ref.watch(forfeitScheduleEntriesProvider);
    final selectedEntry = ref.watch(forfeitScheduleNotifierProvider).selectedEntry;
    final currentStep = ref.watch(forfeitProcessingStepProvider);
    final previewEmployeesAsync = ref.watch(forfeitPreviewEmployeesProvider);
    final processingSummaryAsync = ref.watch(forfeitProcessingSummaryProvider);

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 21.h,
            children: [
              DigifyTabHeader(
                title: localizations.forfeitProcessing,
                description: localizations.forfeitProcessingDescription,
              ),
              EnterpriseSelectorWidget(
                selectedEnterpriseId: effectiveEnterpriseId,
                onEnterpriseChanged: (enterpriseId) {
                  ref.read(forfeitProcessingTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
                },
              ),
              ForfeitProcessingStepper(currentStep: currentStep, isDark: isDark),
              _buildStepContent(
                currentStep: currentStep,
                scheduleEntriesAsync: scheduleEntriesAsync,
                selectedEntry: selectedEntry,
                previewEmployeesAsync: previewEmployeesAsync,
                processingSummaryAsync: processingSummaryAsync,
                isDark: isDark,
                onEntrySelected: (entry) {
                  ref.read(forfeitScheduleNotifierProvider.notifier).selectEntry(entry);
                },
              ),
              SizedBox(height: 80.h), // Space for the fixed button
            ],
          ),
        ),
        if (currentStep == ForfeitProcessingStep.previewReview)
          Positioned(
            bottom: 24.h,
            left: 24.w,
            right: 24.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton.outline(
                  label: 'Back',
                  onPressed: () {
                    ref.read(forfeitProcessingStepProvider.notifier).setStep(ForfeitProcessingStep.upcomingForfeits);
                  },
                ),
                AppButton.primary(
                  label: 'Run Forfeit Process',
                  onPressed: () {
                    ref.read(forfeitProcessingStepProvider.notifier).nextStep();
                  },
                ),
              ],
            ),
          )
        else
          Positioned(
            bottom: 24.h,
            right: 24.w,
            child: AppButton.primary(
              label: _getButtonLabel(currentStep),
              onPressed: () {
                ref.read(forfeitProcessingStepProvider.notifier).nextStep();
              },
            ),
          ),
      ],
    );
  }

  Widget _buildStepContent({
    required ForfeitProcessingStep currentStep,
    required AsyncValue<List<ForfeitScheduleEntry>> scheduleEntriesAsync,
    required ForfeitScheduleEntry? selectedEntry,
    required AsyncValue<List<ForfeitPreviewEmployee>> previewEmployeesAsync,
    required AsyncValue<ForfeitProcessingSummary> processingSummaryAsync,
    required bool isDark,
    required ValueChanged<ForfeitScheduleEntry> onEntrySelected,
  }) {
    switch (currentStep) {
      case ForfeitProcessingStep.upcomingForfeits:
        return scheduleEntriesAsync.when(
          data: (entries) => UpcomingForfeitsContent(
            scheduleEntries: entries,
            selectedEntry: selectedEntry,
            isDark: isDark,
            onEntrySelected: onEntrySelected,
          ),
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (error, stack) => Center(
            child: Padding(
              padding: EdgeInsets.all(40.h),
              child: Text(
                'Error loading forfeit schedule',
                style: TextStyle(color: isDark ? AppColors.errorTextDark : AppColors.error),
              ),
            ),
          ),
        );
      case ForfeitProcessingStep.previewReview:
        return previewEmployeesAsync.when(
          data: (employees) =>
              PreviewReviewContent(employees: employees, isDark: isDark, selectedScheduleEntry: selectedEntry),
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (error, stack) => Center(
            child: Padding(
              padding: EdgeInsets.all(40.h),
              child: Text(
                'Error loading preview data',
                style: TextStyle(color: isDark ? AppColors.errorTextDark : AppColors.error),
              ),
            ),
          ),
        );
      case ForfeitProcessingStep.confirmRun:
        return previewEmployeesAsync.when(
          data: (employees) => ConfirmRunContent(employees: employees),
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (error, stack) => Center(
            child: Padding(
              padding: EdgeInsets.all(40.h),
              child: Text(
                'Error loading preview data',
                style: TextStyle(color: isDark ? AppColors.errorTextDark : AppColors.error),
              ),
            ),
          ),
        );
      case ForfeitProcessingStep.resultsSummary:
        return processingSummaryAsync.when(
          data: (summary) => ProcessingSummaryCard(summary: summary, isDark: isDark),
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (error, stack) => Center(
            child: Padding(
              padding: EdgeInsets.all(40.h),
              child: Text(
                'Error loading processing summary',
                style: TextStyle(color: isDark ? AppColors.errorTextDark : AppColors.error),
              ),
            ),
          ),
        );
    }
  }
}
