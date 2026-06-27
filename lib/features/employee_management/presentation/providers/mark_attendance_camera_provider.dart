import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mark_attendance_camera_state.dart';

export 'mark_attendance_camera_state.dart';

class MarkAttendanceCameraNotifier extends AutoDisposeNotifier<MarkAttendanceCameraState> {
  @override
  MarkAttendanceCameraState build() {
    ref.onDispose(() {
      state.controller?.dispose();
    });
    return MarkAttendanceCameraState();
  }

  Future<void> initialize() async {
    if (state.isInitializing || state.isReady) return;

    state = state.copyWith(isInitializing: true, error: null);

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        state = state.copyWith(isInitializing: false, error: 'No cameras found');
        return;
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: kIsWeb ? null : ImageFormatGroup.nv21,
      );

      await controller.initialize();

      state = state.copyWith(controller: controller, isInitializing: false, isReady: true);
    } catch (e) {
      state = state.copyWith(isInitializing: false, error: 'Failed to open camera: $e');
    }
  }

  Future<void> disposeCamera() async {
    final oldController = state.controller;
    state = MarkAttendanceCameraState();
    if (!kIsWeb && oldController != null && oldController.value.isStreamingImages) {
      await oldController.stopImageStream();
    }
    await oldController?.dispose();
  }

  Future<void> restartCamera() async {
    await disposeCamera();
    await initialize();
  }
}

final markAttendanceCameraProvider =
    NotifierProvider.autoDispose<MarkAttendanceCameraNotifier, MarkAttendanceCameraState>(
      MarkAttendanceCameraNotifier.new,
    );
