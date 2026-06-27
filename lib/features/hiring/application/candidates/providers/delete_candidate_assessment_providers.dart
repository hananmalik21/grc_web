import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteCandidateAssessmentLoadingProvider = StateProvider.autoDispose.family<bool, String>(
  (ref, assessmentGuid) => false,
);
