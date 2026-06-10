import 'package:dio/dio.dart';
import 'package:grc_web/features/assessments/data/data_sources/assessments_remote_data_source.dart';
import 'package:grc_web/features/assessments/domain/entities/assessment_entities.dart';

class AssessmentsRemoteDataSourceImpl implements AssessmentsRemoteDataSource {
  AssessmentsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AssessmentsData> getAssessments() async {
    // Simulate network latency.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    // ignore: unused_local_variable
    final headers = _dio.options.headers;

    return const AssessmentsData(
      hub: AssessmentHubInfo(libraries: 3, questions: 42, criteria: 5),
      summary: AssessmentsSummary(
        totalFrameworks: 6,
        avgCompliance: 80,
        totalControls: 706,
        activeFrameworks: 3,
      ),
      frameworks: [
        FrameworkAssessment(
          name: 'SOX (Sarbanes-Oxley)',
          category: 'Financial Compliance',
          description: 'Financial reporting controls and compliance requirements',
          compliance: 78,
          status: FrameworkStatus.inProgress,
          controls: 156,
          lastAssessment: '2026-04-15',
        ),
        FrameworkAssessment(
          name: 'COSO ERM',
          category: 'Enterprise Risk Management',
          description: 'Enterprise-wide risk management framework',
          compliance: 85,
          status: FrameworkStatus.active,
          controls: 89,
          lastAssessment: '2026-04-20',
        ),
        FrameworkAssessment(
          name: 'ORM',
          category: 'Operational Risk',
          description: 'Operational risk identification and management',
          compliance: 72,
          status: FrameworkStatus.inProgress,
          controls: 124,
          lastAssessment: '2026-03-28',
        ),
        FrameworkAssessment(
          name: 'NIST CSF / ISO 27001',
          category: 'Cybersecurity',
          description: 'Cybersecurity controls and information security management',
          compliance: 88,
          status: FrameworkStatus.active,
          controls: 178,
          lastAssessment: '2026-04-25',
        ),
        FrameworkAssessment(
          name: 'Cloud & Vendor Risk',
          category: 'Third-Party Risk',
          description: 'Cloud security and vendor risk management framework',
          compliance: 81,
          status: FrameworkStatus.active,
          controls: 92,
          lastAssessment: '2026-04-18',
        ),
        FrameworkAssessment(
          name: 'ISO 22301 (BCM)',
          category: 'Business Continuity',
          description: 'Business continuity and resilience management',
          compliance: 76,
          status: FrameworkStatus.inProgress,
          controls: 67,
          lastAssessment: '2026-04-10',
        ),
      ],
    );
  }

  @override
  Future<FrameworkDetail> getFrameworkDetail(String frameworkName) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    // Header per framework; the assessment breakdown below mirrors the SOX
    // reference design and is reused as representative content.
    final (title, subtitle) = switch (frameworkName) {
      'SOX (Sarbanes-Oxley)' => (
          'SOX Compliance Assessment',
          'Sarbanes-Oxley Act - Financial Reporting Controls',
        ),
      'COSO ERM' => (
          'COSO ERM Assessment',
          'Enterprise-wide risk management framework',
        ),
      'ORM' => (
          'ORM Assessment',
          'Operational risk identification and management',
        ),
      'NIST CSF / ISO 27001' => (
          'NIST CSF / ISO 27001 Assessment',
          'Cybersecurity controls and information security management',
        ),
      'Cloud & Vendor Risk' => (
          'Cloud & Vendor Risk Assessment',
          'Cloud security and vendor risk management framework',
        ),
      'ISO 22301 (BCM)' => (
          'ISO 22301 (BCM) Assessment',
          'Business continuity and resilience management',
        ),
      _ => ('$frameworkName Assessment', ''),
    };

    return FrameworkDetail(
      title: title,
      subtitle: subtitle,
      complianceScore: 81,
      compliantControls: 13,
      totalControls: 16,
      partialCompliance: 2,
      nonCompliant: 1,
      completedItems: 0,
      sections: const [
        AssessmentSection(
          title: 'Section 302 - Corporate Responsibility',
          description: 'CEO/CFO certification of financial reports',
          compliant: 3,
          partial: 1,
          nonCompliant: 0,
          compliance: 75,
          questions: [
            AssessmentQuestion(
              text: 'Does the CEO certify the accuracy of financial reports?',
              answer: QuestionAnswer.yes,
              evidence: 'Signed CEO certification on file',
            ),
            AssessmentQuestion(
              text: 'Does the CFO certify the accuracy of financial reports?',
              answer: QuestionAnswer.yes,
              evidence: 'Signed CFO certification on file',
            ),
            AssessmentQuestion(
              text: 'Are internal controls reviewed before certification?',
              answer: QuestionAnswer.yes,
              evidence: 'Quarterly control review records',
            ),
            AssessmentQuestion(
              text: 'Are disclosure controls evaluated each period?',
              answer: QuestionAnswer.partial,
              evidence: 'Evaluation performed but not fully documented',
            ),
          ],
        ),
        AssessmentSection(
          title: 'Section 404 - Management Assessment',
          description: 'Internal control over financial reporting',
          compliant: 3,
          partial: 1,
          nonCompliant: 0,
          compliance: 75,
          questions: [
            AssessmentQuestion(
              text: 'Is there documented internal control over financial reporting?',
              answer: QuestionAnswer.yes,
              evidence: 'ICFR documentation maintained',
            ),
            AssessmentQuestion(
              text: 'Are key controls tested annually?',
              answer: QuestionAnswer.yes,
              evidence: 'Annual control testing results',
            ),
            AssessmentQuestion(
              text: "Is management's assessment reported?",
              answer: QuestionAnswer.yes,
              evidence: 'Management assessment report',
            ),
            AssessmentQuestion(
              text: 'Are IT general controls fully documented?',
              answer: QuestionAnswer.partial,
              evidence: 'ITGC documentation in progress',
            ),
          ],
        ),
        AssessmentSection(
          title: 'Section 409 - Real-Time Disclosure',
          description: 'Timely disclosure of material changes',
          compliant: 2,
          partial: 0,
          nonCompliant: 1,
          compliance: 67,
          questions: [
            AssessmentQuestion(
              text: 'Is there a process for rapid disclosure of material events?',
              answer: QuestionAnswer.yes,
              evidence: 'Event notification procedures',
            ),
            AssessmentQuestion(
              text: 'Are disclosure timelines monitored and tracked?',
              answer: QuestionAnswer.yes,
              evidence: 'Disclosure timeline tracker',
            ),
            AssessmentQuestion(
              text: 'Is investor relations team equipped for real-time updates?',
              answer: QuestionAnswer.no,
              evidence: 'Gap identified in recent review',
            ),
          ],
        ),
        AssessmentSection(
          title: 'Section 802 - Record Retention',
          description: 'Document retention and destruction policies',
          compliant: 3,
          partial: 0,
          nonCompliant: 0,
          compliance: 100,
          questions: [
            AssessmentQuestion(
              text: 'Are document retention policies defined?',
              answer: QuestionAnswer.yes,
              evidence: 'Records retention policy document',
            ),
            AssessmentQuestion(
              text: 'Are destruction policies enforced?',
              answer: QuestionAnswer.yes,
              evidence: 'Destruction logs maintained',
            ),
            AssessmentQuestion(
              text: 'Are audit records retained per requirements?',
              answer: QuestionAnswer.yes,
              evidence: 'Audit record archive',
            ),
          ],
        ),
        AssessmentSection(
          title: 'Section 906 - Criminal Penalties',
          description: 'CEO/CFO certification under criminal penalty',
          compliant: 2,
          partial: 0,
          nonCompliant: 0,
          compliance: 100,
          questions: [
            AssessmentQuestion(
              text: 'Does the CEO certify under criminal penalty provisions?',
              answer: QuestionAnswer.yes,
              evidence: 'Section 906 certification signed',
            ),
            AssessmentQuestion(
              text: 'Does the CFO certify under criminal penalty provisions?',
              answer: QuestionAnswer.yes,
              evidence: 'Section 906 certification signed',
            ),
          ],
        ),
      ],
      remediationItems: const [
        RemediationItem(
          title: 'Section 409: Implement real-time disclosure process',
          description: 'Investor relations team needs tools and training for real-time updates',
          priority: RemediationPriority.high,
          status: RemediationStatus.open,
          due: '2026-05-31',
          owner: 'IR Director',
        ),
        RemediationItem(
          title: 'Section 302: Complete deficiency disclosure',
          description: 'Ensure all control deficiencies are properly disclosed in quarterly report',
          priority: RemediationPriority.medium,
          status: RemediationStatus.inProgress,
          due: '2026-05-15',
          owner: 'CFO',
        ),
        RemediationItem(
          title: 'Section 404: Complete ITGC documentation',
          description: 'Finish documenting and testing IT general controls',
          priority: RemediationPriority.medium,
          status: RemediationStatus.open,
          due: '2026-06-30',
          owner: 'IT Audit Manager',
        ),
      ],
    );
  }
}
