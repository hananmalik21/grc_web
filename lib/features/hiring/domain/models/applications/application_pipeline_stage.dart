class ApplicationPipelineStage {
  ApplicationPipelineStage._();

  static const applied = 'APPLIED';
  static const screening = 'SCREENING';
  static const shortlisted = 'SHORTLISTED';
  static const interview = 'INTERVIEW';
  static const offer = 'OFFER';
  static const selected = 'SELECTED';
  static const hired = 'HIRED';
  static const rejected = 'REJECTED';

  static const List<String> ordered = [applied, screening, shortlisted, interview, offer, selected, hired];

  static bool isRejected(String stageCode) {
    return stageCode.trim().toUpperCase() == rejected;
  }

  static int indexOf(String stageCode) {
    return ordered.indexOf(stageCode.trim().toUpperCase());
  }
}
