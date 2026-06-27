import 'package:grc/features/hiring/application/candidates/controllers/request_assessment_controller.dart';
import 'package:grc/features/hiring/application/candidates/states/request_assessment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestAssessmentProvider =
    AutoDisposeNotifierProviderFamily<RequestAssessmentNotifier, RequestAssessmentState, String>(
      RequestAssessmentNotifier.new,
    );
