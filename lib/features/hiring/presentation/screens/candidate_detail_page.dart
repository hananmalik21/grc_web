import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/breakpoints.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidate_detail_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/candidate_detail_header.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/candidate_applications_tab.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/candidate_communications_tab.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/candidate_education_tab.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/candidate_experience_tab.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/candidate_notes_tab.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/candidate_overview_tab.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/candidate_skills_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CandidateDetailPage extends ConsumerWidget {
  const CandidateDetailPage({super.key, required this.candidate});

  final CandidateData candidate;

  static const String routeName = 'candidate-detail';
  static const String path = 'candidate-detail';
  static const int _tabCount = 7;

  GetCandidateDetailParams _detailParams(WidgetRef ref) {
    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider) ?? 1;
    return GetCandidateDetailParams(enterpriseId: enterpriseId, candidateGuid: candidate.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final detailParams = _detailParams(ref);
    final detailAsync = ref.watch(getCandidateDetailDataProvider(detailParams));
    final loc = AppLocalizations.of(context)!;

    ref.listen(getCandidateDetailDataProvider(detailParams), (previous, next) {
      if (next is AsyncError && next != previous) {
        ToastService.error(context, next.error.toString());
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      body: SafeArea(
        child: detailAsync.when(
          data: (loadedCandidate) => _buildContent(context, ref, loadedCandidate, isDark),
          loading: () => _buildLoading(context, isDark, loc),
          error: (error, _) => _buildError(context, ref, error, loc, detailParams),
        ),
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

  Widget _buildError(
    BuildContext context,
    WidgetRef ref,
    Object error,
    AppLocalizations loc,
    GetCandidateDetailParams detailParams,
  ) {
    return Center(
      child: DigifyErrorState(
        message: error.toString(),
        onRetry: () => ref.invalidate(getCandidateDetailDataProvider(detailParams)),
        retryLabel: loc.retry,
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, CandidateData loadedCandidate, bool isDark) {
    final isMobile = AppBreakpoints.fromContext(context).isMobile;
    final tabIndex = ref.watch(candidateDetailTabIndexProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.w : 24.w, vertical: isMobile ? 16.h : 24.h),
                  child: CandidateDetailHeader(candidate: loadedCandidate, isDark: isDark, isMobile: isMobile),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: isMobile ? 16.w : 24.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: AppShadows.primaryShadow,
                  ),
                  child: DefaultTabController(
                    length: _tabCount,
                    initialIndex: tabIndex,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTabBar(context, ref, isDark, isMobile, tabIndex, loadedCandidate),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: _buildTabContent(tabIndex, isDark, loadedCandidate),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(24.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    bool isMobile,
    int currentIndex,
    CandidateData loadedCandidate,
  ) {
    final unselectedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final applicationCount = loadedCandidate.applications.length;

    return TabBar(
      onTap: (index) => ref.read(candidateDetailTabIndexProvider.notifier).state = index,
      isScrollable: isMobile,
      tabAlignment: isMobile ? TabAlignment.start : TabAlignment.fill,
      tabs: [
        const Tab(text: 'Overview'),
        const Tab(text: 'Experience'),
        const Tab(text: 'Education'),
        const Tab(text: 'Skills & Assessments'),
        Tab(text: 'Applications ($applicationCount)'),
        const Tab(text: 'Communications'),
        const Tab(text: 'Notes'),
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

  Widget _buildTabContent(int index, bool isDark, CandidateData loadedCandidate) {
    final child = switch (index) {
      0 => CandidateOverviewTab(candidate: loadedCandidate, isDark: isDark),
      1 => CandidateExperienceTab(candidate: loadedCandidate, isDark: isDark),
      2 => CandidateEducationTab(candidate: loadedCandidate, isDark: isDark),
      3 => CandidateSkillsTab(candidate: loadedCandidate, isDark: isDark),
      4 => CandidateApplicationsTab(candidate: loadedCandidate, isDark: isDark),
      5 => CandidateCommunicationsTab(candidate: loadedCandidate, isDark: isDark),
      6 => CandidateNotesTab(candidate: loadedCandidate, isDark: isDark),
      _ => const SizedBox.shrink(),
    };
    return KeyedSubtree(key: ValueKey<int>(index), child: child);
  }
}
