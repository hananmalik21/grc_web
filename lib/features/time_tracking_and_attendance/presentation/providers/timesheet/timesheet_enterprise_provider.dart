import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_screen_enterprise_provider.dart'
    as screen;

export 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_screen_enterprise_provider.dart'
    show
        timesheetScreenSelectedEnterpriseProvider,
        timesheetScreenEnterpriseIdProvider,
        timesheetEnterpriseSyncProvider;

final timesheetSelectedEnterpriseProvider = screen.timesheetScreenSelectedEnterpriseProvider;

final timesheetEnterpriseIdProvider = screen.timesheetScreenEnterpriseIdProvider;
