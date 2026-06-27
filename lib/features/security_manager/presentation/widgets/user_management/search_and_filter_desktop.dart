import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/enums/user_management_enums.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/forms/digify_select_field.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../data/models/user_management/user_managment_status.dart';
import '../../providers/user_management/user_management_provider.dart';

class UserManagementSearchAndFilterDesktop extends ConsumerStatefulWidget {
  const UserManagementSearchAndFilterDesktop({super.key});

  @override
  ConsumerState<UserManagementSearchAndFilterDesktop> createState() =>
      _UserManagementSearchAndFilterDesktopState();
}

class _UserManagementSearchAndFilterDesktopState
    extends ConsumerState<UserManagementSearchAndFilterDesktop> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(userManagementProvider).searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final statusFilter = ref.watch(userManagementProvider.select((s) => s.statusFilter));
    final notifier = ref.read(userManagementProvider.notifier);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: _searchController,
            hintText: 'Search by name, email, or user ID...',
            onChanged: notifier.setSearchQuery,
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 220.w,
                child: DigifySelectField<UserManagementStatus?>(
                  hint: 'All Status',
                  value: statusFilter,
                  items: userManagementStatusFilterItems,
                  itemLabelBuilder: (item) => item == null ? 'All Status' : item.displayName,
                  onChanged: notifier.setStatusFilter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
