enum FrameworkStatus {
  active,
  inProgress,
}

class FrameworkAssessment {
  const FrameworkAssessment({
    required this.name,
    required this.category,
    required this.description,
    required this.compliance,
    required this.status,
    required this.controls,
    required this.lastAssessment,
  });

  final String name;
  final String category;
  final String description;
  /// Compliance level as a percentage (0–100).
  final int compliance;
  final FrameworkStatus status;
  final int controls;
  final String lastAssessment;
}

class AssessmentHubInfo {
  const AssessmentHubInfo({
    required this.libraries,
    required this.questions,
    required this.criteria,
  });

  final int libraries;
  final int questions;
  final int criteria;
}

class AssessmentsSummary {
  const AssessmentsSummary({
    required this.totalFrameworks,
    required this.avgCompliance,
    required this.totalControls,
    required this.activeFrameworks,
  });

  final int totalFrameworks;
  final int avgCompliance;
  final int totalControls;
  final int activeFrameworks;
}

class AssessmentsData {
  const AssessmentsData({
    required this.hub,
    required this.summary,
    required this.frameworks,
  });

  final AssessmentHubInfo hub;
  final AssessmentsSummary summary;
  final List<FrameworkAssessment> frameworks;
}

// ─── Framework detail ───────────────────────────────────────────────────────

enum RemediationPriority { high, medium }

enum RemediationStatus { open, inProgress }

enum QuestionAnswer { yes, partial, no, na }

class AssessmentQuestion {
  const AssessmentQuestion({
    required this.text,
    required this.answer,
    required this.evidence,
  });

  final String text;
  final QuestionAnswer answer;
  final String evidence;
}

class AssessmentSection {
  const AssessmentSection({
    required this.title,
    required this.description,
    required this.compliant,
    required this.partial,
    required this.nonCompliant,
    required this.compliance,
    this.questions = const [],
  });

  final String title;
  final String description;
  final int compliant;
  final int partial;
  final int nonCompliant;
  /// Compliance percentage (0–100).
  final int compliance;
  final List<AssessmentQuestion> questions;
}

class RemediationItem {
  const RemediationItem({
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.due,
    required this.owner,
  });

  final String title;
  final String description;
  final RemediationPriority priority;
  final RemediationStatus status;
  final String due;
  final String owner;
}

class FrameworkDetail {
  const FrameworkDetail({
    required this.title,
    required this.subtitle,
    required this.complianceScore,
    required this.compliantControls,
    required this.totalControls,
    required this.partialCompliance,
    required this.nonCompliant,
    required this.sections,
    required this.remediationItems,
    required this.completedItems,
  });

  final String title;
  final String subtitle;
  /// Overall compliance score percentage (0–100).
  final int complianceScore;
  final int compliantControls;
  final int totalControls;
  final int partialCompliance;
  final int nonCompliant;
  final List<AssessmentSection> sections;
  final List<RemediationItem> remediationItems;
  final int completedItems;
}
