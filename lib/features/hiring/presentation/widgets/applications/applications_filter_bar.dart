import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_controller_provider.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_lookups_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ApplicationsFilterBar extends ConsumerStatefulWidget {
  const ApplicationsFilterBar({super.key});

  @override
  ConsumerState<ApplicationsFilterBar> createState() => _ApplicationsFilterBarState();
}

class _ApplicationsFilterBarState extends ConsumerState<ApplicationsFilterBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(applicationsControllerProvider);
    final controller = ref.read(applicationsControllerProvider.notifier);

    final statuses = ref.watch(applicationStatusLookupProvider);
    final sources = ref.watch(applicationSourceLookupProvider);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DigifyTextField.search(
              controller: _searchController,
              hintText: 'Search by candidate or requisition...',
              onChanged: controller.setSearch,
            ),
          ),
          Gap(16.w),
          Expanded(
            child: DigifySelectField<String?>(
              hint: 'All Status',
              value: state.status,
              items: [null, ...statuses],
              itemLabelBuilder: (status) => status ?? 'All Status',
              onChanged: controller.setStatus,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: DigifySelectField<String?>(
              hint: 'All Sources',
              value: state.source,
              items: [null, ...sources],
              itemLabelBuilder: (source) => source ?? 'All Sources',
              onChanged: controller.setSource,
            ),
          ),
        ],
      ),
    );
  }
}
