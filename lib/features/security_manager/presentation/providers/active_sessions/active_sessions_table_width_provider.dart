import 'package:grc/features/security_manager/data/config/active_sessions_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ActiveSessionsColumn { userDetails, locationAndIp, deviceAndBrowser, sessionInfo, status, actions }

class ActiveSessionsTableColumnWidths {
  final double? userOverride;
  final double? locationAndIpOverride;
  final double? deviceAndBrowserOverride;
  final double? sessionInfoOverride;
  final double? statusOverride;
  final double? actionsOverride;

  const ActiveSessionsTableColumnWidths({
    this.userOverride,
    this.locationAndIpOverride,
    this.deviceAndBrowserOverride,
    this.sessionInfoOverride,
    this.statusOverride,
    this.actionsOverride,
  });

  double get user => userOverride ?? ActiveSessionsTableConfig.userWidth.w;
  double get locationAndIp => locationAndIpOverride ?? ActiveSessionsTableConfig.locationAndIpWidth.w;
  double get deviceAndBrowser => deviceAndBrowserOverride ?? ActiveSessionsTableConfig.deviceAndBrowserWidth.w;
  double get sessionInfo => sessionInfoOverride ?? ActiveSessionsTableConfig.sessionInfoWidth.w;
  double get status => statusOverride ?? ActiveSessionsTableConfig.statusWidth.w;
  double get actions => actionsOverride ?? ActiveSessionsTableConfig.actionsWidth.w;

  ActiveSessionsTableColumnWidths copyWith({
    double? userOverride,
    double? locationAndIpOverride,
    double? deviceAndBrowserOverride,
    double? sessionInfoOverride,
    double? statusOverride,
    double? actionsOverride,
  }) {
    return ActiveSessionsTableColumnWidths(
      userOverride: userOverride ?? this.userOverride,
      locationAndIpOverride: locationAndIpOverride ?? this.locationAndIpOverride,
      deviceAndBrowserOverride: deviceAndBrowserOverride ?? this.deviceAndBrowserOverride,
      sessionInfoOverride: sessionInfoOverride ?? this.sessionInfoOverride,
      statusOverride: statusOverride ?? this.statusOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final activeSessionsTableWidthsProvider =
    StateNotifierProvider<ActiveSessionsTableWidthsNotifier, ActiveSessionsTableColumnWidths>((ref) {
      return ActiveSessionsTableWidthsNotifier();
    });

class ActiveSessionsTableWidthsNotifier extends StateNotifier<ActiveSessionsTableColumnWidths> {
  ActiveSessionsTableWidthsNotifier() : super(const ActiveSessionsTableColumnWidths());

  void updateWidth(ActiveSessionsColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(80.0, 800.0);

    switch (column) {
      case ActiveSessionsColumn.userDetails:
        state = state.copyWith(userOverride: clampWidth(state.user));
        break;
      case ActiveSessionsColumn.locationAndIp:
        state = state.copyWith(locationAndIpOverride: clampWidth(state.locationAndIp));
        break;
      case ActiveSessionsColumn.deviceAndBrowser:
        state = state.copyWith(deviceAndBrowserOverride: clampWidth(state.deviceAndBrowser));
        break;
      case ActiveSessionsColumn.sessionInfo:
        state = state.copyWith(sessionInfoOverride: clampWidth(state.sessionInfo));
        break;
      case ActiveSessionsColumn.status:
        state = state.copyWith(statusOverride: clampWidth(state.status));
        break;
      case ActiveSessionsColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
