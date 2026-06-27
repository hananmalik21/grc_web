import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_candidate_controller.dart';
import '../states/create_candidate_state.dart';

final createCandidateProvider = AutoDisposeNotifierProvider<CreateCandidateNotifier, CreateCandidateState>(
  CreateCandidateNotifier.new,
);
