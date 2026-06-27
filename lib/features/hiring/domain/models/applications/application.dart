class ApplicationsPagination {
  const ApplicationsPagination({
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

class ApplicationsPage {
  const ApplicationsPage({required this.items, required this.pagination});

  final List<Application> items;
  final ApplicationsPagination? pagination;

  static const empty = ApplicationsPage(items: [], pagination: null);
}

class Application {
  const Application({
    required this.applicationId,
    required this.applicationGuid,
    required this.applicationNumber,
    required this.enterpriseId,
    required this.postingId,
    required this.postingTitle,
    required this.requisitionId,
    required this.requisitionNumber,
    required this.requisitionTitle,
    required this.candidateId,
    required this.candidateName,
    required this.email,
    required this.phone,
    required this.sourceCode,
    required this.currentStageCode,
    required this.statusCode,
    required this.appliedDate,
    required this.hasResume,
    required this.resumeUrl,
  });

  final int applicationId;
  final String applicationGuid;
  final String applicationNumber;
  final int enterpriseId;
  final int postingId;
  final String postingTitle;
  final int requisitionId;
  final String requisitionNumber;
  final String requisitionTitle;
  final int candidateId;
  final String candidateName;
  final String email;
  final String phone;
  final String sourceCode;
  final String currentStageCode;
  final String statusCode;
  final DateTime? appliedDate;
  final bool hasResume;
  final String? resumeUrl;
}
