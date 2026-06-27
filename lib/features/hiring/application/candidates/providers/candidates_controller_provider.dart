import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/candidates_controller.dart';
export '../controllers/candidates_controller.dart';

final candidatesControllerProvider = Provider.autoDispose<CandidatesController>((ref) {
  return CandidatesController(ref);
});
