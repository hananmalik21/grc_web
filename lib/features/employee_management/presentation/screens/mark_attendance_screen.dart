import 'package:camera/camera.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/employee_management/presentation/providers/mark_attendance_camera_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MarkAttendanceScreen extends ConsumerWidget {
  const MarkAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cameraState = ref.watch(markAttendanceCameraProvider);
    final cameraNotifier = ref.read(markAttendanceCameraProvider.notifier);

    if (cameraState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastService.error(context, cameraState.error!);
      });
    }

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DigifyTabHeader(
              title: 'Mark Attendance',
              description: 'Position your face clearly in the camera to punch your attendance.',
            ),
            Gap(24.h),
            if (!cameraState.isReady && !cameraState.isInitializing)
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 400.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                      child: Icon(Icons.camera_alt_outlined, size: 64.sp, color: Colors.grey),
                    ),
                    Gap(24.h),
                    AppButton.primary(label: 'Open Camera', onPressed: () => cameraNotifier.initialize()),
                  ],
                ),
              )
            else if (cameraState.isInitializing)
              const Center(child: CircularProgressIndicator()),
            if (cameraState.isReady && cameraState.controller != null)
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: AspectRatio(
                          aspectRatio: cameraState.controller!.value.aspectRatio,
                          child: CameraPreview(cameraState.controller!),
                        ),
                      ),
                      Positioned(
                        bottom: 20.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'Position your face in the frame',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(24.h),
                  AppButton.primary(
                    label: 'Punch Attendance',
                    onPressed: () {
                      ToastService.success(context, 'Attendance marked successfully!');
                    },
                  ),
                  Gap(12.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Reset Camera',
                          type: AppButtonType.outline,
                          onPressed: () => cameraNotifier.restartCamera(),
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: AppButton(
                          label: 'Close Camera',
                          type: AppButtonType.outline,
                          onPressed: () => cameraNotifier.disposeCamera(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
