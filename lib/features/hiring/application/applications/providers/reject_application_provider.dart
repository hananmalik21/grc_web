import 'package:grc/features/hiring/application/applications/controllers/reject_application_controller.dart';
import 'package:grc/features/hiring/application/applications/states/reject_application_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rejectApplicationControllerProvider =
    AutoDisposeNotifierProviderFamily<RejectApplicationNotifier, RejectApplicationState, RejectApplicationParams>(
      RejectApplicationNotifier.new,
    );
