class QuickInvestigationModel {
  final String id;
  final String title;
  final String queryPrompt;

  const QuickInvestigationModel({
    required this.id,
    required this.title,
    required this.queryPrompt,
  });

  static List<QuickInvestigationModel> getQuickInvestigations() {
    return const [
      QuickInvestigationModel(
        id: 'qi-1',
        title: 'Investigate INC-2847 suspicious login',
        queryPrompt: 'Investigate INC-2847 suspicious login',
      ),
      QuickInvestigationModel(
        id: 'qi-2',
        title: 'Analyze public S3 bucket F-2401',
        queryPrompt: 'Analyze public S3 bucket F-2401 for sensitive data exposure',
      ),
      QuickInvestigationModel(
        id: 'qi-3',
        title: 'Show privileged access risks',
        queryPrompt: 'Show privileged access risks and excessive IAM permissions',
      ),
      QuickInvestigationModel(
        id: 'qi-4',
        title: 'What is our compliance posture?',
        queryPrompt: 'What is our compliance posture against NIST CSF and SOC 2?',
      ),
      QuickInvestigationModel(
        id: 'qi-5',
        title: 'Summarize malware incident INC-2842',
        queryPrompt: 'Summarize malware incident INC-2842 and containment status',
      ),
      QuickInvestigationModel(
        id: 'qi-6',
        title: 'Investigate SharePoint data download',
        queryPrompt: 'Investigate SharePoint data download',
      ),
    ];
  }
}
