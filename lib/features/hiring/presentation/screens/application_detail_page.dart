import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/features/hiring/application/applications/controllers/application_detail_controller.dart';
import 'package:grc/features/hiring/application/applications/providers/application_detail_controller_provider.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/applications/states/application_detail_state.dart';
import 'package:grc/features/hiring/presentation/models/application_detail_data.dart';
import 'package:grc/features/hiring/presentation/models/application_table_row_data.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/detail/application_actions_card.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/detail/application_candidate_card.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/detail/application_detail_header.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/detail/application_details_card.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/detail/application_hiring_pipeline.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/detail/application_quick_stats_card.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/detail/application_requisition_card.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/detail/application_timeline_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ApplicationDetailPage extends ConsumerWidget {
  const ApplicationDetailPage({required this.application, super.key});

  final ApplicationTableRowData application;

  static const String routeName = 'application-detail';
  static const String path = 'application-detail';

  ApplicationDetailParams _detailParams(WidgetRef ref) {
    final enterpriseId = ref.read(applicationsTabEnterpriseIdProvider) ?? 1;
    return ApplicationDetailParams(enterpriseId: enterpriseId, applicationGuid: application.applicationGuid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final params = _detailParams(ref);
    final state = ref.watch(applicationDetailControllerProvider(params));
    final controller = ref.read(applicationDetailControllerProvider(params).notifier);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: state.isLoading && state.detail == null
            ? _buildLoading(context, isDark, loc)
            : state.error != null && state.detail == null
            ? _buildError(context, state.error!, loc, controller)
            : state.detail == null
            ? _buildError(context, 'Application not found', loc, controller)
            : _buildContent(context, state.detail!, isDark),
      ),
    );
  }

  Widget _buildLoading(BuildContext context, bool isDark, AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLoadingIndicator(
            type: LoadingType.fadingCircle,
            color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
            size: 48.r,
          ),
          Gap(16.h),
          Text(
            loc.loading,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message, AppLocalizations loc, ApplicationDetailNotifier controller) {
    return Center(
      child: DigifyErrorState(message: message, onRetry: controller.retry, retryLabel: loc.retry),
    );
  }

  Widget _buildContent(BuildContext context, ApplicationDetailData detail, bool isDark) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ApplicationDetailHeader(detail: detail),
          Gap(24.h),
          ApplicationHiringPipeline(detail: detail),
          Gap(24.h),
          if (isMobile)
            Column(
              children: [
                ApplicationDetailsCard(detail: detail),
                Gap(24.h),
                ApplicationCandidateCard(detail: detail),
                Gap(24.h),
                ApplicationRequisitionCard(detail: detail),
                Gap(24.h),
                ApplicationTimelineCard(detail: detail),
                Gap(24.h),
                ApplicationActionsCard(detail: detail),
                Gap(24.h),
                ApplicationQuickStatsCard(detail: detail),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      ApplicationDetailsCard(detail: detail),
                      Gap(24.h),
                      ApplicationCandidateCard(detail: detail),
                      Gap(24.h),
                      ApplicationRequisitionCard(detail: detail),
                      Gap(24.h),
                      ApplicationTimelineCard(detail: detail),
                    ],
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: Column(
                    children: [
                      ApplicationActionsCard(detail: detail),
                      Gap(24.h),
                      ApplicationQuickStatsCard(detail: detail),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
