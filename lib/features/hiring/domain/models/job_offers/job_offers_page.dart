import 'package:grc/features/hiring/domain/models/job_offers/job_offer.dart';

class JobOffersPagination {
  const JobOffersPagination({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}

class JobOffersPage {
  const JobOffersPage({required this.items, required this.pagination});

  final List<JobOffer> items;
  final JobOffersPagination? pagination;
}
