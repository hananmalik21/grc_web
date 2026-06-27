import 'package:grc/features/hiring/application/applications/controllers/applications_controller.dart';
import 'package:grc/features/hiring/application/applications/states/applications_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationsControllerProvider = AutoDisposeNotifierProvider<ApplicationsNotifier, ApplicationsState>(
  ApplicationsNotifier.new,
);
