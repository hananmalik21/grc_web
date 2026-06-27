import 'package:grc/features/hiring/application/interviews/providers/update_interview_enterprise_provider.dart';
import 'package:grc/features/hiring/application/interviews/providers/update_interview_lookups_provider.dart';
import 'package:grc/features/hiring/application/interviews/providers/update_interview_provider.dart';
import 'package:grc/features/hiring/application/interviews/states/update_interview_state.dart';
import 'package:grc/features/hiring/application/interviews/update_interview_form_actions.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditInterviewFormBinding {
  const EditInterviewFormBinding(this.interviewGuid);

  final String interviewGuid;

  ProviderListenable<UpdateInterviewState> get formStateProvider => updateInterviewProvider(interviewGuid);

  ProviderListenable<int?> get enterpriseIdProvider => updateInterviewEnterpriseIdProvider;

  ProviderListenable<AsyncValue<List<RecLookupValue>>> get typeLookupsProvider =>
      updateInterviewTypeLookupValuesProvider;

  UpdateInterviewFormActions readActions(WidgetRef ref) => ref.read(updateInterviewProvider(interviewGuid).notifier);
}
