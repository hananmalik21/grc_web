import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_table_rows_provider.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/create_compensation_plan_screen.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/compensation_plans_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CompensationPlansHeader extends ConsumerWidget with CompensationPlansPermissionMixin {
  const CompensationPlansHeader({this.onCreatePlanPressed, super.key});

  final Future<void> Function()? onCreatePlanPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DigifyTabHeader(
      title: 'Compensation Plans',
      description:
          'Create, configure, simulate, validate, approve, and manage enterprise compensation plans including salary structures, allowances, benefits, and incentive models.',
      trailing: Wrap(
        alignment: WrapAlignment.end,
        runSpacing: 12.h,
        spacing: 12.w,
        children: canCreateCompensationPlan
            ? [
                AppButton.primary(
                  label: 'Create Plan',
                  width: 168.w,
                  svgPath: Assets.icons.addDivisionIcon.path,
                  onPressed: () async =>
                      onCreatePlanPressed == null ? _handleCreatePlan(context, ref) : onCreatePlanPressed!(),
                ),
              ]
            : [],
      ),
    );
  }

  Future<void> _handleCreatePlan(BuildContext context, WidgetRef ref) async {
    final created = await context.pushNamed<bool>(CreateCompensationPlanScreen.routeName);
    if (created != true) return;

    ref.invalidate(compensationPlansPageProvider);
  }
}
