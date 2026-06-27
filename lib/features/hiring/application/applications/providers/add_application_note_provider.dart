import 'package:grc/features/hiring/application/applications/controllers/add_application_note_controller.dart';
import 'package:grc/features/hiring/application/applications/states/add_application_note_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addApplicationNoteControllerProvider =
    AutoDisposeNotifierProviderFamily<AddApplicationNoteNotifier, AddApplicationNoteState, AddApplicationNoteParams>(
      AddApplicationNoteNotifier.new,
    );
