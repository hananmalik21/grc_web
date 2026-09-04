import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/presentation/providers/cyber_risk_provider.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';

class PeopleRiskScreen extends ConsumerStatefulWidget {
  const PeopleRiskScreen({super.key});

  @override
  ConsumerState<PeopleRiskScreen> createState() => _PeopleRiskScreenState();
}

class _PeopleRiskScreenState extends ConsumerState<PeopleRiskScreen> {
  bool _evaluating = false;

  Future<void> _evaluate() async {
    setState(() => _evaluating = true);
    try {
      final result = await ref.read(peopleRiskRepositoryProvider).evaluate();
      ref.invalidate(peopleRiskRegisterProvider);
      ref.invalidate(peopleHeatmapProvider);
      if (!mounted) return;
      ToastService.show(
        context: context,
        message:
            'Evaluated ${result.evaluated} people and found ${result.threatsCreated} threats.',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;
      ToastService.show(
        context: context,
        message: 'People risk evaluation failed: $error',
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => _evaluating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final register = ref.watch(peopleRiskRegisterProvider);
    return CyberScreenLayout(
      title: 'People Risk',
      subtitle: 'Behavioral risk signals derived from security activity',
      actions: [
        AppButton(
          label: _evaluating ? 'Evaluating...' : 'Evaluate now',
          type: AppButtonType.primary,
          size: AppButtonSize.sm,
          onPressed: _evaluating ? null : _evaluate,
        ),
        const Gap(8),
        IconButton(
          tooltip: 'Refresh risk register',
          onPressed: () => ref.invalidate(peopleRiskRegisterProvider),
          icon: const Icon(Icons.refresh, color: AppColors.dashCyberSecurity),
        ),
      ],
      child: register.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            _StateMessage(message: 'Unable to load risk register: $error'),
        data: (page) => page.data.isEmpty
            ? const _StateMessage(
                message: 'No evaluated people risk profiles yet.',
              )
            : Column(
                children: page.data
                    .map(
                      (person) => Card(
                        color: AppColors.cardBackgroundDark,
                        child: ListTile(
                          title: Text(
                            person.fullName.isEmpty
                                ? person.email
                                : person.fullName,
                          ),
                          subtitle: Text(
                            '${person.department}  •  ${person.jobTitle}\n${person.aiRiskRationale}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${person.riskScore}',
                                style: TextStyle(
                                  color: _riskColor(person.riskTier),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                person.riskTier,
                                style: TextStyle(
                                  color: _riskColor(person.riskTier),
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }

  Color _riskColor(String tier) => switch (tier.toUpperCase()) {
    'CRITICAL' => AppColors.alertCritical,
    'HIGH' => AppColors.alertHigh,
    'MEDIUM' => AppColors.warning,
    _ => AppColors.success,
  };
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Center(child: Text(message)),
  );
}
