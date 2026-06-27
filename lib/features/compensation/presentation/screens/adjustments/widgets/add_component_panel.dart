import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/add_component_panel_provider.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/create_adjustment_form_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddComponentPanel extends ConsumerWidget {
  final String employeeGuid;

  const AddComponentPanel({super.key, required this.employeeGuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelState = ref.watch(addComponentPanelProvider(employeeGuid));
    final panelNotifier = ref.read(addComponentPanelProvider(employeeGuid).notifier);
    final formNotifier = ref.read(createAdjustmentFormProvider.notifier);

    if (!panelState.hasPlans) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: DigifySelectFieldWithLabel<CompensationPlan>(
                label: 'Add Component from Plan',
                hint: 'Select a plan...',
                value: panelState.selectedPlan,
                items: panelState.plans,
                itemLabelBuilder: (p) => '${p.planCode} - ${p.planName}',
                onChanged: panelNotifier.selectPlan,
              ),
            ),
            Gap(12.w),
            AppButton.primary(
              label: 'Add Components',
              svgPath: Assets.icons.addDivisionIcon.path,
              onPressed: panelState.canAddComponents
                  ? () {
                      for (final c in panelState.availableComponents) {
                        formNotifier.addComponentFromPlan(c, planId: panelState.selectedPlan!.planId);
                      }
                      panelNotifier.clearSelection();
                    }
                  : null,
            ),
          ],
        ),
        if (panelState.allComponentsAdded) ...[
          Gap(8.h),
          Text('All components from this plan have already been added.', style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    );
  }
}
