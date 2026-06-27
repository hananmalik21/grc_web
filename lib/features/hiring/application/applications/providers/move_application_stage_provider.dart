import 'package:grc/features/hiring/application/applications/controllers/move_application_stage_controller.dart';
import 'package:grc/features/hiring/application/applications/states/move_application_stage_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moveApplicationStageControllerProvider =
    AutoDisposeNotifierProviderFamily<
      MoveApplicationStageNotifier,
      MoveApplicationStageState,
      MoveApplicationStageParams
    >(MoveApplicationStageNotifier.new);
