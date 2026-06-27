import 'package:grc/features/hiring/application/requisition/controllers/create_job_posting_controller.dart';
import 'package:grc/features/hiring/application/requisition/states/create_job_posting_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createJobPostingProvider =
    AutoDisposeNotifierProviderFamily<CreateJobPostingNotifier, CreateJobPostingState, String>(
      CreateJobPostingNotifier.new,
    );
