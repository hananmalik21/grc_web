import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/employee_search_field.dart';
import '../../../providers/user_management/user_form_provider.dart';
import '../../../providers/user_management/user_management_enterprise_provider.dart';
import '../../../widgets/user_management/create_user/account_info_section.dart';
import '../../../widgets/user_management/create_user/contact_info_section.dart';
import '../../../widgets/user_management/create_user/employment_info_section.dart';
import '../../../widgets/user_management/user_form_section.dart';

class AccountInformationTab extends ConsumerWidget {
  const AccountInformationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    final selectedEnterpriseId = ref.watch(userManagementEnterpriseIdProvider);
    final selectedEmployee = notifier.selectedEmployeeForSearch(enterpriseId: selectedEnterpriseId);

    final loadingBody = Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLoadingIndicator(size: 48.r),
          Gap(16.h),
          Text(
            l10n.loadingEmployeeDetails,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserFormSection(
          isDark: Theme.of(context).brightness == Brightness.dark,
          header: SectionHeaderCard(
            title: l10n.createUserEmployeeSelectionTitle,
            iconAssetPath: Assets.icons.employeesBlueIcon.path,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (selectedEnterpriseId == null)
                Text(l10n.selectEnterpriseFirst, style: theme.textTheme.bodyMedium)
              else
                EmployeeSearchField(
                  label: l10n.createUserSelectEmployeeFieldLabel,
                  hintText: l10n.typeToSearchEmployees,
                  isRequired: false,
                  enterpriseId: selectedEnterpriseId,
                  selectedEmployee: selectedEmployee,
                  onEmployeeSelected: (employee) async {
                    if (state.isFetchingEmployeeDetails) return;
                    await notifier.fetchAndApplySelectedEmployee(
                      employeeId: employee.id,
                      employeeGuid: employee.guid,
                      employeeName: employee.fullName,
                      enterpriseId: selectedEnterpriseId,
                    );
                  },
                ),
            ],
          ),
        ),
        if (state.isFetchingEmployeeDetails) ...[
          Gap(24.h),
          loadingBody,
        ] else ...[
          Gap(24.h),
          const AccountInfoSection(),
          Gap(24.h),
          const ContactInfoSection(),
          if (state.hasEmployeeDetailsLoaded) ...[Gap(24.h), const EmploymentInfoSection()],
        ],
      ],
    );
  }
}
