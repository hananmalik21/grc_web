import 'package:grc/features/hiring/application/applications/controllers/application_detail_controller.dart';
import 'package:grc/features/hiring/application/applications/states/application_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationDetailControllerProvider =
    AutoDisposeNotifierProviderFamily<ApplicationDetailNotifier, ApplicationDetailState, ApplicationDetailParams>(
      ApplicationDetailNotifier.new,
    );
