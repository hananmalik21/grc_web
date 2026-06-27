import 'package:grc/features/hiring/domain/models/talent_pools/talent_pool.dart';
import 'package:grc/features/hiring/domain/models/talent_pools/talent_pools_pagination.dart';

class TalentPoolsPage {
  const TalentPoolsPage({required this.items, this.pagination});

  final List<TalentPool> items;
  final TalentPoolsPagination? pagination;
}
