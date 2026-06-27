import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/employee_management/presentation/models/employee_detail_display_data.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_documents_download_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_full_details_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_mobile_header.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/tabs/compensation_benefits_tab_content.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/tabs/documents_banking_tab_content.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/tabs/employment_details_tab_content.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/tabs/personal_info_tab_content.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeDetailMobileScreen extends ConsumerStatefulWidget {
  const EmployeeDetailMobileScreen({super.key, required this.employee});

  final EmployeeListItem employee;

  static const int _tabCount = 4;

  @override
  ConsumerState<EmployeeDetailMobileScreen> createState() => _EmployeeDetailMobileScreenState();
}

class _EmployeeDetailMobileScreenState extends ConsumerState<EmployeeDetailMobileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: EmployeeDetailMobileScreen._tabCount, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fullDetailsAsync = ref.watch(employeeFullDetailsProvider(widget.employee.id));

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: fullDetailsAsync.when(
        data: (EmployeeFullDetails? fullDetails) {
          final displayData = EmployeeDetailDisplayData(employee: widget.employee, fullDetails: fullDetails);
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                        child: EmployeeDetailMobileHeader(
                          displayData: displayData,
                          isDark: isDark,
                          isDownloadingDocuments: ref.watch(employeeDocumentsDownloadNotifierProvider),
                          onDownloadDocuments: (ctx) => ref
                              .read(employeeDocumentsDownloadNotifierProvider.notifier)
                              .downloadAllDocuments(ctx, fullDetails, widget.employee.id),
                        ),
                      ),
                      Gap(12.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: AppShadows.primaryShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _MobileTabBar(controller: _tabController, isDark: isDark),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              child: _buildTabContent(_tabController.index, isDark, fullDetails),
                            ),
                          ],
                        ),
                      ),
                      Gap(24.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLoadingIndicator(size: 48.r),
              Gap(16.h),
              Text(
                AppLocalizations.of(context)!.pleaseWait,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        error: (Object err, StackTrace _) => Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Text(err.toString(), style: context.textTheme.bodyMedium?.copyWith(color: AppColors.error)),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(int index, bool isDark, EmployeeFullDetails? fullDetails) {
    final child = switch (index) {
      0 => PersonalInfoTabContent(isDark: isDark, fullDetails: fullDetails, wrapInScrollView: false),
      1 => EmploymentDetailsTabContent(isDark: isDark, fullDetails: fullDetails, wrapInScrollView: false),
      2 => CompensationBenefitsTabContent(
        isDark: isDark,
        employeeGuid: widget.employee.id,
        fullDetails: fullDetails,
        wrapInScrollView: false,
      ),
      3 => DocumentsBankingTabContent(isDark: isDark, fullDetails: fullDetails, wrapInScrollView: false),
      _ => const SizedBox.shrink(),
    };
    return KeyedSubtree(key: ValueKey<int>(index), child: child);
  }
}

class _MobileTabBar extends StatelessWidget {
  const _MobileTabBar({required this.controller, required this.isDark});

  final TabController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final unselectedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: [
        _tab(context, Assets.icons.leaveManagement.myLeave.path, 'Personal', unselectedColor),
        _tab(context, Assets.icons.deiDashboardIcon.path, 'Employment', unselectedColor),
        _tab(context, Assets.icons.attendanceIcon.path, 'Compensation', unselectedColor),
        _tab(context, Assets.icons.leaveManagement.forfeitReports.path, 'Documents', unselectedColor),
      ],
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.w, color: AppColors.primary),
      ),
      dividerColor: AppColors.textPlaceholder,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: AppColors.primary,
      unselectedLabelColor: unselectedColor,
      labelStyle: context.textTheme.labelLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
      unselectedLabelStyle: context.textTheme.labelLarge?.copyWith(color: unselectedColor),
    );
  }

  Widget _tab(BuildContext context, String iconPath, String label, Color unselectedColor) {
    return Tab(
      child: Builder(
        builder: (context) {
          final color = DefaultTextStyle.of(context).style.color ?? unselectedColor;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(assetPath: iconPath, width: 16.w, height: 16.h, color: color),
              Gap(6.w),
              Text(label),
            ],
          );
        },
      ),
    );
  }
}
