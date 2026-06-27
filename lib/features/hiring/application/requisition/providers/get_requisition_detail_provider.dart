import 'package:grc/features/hiring/data/dto/requisition_full_dto.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetRequisitionDetailParams {
  const GetRequisitionDetailParams({required this.enterpriseId, required this.requisitionGuid});

  final int enterpriseId;
  final String requisitionGuid;

  @override
  bool operator ==(Object other) {
    return other is GetRequisitionDetailParams &&
        other.enterpriseId == enterpriseId &&
        other.requisitionGuid == requisitionGuid;
  }

  @override
  int get hashCode => Object.hash(enterpriseId, requisitionGuid);
}

final getRequisitionDetailProvider = FutureProvider.autoDispose.family<RequisitionFullDto, GetRequisitionDetailParams>((
  ref,
  params,
) async {
  final useCase = ref.watch(getRequisitionByGuidUseCaseProvider);
  return useCase(requisitionGuid: params.requisitionGuid, enterpriseId: params.enterpriseId);
});

final getRequisitionDetailRowProvider = FutureProvider.autoDispose
    .family<RequisitionTableRowData, GetRequisitionDetailParams>((ref, params) async {
      final full = await ref.watch(getRequisitionDetailProvider(params).future);
      return full.toTableRowData();
    });
