import 'package:grc/features/hiring/application/candidates/controllers/update_candidate_assessment_controller.dart';
import 'package:grc/features/hiring/application/candidates/states/update_candidate_assessment_state.dart';
import 'package:grc/features/hiring/application/candidates/update_candidate_assessment_args.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateCandidateAssessmentProvider =
    AutoDisposeNotifierProviderFamily<
      UpdateCandidateAssessmentNotifier,
      UpdateCandidateAssessmentState,
      UpdateCandidateAssessmentArgs
    >(UpdateCandidateAssessmentNotifier.new);
