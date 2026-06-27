import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/payroll/domain/models/flow_monitor_parameters.dart';
import 'package:grc/features/payroll/domain/models/flow_monitor_task.dart';
import 'package:grc/gen/assets.gen.dart';

class FlowMonitorStatCardData {
  final String title;
  final String value;
  final String iconPath;

  const FlowMonitorStatCardData({required this.title, required this.value, required this.iconPath});
}

class FlowMonitorActivityTabData {
  const FlowMonitorActivityTabData({
    required this.tab,
    required this.label,
    required this.count,
    required this.iconPath,
  });

  final FlowMonitorActivityTab tab;
  final String label;
  final int count;
  final String iconPath;
}

class FlowMonitorTabConfig {
  FlowMonitorTabConfig._();

  static List<FlowMonitorStatCardData> buildStatCards({
    required AppLocalizations loc,
    int totalTasks = 7,
    int completed = 0,
    int inProgress = 0,
    int pending = 7,
  }) {
    return [
      FlowMonitorStatCardData(
        title: loc.payrollFlowMonitorTotalTasks,
        value: '$totalTasks',
        iconPath: Assets.icons.tasksIcon.path,
      ),
      FlowMonitorStatCardData(
        title: loc.payrollFlowMonitorCompleted,
        value: '$completed',
        iconPath: Assets.icons.descriptionIcon.path,
      ),
      FlowMonitorStatCardData(
        title: loc.payrollFlowMonitorInProgress,
        value: '$inProgress',
        iconPath: Assets.icons.circleIcon.path,
      ),
      FlowMonitorStatCardData(
        title: loc.payrollFlowMonitorPending,
        value: '$pending',
        iconPath: Assets.icons.clockIcon.path,
      ),
    ];
  }

  static List<FlowMonitorActivityTabData> buildActivityTabs({
    required AppLocalizations loc,
    required List<FlowMonitorTask> tasks,
  }) {
    return [
      FlowMonitorActivityTabData(
        tab: FlowMonitorActivityTab.overallActivities,
        label: loc.payrollFlowMonitorOverallActivities,
        count: tasks.length,
        iconPath: Assets.icons.tasksIcon.path,
      ),
      FlowMonitorActivityTabData(
        tab: FlowMonitorActivityTab.criticalAlerts,
        label: loc.payrollFlowMonitorCriticalAlerts,
        count: 0,
        iconPath: Assets.icons.header.notificationBell.path,
      ),
      FlowMonitorActivityTabData(
        tab: FlowMonitorActivityTab.completedWithAlerts,
        label: loc.payrollFlowMonitorCompletedWithAlerts,
        count: 0,
        iconPath: Assets.icons.checkCircleGreen.path,
      ),
      FlowMonitorActivityTabData(
        tab: FlowMonitorActivityTab.relatedFlows,
        label: loc.payrollFlowMonitorRelatedFlows,
        count: 0,
        iconPath: Assets.icons.treeViewIcon.path,
      ),
    ];
  }

  static List<FlowMonitorTask> buildMockTasks(AppLocalizations loc) {
    final notAvailable = loc.payrollFlowMonitorNotAvailable;
    final owner = loc.payrollFlowMonitorOwnerPayrollManager;
    final loggingLevel = loc.payrollFlowMonitorLoggingStandard;
    final ownerType = loc.payrollFlowMonitorOwnerTypeRole;

    return [
      FlowMonitorTask(
        number: 1,
        title: loc.payrollFlowMonitorTaskRunRetroactiveNotificationReport,
        type: FlowMonitorTaskType.report,
        activity: loc.payrollFlowMonitorTaskRunRetroactiveNotificationReport,
        submittedBy: notAvailable,
        submissionDate: notAvailable,
        owner: owner,
        loggingLevel: loggingLevel,
        ownerType: ownerType,
        records: notAvailable,
      ),
      FlowMonitorTask(
        number: 2,
        title: loc.payrollFlowMonitorTaskRunRetroactiveEntriesReport,
        type: FlowMonitorTaskType.report,
        activity: loc.payrollFlowMonitorTaskRunRetroactiveEntriesReport,
        submittedBy: notAvailable,
        submissionDate: notAvailable,
        owner: owner,
        loggingLevel: loggingLevel,
        ownerType: ownerType,
        records: notAvailable,
      ),
      FlowMonitorTask(
        number: 3,
        title: loc.payrollFlowMonitorTaskRecalculatePayrollRetroactive,
        type: FlowMonitorTaskType.process,
        activity: loc.payrollFlowMonitorTaskRecalculatePayrollRetroactive,
        submittedBy: notAvailable,
        submissionDate: notAvailable,
        owner: owner,
        loggingLevel: loggingLevel,
        ownerType: ownerType,
        records: notAvailable,
      ),
      FlowMonitorTask(
        number: 4,
        title: loc.payrollFlowMonitorTaskCalculatePayroll,
        type: FlowMonitorTaskType.process,
        activity: loc.payrollFlowMonitorTaskCalculatePayroll,
        submittedBy: notAvailable,
        submissionDate: notAvailable,
        owner: owner,
        loggingLevel: loggingLevel,
        ownerType: ownerType,
        records: notAvailable,
      ),
      FlowMonitorTask(
        number: 5,
        title: loc.payrollFlowMonitorTaskPayrollCostingReport,
        type: FlowMonitorTaskType.report,
        activity: loc.payrollFlowMonitorTaskPayrollCostingReport,
        submittedBy: notAvailable,
        submissionDate: notAvailable,
        owner: owner,
        loggingLevel: loggingLevel,
        ownerType: ownerType,
        records: notAvailable,
      ),
      FlowMonitorTask(
        number: 6,
        title: loc.payrollFlowMonitorTaskCalculatePrepayments,
        type: FlowMonitorTaskType.process,
        activity: loc.payrollFlowMonitorTaskCalculatePrepayments,
        submittedBy: notAvailable,
        submissionDate: notAvailable,
        owner: owner,
        loggingLevel: loggingLevel,
        ownerType: ownerType,
        records: notAvailable,
      ),
      FlowMonitorTask(
        number: 7,
        title: loc.payrollFlowMonitorTaskArchivePeriodicPayrollResults,
        type: FlowMonitorTaskType.process,
        activity: loc.payrollFlowMonitorTaskArchivePeriodicPayrollResults,
        submittedBy: notAvailable,
        submissionDate: notAvailable,
        owner: owner,
        loggingLevel: loggingLevel,
        ownerType: ownerType,
        records: notAvailable,
      ),
    ];
  }

  static List<FlowMonitorTask> tasksForTab(FlowMonitorActivityTab tab, List<FlowMonitorTask> allTasks) {
    return switch (tab) {
      FlowMonitorActivityTab.overallActivities => allTasks,
      FlowMonitorActivityTab.criticalAlerts => const [],
      FlowMonitorActivityTab.completedWithAlerts => const [],
      FlowMonitorActivityTab.relatedFlows => const [],
    };
  }

  static String statusLabel(AppLocalizations loc, FlowMonitorTaskStatus status) {
    return switch (status) {
      FlowMonitorTaskStatus.pending => loc.payrollFlowMonitorPending,
      FlowMonitorTaskStatus.inProgress => loc.payrollFlowMonitorInProgress,
      FlowMonitorTaskStatus.completed => loc.payrollFlowMonitorCompleted,
    };
  }

  static String taskTypeLabel(AppLocalizations loc, FlowMonitorTaskType type) {
    return switch (type) {
      FlowMonitorTaskType.report => loc.payrollFlowMonitorTaskTypeReport,
      FlowMonitorTaskType.process => loc.payrollFlowMonitorTaskTypeProcess,
    };
  }

  static FlowMonitorParameters buildMockParameters(AppLocalizations loc) {
    final empty = loc.payrollFlowMonitorNotAvailable;

    return FlowMonitorParameters(
      fields: [
        FlowMonitorParameterField(label: loc.payrollSubmitPayrollFlowScope, value: loc.payrollFlowMonitorScopeDetail),
        FlowMonitorParameterField(
          label: loc.payrollSubmitPayrollFlowPayroll,
          value: loc.payrollFlowMonitorParametersPayrollValue,
        ),
        FlowMonitorParameterField(
          label: loc.payrollSubmitPayrollFlowPayrollPeriod,
          value: loc.payrollFlowMonitorParametersPayrollPeriodValue,
        ),
        FlowMonitorParameterField(label: loc.payrollSubmitPayrollFlowProcessStartDate, value: empty, isEmpty: true),
        FlowMonitorParameterField(label: loc.payrollSubmitPayrollFlowProcessEndDate, value: empty, isEmpty: true),
        FlowMonitorParameterField(label: loc.payrollSubmitPayrollFlowDateEarned, value: empty, isEmpty: true),
        FlowMonitorParameterField(
          label: loc.payrollSubmitPayrollFlowConsolidationGroup,
          value: loc.payrollPersonResultsTaskDetailConsolidationGroupValue,
        ),
        FlowMonitorParameterField(
          label: loc.payrollSubmitPayrollFlowRunType,
          value: loc.payrollFlowMonitorParametersRunTypeRegular,
        ),
        FlowMonitorParameterField(
          label: loc.payrollSubmitPayrollFlowPayrollRelationshipGroup,
          value: loc.payrollFlowMonitorParametersRelationshipGroupValue,
        ),
        FlowMonitorParameterField(
          label: loc.payrollFlowMonitorCheckOrganizationPaymentMethod,
          value: empty,
          isEmpty: true,
        ),
        FlowMonitorParameterField(
          label: loc.payrollFlowMonitorEftOrganizationPaymentMethod,
          value: empty,
          isEmpty: true,
        ),
        FlowMonitorParameterField(label: loc.payrollPersonResultsTaskDetailPeriodEndDate, value: empty, isEmpty: true),
        FlowMonitorParameterField(label: loc.payrollFlowMonitorRetroProcessDate, value: empty, isEmpty: true),
        FlowMonitorParameterField(
          label: loc.payrollSubmitPayrollFlowRunMode,
          value: loc.payrollSubmitPayrollFlowRunModeNormal,
        ),
        FlowMonitorParameterField(label: loc.payrollFlowMonitorDisplayAllHours, value: empty, isEmpty: true),
      ],
    );
  }
}
