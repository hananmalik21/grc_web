import 'package:grc/features/hiring/application/requisition/controllers/requisition_job_postings_controller.dart';
import 'package:grc/features/hiring/application/requisition/states/requisition_job_postings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requisitionJobPostingsProvider =
    AutoDisposeNotifierProviderFamily<RequisitionJobPostingsNotifier, RequisitionJobPostingsState, String>(
      RequisitionJobPostingsNotifier.new,
    );
