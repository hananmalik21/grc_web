import 'package:camera/camera.dart';

class MarkAttendanceCameraState {
  final CameraController? controller;
  final bool isInitializing;
  final bool isReady;
  final String? error;

  MarkAttendanceCameraState({this.controller, this.isInitializing = false, this.isReady = false, this.error});

  MarkAttendanceCameraState copyWith({
    CameraController? controller,
    bool? isInitializing,
    bool? isReady,
    String? error,
  }) {
    return MarkAttendanceCameraState(
      controller: controller ?? this.controller,
      isInitializing: isInitializing ?? this.isInitializing,
      isReady: isReady ?? this.isReady,
      error: error,
    );
  }
}
