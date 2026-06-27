import 'package:grc/features/hiring/application/candidates/providers/schedule_interview_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/schedule_interview_lookups_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/schedule_interview_provider.dart';
import 'package:grc/features/hiring/application/candidates/schedule_interview_form_actions.dart';
import 'package:grc/features/hiring/application/candidates/states/schedule_interview_state.dart';
import 'package:grc/features/hiring/application/interviews/providers/create_new_interview_enterprise_provider.dart';
import 'package:grc/features/hiring/application/interviews/providers/create_new_interview_lookups_provider.dart';
import 'package:grc/features/hiring/application/interviews/providers/create_new_interview_provider.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ScheduleInterviewFormScope { candidate, interviewsTab }

class ScheduleInterviewFormBinding {
  const ScheduleInterviewFormBinding._({required this.scope, required this.providerKey});

  const ScheduleInterviewFormBinding.candidate(String candidateGuid)
    : this._(scope: ScheduleInterviewFormScope.candidate, providerKey: candidateGuid);

  const ScheduleInterviewFormBinding.interviewsTab()
    : this._(scope: ScheduleInterviewFormScope.interviewsTab, providerKey: '');

  final ScheduleInterviewFormScope scope;
  final String providerKey;

  bool get showsCandidatePicker => scope == ScheduleInterviewFormScope.interviewsTab;

  ProviderListenable<ScheduleInterviewState> get formStateProvider => switch (scope) {
    ScheduleInterviewFormScope.candidate => scheduleInterviewProvider(providerKey),
    ScheduleInterviewFormScope.interviewsTab => createNewInterviewProvider,
  };

  ProviderListenable<int?> get enterpriseIdProvider => switch (scope) {
    ScheduleInterviewFormScope.candidate => scheduleInterviewEnterpriseIdProvider,
    ScheduleInterviewFormScope.interviewsTab => createNewInterviewEnterpriseIdProvider,
  };

  ProviderListenable<AsyncValue<List<RecLookupValue>>> get typeLookupsProvider => switch (scope) {
    ScheduleInterviewFormScope.candidate => scheduleInterviewTypeLookupValuesProvider,
    ScheduleInterviewFormScope.interviewsTab => createNewInterviewTypeLookupValuesProvider,
  };

  ScheduleInterviewFormActions readActions(WidgetRef ref) => switch (scope) {
    ScheduleInterviewFormScope.candidate => ref.read(scheduleInterviewProvider(providerKey).notifier),
    ScheduleInterviewFormScope.interviewsTab => ref.read(createNewInterviewProvider.notifier),
  };
}
