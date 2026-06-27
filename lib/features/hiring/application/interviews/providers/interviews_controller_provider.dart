import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/interviews_controller.dart';
export '../controllers/interviews_controller.dart';

final interviewsControllerProvider = Provider.autoDispose<InterviewsController>((ref) {
  return InterviewsController(ref);
});
