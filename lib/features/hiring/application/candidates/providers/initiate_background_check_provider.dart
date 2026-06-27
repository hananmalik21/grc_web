import 'package:grc/features/hiring/application/candidates/controllers/initiate_background_check_controller.dart';
import 'package:grc/features/hiring/application/candidates/states/initiate_background_check_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initiateBackgroundCheckProvider =
    AutoDisposeNotifierProviderFamily<InitiateBackgroundCheckNotifier, InitiateBackgroundCheckState, String>(
      InitiateBackgroundCheckNotifier.new,
    );
