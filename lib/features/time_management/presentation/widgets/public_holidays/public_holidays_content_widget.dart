import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/time_management/data/config/public_holidays_config.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/time_management/presentation/providers/public_holidays_provider.dart';
import 'package:grc/features/time_management/presentation/providers/public_holidays_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/monthly_holiday_group.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/monthly_holiday_group_mobile.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/public_holidays_action_bar.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/public_holidays_mobile_skeleton.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/public_holidays_skeleton.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/dialogs/create_holiday_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/dialogs/view_holiday_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/mappers/public_holiday_mapper.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/public_holidays_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class PublicHolidaysContentWidget extends ConsumerStatefulWidget {
  const PublicHolidaysContentWidget({super.key});

  @override
  ConsumerState<PublicHolidaysContentWidget> createState() => _PublicHolidaysContentWidgetState();
}

class _PublicHolidaysContentWidgetState extends ConsumerState<PublicHolidaysContentWidget>
    with PublicHolidaysPermissionMixin {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleDeleteHoliday(
    String holidayId,
    PublicHolidaysNotifier notifier,
    PublicHolidaysState state,
  ) async {
    final holidayIdInt = int.tryParse(holidayId);
    if (holidayIdInt == null) return;

    final holiday = state.holidays.firstWhere((h) => h.id == holidayIdInt, orElse: () => state.holidays.first);

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Delete Holiday',
      message: 'Are you sure you want to permanently delete this holiday?',
      itemName: holiday.nameEn,
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );

    if (confirmed == true && mounted) {
      notifier.deleteHoliday(holidayIdInt, hard: true);
    }
  }

  List<Widget> _buildHolidayGroups(
    BuildContext context,
    List<MonthlyHolidayGroupData> groups,
    PublicHolidaysNotifier notifier,
    PublicHolidaysState state,
    int enterpriseId,
    double spacing,
  ) {
    final isMobile = context.isMobileLayout;

    void onView(String id) {
      final holidayIdInt = int.tryParse(id);
      if (holidayIdInt == null) return;
      final holiday = notifier.getHolidayById(holidayIdInt);
      if (holiday != null) ViewHolidayDialog.show(context, holiday: holiday);
    }

    void onEdit(String id) {
      final holidayIdInt = int.tryParse(id);
      if (holidayIdInt == null) return;
      final holiday = notifier.getHolidayById(holidayIdInt);
      if (holiday != null) {
        CreateHolidayDialog.show(context, enterpriseId: enterpriseId, holiday: holiday);
      }
    }

    return groups.map((group) {
      final groupWidget = isMobile
          ? MonthlyHolidayGroupMobile(
              data: group,
              onViewHoliday: onView,
              onEditHoliday: onEdit,
              onDeleteHoliday: (id) => _handleDeleteHoliday(id, notifier, state),
            )
          : MonthlyHolidayGroup(
              data: group,
              onViewHoliday: onView,
              onEditHoliday: onEdit,
              onDeleteHoliday: (id) => _handleDeleteHoliday(id, notifier, state),
            );

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [groupWidget, Gap(spacing)]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveEnterpriseId = ref.watch(publicHolidaysTabEnterpriseIdProvider);

    if (effectiveEnterpriseId == null) {
      return const Center(
        child: TimeManagementEmptyStateWidget(message: 'Please select an enterprise to view public holidays'),
      );
    }

    final state = ref.watch(publicHolidaysNotifierProvider(effectiveEnterpriseId));
    final notifier = ref.read(publicHolidaysNotifierProvider(effectiveEnterpriseId).notifier);
    final holidayGroups = PublicHolidayMapper.groupByMonth(state.holidays);
    PublicHolidayMapper.calculateStats(state.holidays);
    final selectedYear = state.selectedYear ?? PublicHolidaysConfig.defaultYear;
    final spacing = ResponsiveHelper.getTabSectionSpacing(context);

    ref.listen<PublicHolidaysState>(publicHolidaysNotifierProvider(effectiveEnterpriseId), (previous, next) {
      if (previous == null) return;

      if (next.deleteSuccessMessage != null && previous.deleteSuccessMessage != next.deleteSuccessMessage) {
        ToastService.success(context, next.deleteSuccessMessage!);
        notifier.clearSideEffects();
      }
      if (next.deleteErrorMessage != null && previous.deleteErrorMessage != next.deleteErrorMessage) {
        ToastService.error(context, next.deleteErrorMessage!);
        notifier.clearSideEffects();
      }
      if (next.createSuccessMessage != null && previous.createSuccessMessage != next.createSuccessMessage) {
        ToastService.success(context, next.createSuccessMessage!);
        notifier.clearSideEffects();
      }
      if (next.createErrorMessage != null && previous.createErrorMessage != next.createErrorMessage) {
        ToastService.error(context, next.createErrorMessage!);
        notifier.clearSideEffects();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PublicHolidaysActionBar(
          searchController: _searchController,
          selectedYear: selectedYear,
          selectedType: state.selectedType ?? PublicHolidaysConfig.defaultType,
          availableYears: PublicHolidaysConfig.availableYears,
          availableTypes: PublicHolidaysConfig.availableTypes,
          onYearChanged: (year) => notifier.setSelectedYear(year),
          onTypeChanged: (type) {
            final normalized = type ?? PublicHolidaysConfig.defaultType;
            notifier.setSelectedType(normalized == PublicHolidaysConfig.defaultType ? null : normalized);
          },
          onSearchChanged: (query) => notifier.setSearchQuery(query),
        ),
        Gap(spacing),
        if (state.isLoading)
          context.isMobileLayout
              ? const PublicHolidaysMobileSkeleton(groupCount: 3, holidaysPerGroup: 2)
              : const PublicHolidaysSkeleton(groupCount: 3, holidaysPerGroup: 2)
        else if (state.hasError)
          DigifyErrorState(message: state.errorMessage ?? 'An error occurred', onRetry: notifier.refresh)
        else if (holidayGroups.isEmpty)
          if (context.isMobileLayout)
            Builder(
              builder: (context) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return MobileStateCard(
                  isDark: isDark,
                  borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                  iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
                  iconPath: Assets.icons.sidebar.publicHolidays.path,
                  title: 'No Public Holidays Found',
                  subtitle: 'No public holidays found. Create your first holiday to get started.',
                );
              },
            )
          else
            const Center(
              child: TimeManagementEmptyStateWidget(
                message: 'No public holidays found. Create your first holiday to get started.',
              ),
            )
        else
          ..._buildHolidayGroups(context, holidayGroups, notifier, state, effectiveEnterpriseId, spacing),
        Gap(spacing),
        if (state.totalPages > 0) ...[
          PaginationControls.fromPaginationInfo(
            paginationInfo: PaginationInfo(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              totalItems: state.totalItems,
              pageSize: state.pageSize,
              hasNext: state.hasNextPage,
              hasPrevious: state.hasPreviousPage,
            ),
            currentPage: state.currentPage,
            pageSize: state.pageSize,
            onPrevious: state.hasPreviousPage ? () => notifier.goToPage(state.currentPage - 1) : null,
            onNext: state.hasNextPage ? () => notifier.goToPage(state.currentPage + 1) : null,
            style: PaginationStyle.simple,
          ),
          Gap(spacing),
        ],
      ],
    );
  }
}
