import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_controller_provider.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_table_provider.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/interviews_permission_mixin.dart';
import 'package:grc/features/hiring/presentation/screens/interviews_tab/interviews_desktop_layout.dart';
import 'package:grc/features/hiring/presentation/screens/interviews_tab/interviews_mobile_layout.dart';
import 'package:grc/features/hiring/presentation/screens/interviews_tab/interviews_tablet_layout.dart';
import 'package:grc/features/hiring/presentation/widgets/schedule_interview/schedule_interview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterviewsTab extends ConsumerStatefulWidget {
  const InterviewsTab({super.key});

  @override
  ConsumerState<InterviewsTab> createState() => _InterviewsTabState();
}

class _InterviewsTabState extends ConsumerState<InterviewsTab> with InterviewsPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(interviewsControllerProvider).refreshInterviews();
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(interviewsControllerProvider).changeEnterprise(enterpriseId);
  }

  void _onScheduleInterviewPressed() {
    final enterpriseId = ref.read(interviewsTabEnterpriseIdProvider);
    ScheduleInterviewDialog.showCreateNew(
      context,
      enterpriseId: enterpriseId,
      onSuccess: () async => ref.read(interviewsControllerProvider).refreshInterviews(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewInterviews) {
      return const AppUnauthorizedState();
    }

    ref.watch(interviewsPageProvider);

    final selectedEnterpriseId = ref.watch(interviewsTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return InterviewsMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onScheduleInterviewPressed: _onScheduleInterviewPressed,
      );
    }

    if (layout.isTablet) {
      return InterviewsTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onScheduleInterviewPressed: _onScheduleInterviewPressed,
      );
    }

    return InterviewsDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onScheduleInterviewPressed: _onScheduleInterviewPressed,
    );
  }
}
