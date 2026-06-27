export 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_screen_enterprise_provider.dart'
    show
        attendanceScreenSelectedEnterpriseProvider,
        attendanceScreenEnterpriseIdProvider,
        attendanceEnterpriseSyncProvider;

import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_screen_enterprise_provider.dart'
    as screen;

final attendanceSelectedEnterpriseProvider = screen.attendanceScreenSelectedEnterpriseProvider;

final attendanceEnterpriseIdProvider = screen.attendanceScreenEnterpriseIdProvider;
