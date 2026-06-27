import 'package:flutter_riverpod/flutter_riverpod.dart';

final approveRequisitionActionLoadingProvider = StateProvider.autoDispose.family<bool, String>(
  (ref, requisitionGuid) => false,
);

final rejectRequisitionActionLoadingProvider = StateProvider.autoDispose.family<bool, String>(
  (ref, requisitionGuid) => false,
);

final deleteRequisitionActionLoadingProvider = StateProvider.autoDispose.family<bool, String>(
  (ref, requisitionGuid) => false,
);

final activateRequisitionActionLoadingProvider = StateProvider.autoDispose.family<bool, String>(
  (ref, requisitionGuid) => false,
);

final activateRequisitionResultProvider = StateProvider.autoDispose.family<AsyncValue<void>?, String>((ref, _) => null);

final closeRequisitionActionLoadingProvider = StateProvider.autoDispose.family<bool, String>(
  (ref, requisitionGuid) => false,
);

final closeRequisitionResultProvider = StateProvider.autoDispose.family<AsyncValue<void>?, String>((ref, _) => null);

final holdRequisitionActionLoadingProvider = StateProvider.autoDispose.family<bool, String>(
  (ref, requisitionGuid) => false,
);

final holdRequisitionResultProvider = StateProvider.autoDispose.family<AsyncValue<void>?, String>((ref, _) => null);
