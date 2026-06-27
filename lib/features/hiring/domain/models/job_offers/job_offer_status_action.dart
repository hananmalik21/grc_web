enum JobOfferStatusAction { approve, extend, withdraw }

class PerformJobOfferStatusActionInput {
  const PerformJobOfferStatusActionInput({required this.offerGuid, required this.action, required this.updatedBy});

  final String offerGuid;
  final JobOfferStatusAction action;
  final String updatedBy;

  Map<String, dynamic> toJson() {
    return {'updated_by': _normalizedUpdatedBy};
  }

  String get _normalizedUpdatedBy => updatedBy.trim().isEmpty ? 'ADMIN' : updatedBy.trim();
}
