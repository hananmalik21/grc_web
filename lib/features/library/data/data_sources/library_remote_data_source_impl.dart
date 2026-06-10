import 'package:dio/dio.dart';
import 'package:grc_web/features/library/data/data_sources/library_remote_data_source.dart';
import 'package:grc_web/features/library/domain/entities/library_entities.dart';

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  const LibraryRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<LibraryData> getLibrary() async {
    _dio.options.headers;
    await Future<void>.delayed(const Duration(milliseconds: 600));

    const framework = LibraryFramework(
      id: 'sox',
      title: 'SOX Compliance Question Library',
      questionCount: 11,
    );

    return LibraryData(
      frameworks: const [framework],
      selectedFrameworkId: framework.id,
      totalQuestions: 11,
      categories: 3,
      requireEvidence: 9,
      version: '1.0.0',
      sections: const [
        LibrarySection(
          id: '302',
          title: 'Section 302 - Corporate Responsibility',
          subtitle: 'CEO/CFO certification of financial reports and internal controls',
          questionCount: 4,
          weightPercent: 25,
          questions: [
            LibraryQuestion(
              id: 'sox-302-001',
              code: 'sox-302-001',
              title: 'Are financial reports reviewed and certified by CEO and CFO before filing?',
              description: 'Quarterly and annual reports must be certified by principal officers',
              weight: 10,
              requiresEvidence: true,
              typeChip: 'yes-no',
              categoryChips: ['Corporate Responsibility', 'Certification Process'],
              tags: ['#certification', '#financial-reporting', '#executive'],
              evaluationCriteria: [
                EvaluationCriterion(
                  title: 'Documentation',
                  weightPercent: 20,
                  iconAsset: 'assets/figma/library/svg/criteria_doc.svg',
                ),
                EvaluationCriterion(
                  title: 'Implementation',
                  weightPercent: 30,
                  iconAsset: 'assets/figma/library/svg/criteria_impl.svg',
                ),
                EvaluationCriterion(
                  title: 'Effectiveness',
                  weightPercent: 25,
                  iconAsset: 'assets/figma/library/svg/criteria_impl.svg',
                ),
              ],
              relatedControls: ['CTRL-FIN-001', 'CTRL-GOV-002'],
              guidanceNotes:
                  'Review certification documents for last 4 quarters. Verify signatures and dates.',
            ),
            LibraryQuestion(
              id: 'sox-302-002',
              code: 'sox-302-002',
              title: 'Are internal controls assessed for effectiveness on a quarterly basis?',
              description: '',
              weight: 9,
              requiresEvidence: true,
              typeChip: 'yes-no',
              categoryChips: ['Corporate Responsibility', 'Internal Controls'],
              tags: ['#internal-controls', '#quarterly-review'],
              evaluationCriteria: [
                EvaluationCriterion(
                  title: 'Implementation',
                  weightPercent: 30,
                  iconAsset: 'assets/figma/library/svg/criteria_impl.svg',
                ),
              ],
              relatedControls: ['CTRL-GOV-003'],
            ),
            LibraryQuestion(
              id: 'sox-302-003',
              code: 'sox-302-003',
              title: 'Is there a documented process for disclosure controls and procedures?',
              description: 'Management must establish and maintain disclosure controls',
              weight: 8,
              requiresEvidence: true,
              typeChip: 'yes-no',
              categoryChips: ['Corporate Responsibility', 'Disclosure Controls'],
              tags: ['#disclosure', '#controls'],
              evaluationCriteria: [
                EvaluationCriterion(
                  title: 'Documentation',
                  weightPercent: 25,
                  iconAsset: 'assets/figma/library/svg/criteria_doc.svg',
                ),
              ],
              relatedControls: [],
            ),
            LibraryQuestion(
              id: 'sox-302-004',
              code: 'sox-302-004',
              title: 'Are material changes in internal controls communicated to auditors?',
              description: '',
              weight: 7,
              requiresEvidence: false,
              typeChip: 'yes-no',
              categoryChips: ['Corporate Responsibility'],
              tags: ['#auditor-communication'],
              evaluationCriteria: [],
              relatedControls: ['CTRL-AUD-001'],
            ),
          ],
        ),
        LibrarySection(
          id: '404',
          title: 'Section 404 - Management Assessment',
          subtitle: 'Assessment of internal control over financial reporting (ICFR)',
          questionCount: 5,
          weightPercent: 35,
          questions: [
            LibraryQuestion(
              id: 'sox-404-001',
              code: 'sox-404-001',
              title: 'Has management documented and tested internal controls over financial reporting?',
              description: 'Annual assessment required for all material accounts',
              weight: 10,
              requiresEvidence: true,
              typeChip: 'yes-no',
              categoryChips: ['Management Assessment', 'Internal Controls'],
              tags: ['#404', '#financial-reporting'],
              evaluationCriteria: [
                EvaluationCriterion(
                  title: 'Documentation',
                  weightPercent: 20,
                  iconAsset: 'assets/figma/library/svg/criteria_doc.svg',
                ),
                EvaluationCriterion(
                  title: 'Implementation',
                  weightPercent: 35,
                  iconAsset: 'assets/figma/library/svg/criteria_impl.svg',
                ),
              ],
              relatedControls: ['CTRL-FIN-002', 'CTRL-IT-001'],
            ),
          ],
        ),
        LibrarySection(
          id: '409',
          title: 'Section 409 - Real-Time Disclosure',
          subtitle: 'Timely disclosure of material changes in financial condition',
          questionCount: 2,
          weightPercent: 15,
          questions: [
            LibraryQuestion(
              id: 'sox-409-001',
              code: 'sox-409-001',
              title: 'Are material events identified and disclosed within required timeframes?',
              description: 'Events must be disclosed on Form 8-K within 4 business days',
              weight: 8,
              requiresEvidence: true,
              typeChip: 'yes-no',
              categoryChips: ['Real-Time Disclosure', 'Event Monitoring'],
              tags: ['#disclosure', '#material-events'],
              evaluationCriteria: [
                EvaluationCriterion(
                  title: 'Monitoring',
                  weightPercent: 15,
                  iconAsset: 'assets/figma/library/svg/criteria_impl.svg',
                ),
              ],
              relatedControls: ['CTRL-DISC-001'],
            ),
            LibraryQuestion(
              id: 'sox-409-002',
              code: 'sox-409-002',
              title: 'Are disclosure timelines monitored and tracked against regulatory requirements?',
              description: '',
              weight: 7,
              requiresEvidence: true,
              typeChip: 'yes-no',
              categoryChips: ['Real-Time Disclosure', 'Timeline Monitoring'],
              tags: ['#timeline', '#monitoring', '#compliance'],
              evaluationCriteria: [
                EvaluationCriterion(
                  title: 'Monitoring',
                  weightPercent: 15,
                  iconAsset: 'assets/figma/library/svg/criteria_impl.svg',
                ),
              ],
              relatedControls: [],
            ),
          ],
        ),
      ],
    );
  }
}
