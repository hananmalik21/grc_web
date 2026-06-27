import 'package:grc/features/hiring/application/requisition/controllers/update_job_posting_controller.dart';
import 'package:grc/features/hiring/application/requisition/states/update_job_posting_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateJobPostingProvider =
    AutoDisposeNotifierProviderFamily<UpdateJobPostingNotifier, UpdateJobPostingState, String>(
      UpdateJobPostingNotifier.new,
    );
