import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_api_providers.dart';
import 'package:grc/features/hiring/data/dto/requisitions_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetRequisitionsParams {
  const GetRequisitionsParams({required this.enterpriseId, this.page = 1, this.pageSize = 10});

  final int enterpriseId;
  final int page;
  final int pageSize;

  @override
  bool operator ==(Object other) {
    return other is GetRequisitionsParams &&
        other.enterpriseId == enterpriseId &&
        other.page == page &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode => Object.hash(enterpriseId, page, pageSize);
}

final getRequisitionsProvider = FutureProvider.autoDispose.family<RequisitionsPageDto, GetRequisitionsParams>((
  ref,
  params,
) async {
  final useCase = ref.watch(getRequisitionsUseCaseProvider);
  return useCase(enterpriseId: params.enterpriseId, page: params.page, pageSize: params.pageSize);
});

final getRequisitionsTableRowsProvider = FutureProvider.autoDispose
    .family<List<RequisitionTableRowData>, GetRequisitionsParams>((ref, params) async {
      final page = await ref.watch(getRequisitionsProvider(params).future);
      return page.toTableRows();
    });
