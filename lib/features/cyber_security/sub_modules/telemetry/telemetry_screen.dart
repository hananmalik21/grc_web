import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/cyber_security/presentation/providers/telemetry_provider.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';

class TelemetryScreen extends ConsumerWidget {
  const TelemetryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(telemetryLogsProvider);
    return CyberScreenLayout(
      title: 'Security Telemetry',
      subtitle: 'Normalized security events from connected providers',
      actions: [
        IconButton(
          tooltip: 'Refresh telemetry',
          onPressed: () => ref.invalidate(telemetryLogsProvider),
          icon: const Icon(Icons.refresh, color: AppColors.dashCyberSecurity),
        ),
      ],
      child: logs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            _StateMessage(message: 'Unable to load telemetry: $error'),
        data: (page) => page.data.isEmpty
            ? const _StateMessage(message: 'No security events received yet.')
            : Column(
                children: page.data
                    .map(
                      (log) => Card(
                        color: AppColors.cardBackgroundDark,
                        child: ListTile(
                          leading: Icon(
                            log.status.toUpperCase() == 'SUCCESS'
                                ? Icons.check_circle_outline
                                : Icons.warning_amber_outlined,
                            color: log.status.toUpperCase() == 'SUCCESS'
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                          title: Text(log.eventName),
                          subtitle: Text(
                            '${log.provider}  •  ${log.category}  •  ${log.actorIdentity}\n${log.sourceIp}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            log.occurredAt == null
                                ? '--'
                                : '${log.occurredAt!.toLocal()}'
                                      .split('.')
                                      .first,
                            style: TextStyle(
                              color: AppColors.textTertiaryDark,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(child: Text(message)),
    );
  }
}
