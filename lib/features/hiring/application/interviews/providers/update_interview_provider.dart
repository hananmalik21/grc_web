import 'package:grc/features/hiring/application/interviews/controllers/update_interview_controller.dart';
import 'package:grc/features/hiring/application/interviews/states/update_interview_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateInterviewProvider =
    AutoDisposeNotifierProviderFamily<UpdateInterviewNotifier, UpdateInterviewState, String>(
      UpdateInterviewNotifier.new,
    );
