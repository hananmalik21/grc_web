import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/edit_timesheet_dialog.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/timesheet_detail_mobile_sheet.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_actions_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin TimesheetListMobileLogicMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void approveTimesheet(BuildContext context, Timesheet timesheet) =>
      TimesheetActions.approveTimesheet(context, ref, timesheet);

  void rejectTimesheet(BuildContext context, Timesheet timesheet) =>
      TimesheetActions.rejectTimesheet(context, ref, timesheet);

  void editTimesheet(BuildContext context, Timesheet timesheet) => EditTimesheetDialog.show(context, timesheet);

  void viewTimesheetDetail(BuildContext context, Timesheet timesheet) =>
      TimesheetDetailMobileSheet.show(context, timesheet);

  void goToPage(int page) => ref.read(timesheetNotifierProvider.notifier).setPage(page);
}
