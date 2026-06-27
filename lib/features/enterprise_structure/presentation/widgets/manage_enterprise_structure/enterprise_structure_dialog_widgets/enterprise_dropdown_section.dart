import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/enterprises_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/shared/enterprise_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EnterpriseDropdownSection extends ConsumerWidget {
  final EditEnterpriseStructureState formState;
  final EditEnterpriseStructureNotifier formNotifier;
  final int? initialEnterpriseId;

  const EnterpriseDropdownSection({
    super.key,
    required this.formState,
    required this.formNotifier,
    this.initialEnterpriseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprisesState = ref.watch(enterprisesProvider);
    final isDark = context.isDark;

    if (enterprisesState.isLoading) {
      return Skeletonizer(
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[300],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            Gap(8.h),
            Container(
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Gap(16.h),
          ],
        ),
      );
    }

    final preferredId = formState.selectedEnterpriseId ?? initialEnterpriseId;
    final selectedId = preferredId != null && enterprisesState.enterprises.any((e) => e.id == preferredId)
        ? preferredId
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        EnterpriseDropdown(
          label: 'Enterprise',
          isRequired: true,
          selectedEnterpriseId: selectedId,
          enterprises: enterprisesState.enterprises,
          isLoading: false,
          readOnly: false,
          onChanged: formNotifier.updateSelectedEnterprise,
          errorText: enterprisesState.hasError ? enterprisesState.errorMessage : null,
        ),
        Gap(16.h),
      ],
    );
  }
}
