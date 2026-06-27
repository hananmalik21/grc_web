import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_tab_provider.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/element_entries_data_table.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/element_entries_filter_bar.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/element_entries_placeholder_body.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/element_entries_employee_loading_body.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/mobile/element_entries_list_mobile.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/mobile/element_entries_toolbar_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ElementEntriesContent extends ConsumerWidget {
  const ElementEntriesContent({required this.padding, required this.header, super.key});

  final EdgeInsetsGeometry padding;
  final Widget header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = context.screenLayout.isMobile;
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);
    final hasSelectedEmployee = ref.watch(elementEntriesTabProvider.select((s) => s.selectedEmployee != null));
    final isLoadingEmployeeDetails = ref.watch(elementEntriesTabProvider.select((s) => s.isLoadingEmployeeDetails));

    return Container(
      color: context.isDark ? AppColors.backgroundDark : AppColors.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Gap(sectionSpacing),
            if (isLoadingEmployeeDetails)
              const ElementEntriesEmployeeLoadingBody()
            else if (!hasSelectedEmployee)
              const ElementEntriesPlaceholderBody()
            else if (isMobile) ...[
              const ElementEntriesToolbarMobile(),
              Gap(sectionSpacing),
              const ElementEntriesListMobile(),
            ] else ...[
              const ElementEntriesFilterBar(),
              Gap(sectionSpacing),
              const ElementEntriesDataTable(),
            ],
          ],
        ),
      ),
    );
  }
}
