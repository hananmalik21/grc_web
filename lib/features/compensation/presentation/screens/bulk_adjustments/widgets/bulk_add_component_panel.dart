import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_add_component_panel_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_form_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_eligible_plans_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_employee_components_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BulkAddComponentPanel extends ConsumerWidget {
  const BulkAddComponentPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final panelState = ref.watch(bulkAddComponentPanelProvider);
    final panelNotifier = ref.read(bulkAddComponentPanelProvider.notifier);
    final formNotifier = ref.read(bulkAdjustmentsFormProvider.notifier);

    if (panelState.isLoadingPlans) {
      return Text(localizations.bulkAdjustmentsEligiblePlansLoading, style: Theme.of(context).textTheme.bodySmall);
    }

    if (!panelState.hasPlans) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: DigifySelectFieldWithLabel<CompensationPlan>(
                label: localizations.bulkAdjustmentsAddComponentFromPlanLabel,
                hint: localizations.bulkAdjustmentsSelectPlanHint,
                value: panelState.selectedPlan,
                items: panelState.plans,
                itemLabelBuilder: (plan) => '${plan.planCode} - ${plan.planName}',
                onChanged: panelNotifier.selectPlan,
              ),
            ),
            Gap(12.w),
            AppButton.primary(
              label: localizations.bulkAdjustmentsAddComponentsButton,
              svgPath: Assets.icons.addDivisionIcon.path,
              onPressed: panelState.canAddComponents
                  ? () {
                      final plan = panelState.selectedPlan;
                      if (plan == null) return;

                      final eligibleByEmployee = ref.read(bulkEligiblePlansByEmployeeProvider).valueOrNull ?? [];
                      formNotifier.addComponentsFromPlan(
                        plan: plan,
                        eligibleByEmployee: eligibleByEmployee,
                        employeeLabels: ref.read(bulkSelectedEmployeeLabelsProvider),
                        employeeNumericIds: ref.read(bulkSelectedEmployeeNumericIdsProvider),
                        components: panelState.availableComponents,
                      );
                      panelNotifier.clearSelection();
                    }
                  : null,
            ),
          ],
        ),
        if (panelState.allComponentsAdded) ...[
          Gap(8.h),
          Text(localizations.bulkAdjustmentsAllPlanComponentsAdded, style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    );
  }
}
