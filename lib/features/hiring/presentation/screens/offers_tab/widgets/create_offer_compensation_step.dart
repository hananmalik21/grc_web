import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/compensation_plans_selection_notifier.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/add_compensation_plans_section.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_calculator_sidebar.dart';
import 'package:grc/features/hiring/application/offers/providers/create_offer_compensation_providers.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateOfferCompensationStep extends ConsumerStatefulWidget {
  const CreateOfferCompensationStep({super.key});

  @override
  ConsumerState<CreateOfferCompensationStep> createState() => _CreateOfferCompensationStepState();
}

class _CreateOfferCompensationStepState extends ConsumerState<CreateOfferCompensationStep> {
  final TextEditingController _planSearchController = TextEditingController();

  @override
  void dispose() {
    _planSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(createOfferCompensationProvider);
    ref.watch(createOfferEligiblePlansRequestProvider);

    final position = ref.watch(createOfferProvider.select((s) => s.selectedPosition));
    final budgetedMin = CompensationPlansSelectionNotifier.parseBudget(position?.budgetedMin);
    final budgetedMax = CompensationPlansSelectionNotifier.parseBudget(position?.budgetedMax);

    return Builder(
      builder: (context) {
        final isTwoColumn = context.isDesktopLayout;

        final leftColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddCompensationPlansSection(
              planSearchController: _planSearchController,
              showEffectiveDateFields: false,
              isCreateOfferFlow: true,
              plansProvider: createOfferCompensationProvider,
              budgetedMinKd: budgetedMin,
              budgetedMaxKd: budgetedMax,
            ),
            Gap(24.h),
          ],
        );

        final rightColumn = CompensationCalculatorSidebar(
          showActions: false,
          plansProvider: createOfferCompensationProvider,
        );

        if (!isTwoColumn) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [leftColumn, Gap(24.h), rightColumn]);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: leftColumn),
            Gap(24.w),
            Expanded(flex: 1, child: rightColumn),
          ],
        );
      },
    );
  }
}
