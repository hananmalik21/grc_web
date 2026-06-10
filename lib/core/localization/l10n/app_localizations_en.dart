// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GRC Web';

  @override
  String get authTitle => 'Authentication';

  @override
  String get loadUser => 'Load user';

  @override
  String get loading => 'Loading…';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String userGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get noUserYet => 'No user loaded yet';

  @override
  String userId(String id) {
    return 'ID: $id';
  }

  @override
  String get toggleLanguage => 'Language';

  @override
  String get toggleTheme => 'Theme';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardSubtitle => 'Real-time system overview and controls';

  @override
  String get totalUsers => 'Total Users';

  @override
  String get revenue => 'Revenue';

  @override
  String get activeProjects => 'Active Projects';

  @override
  String get systemHealth => 'System Health';

  @override
  String get recentActivities => 'Recent Activities';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get analyticsOverview => 'Analytics Overview';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get profile => 'Profile';

  @override
  String get searchPlaceholder => 'Search dashboard...';

  @override
  String get headerTitle => 'Integrated GRC Platform';

  @override
  String get headerSubtitle =>
      'Cybersecurity, Governance & Security Management';

  @override
  String get userName => 'John Smith';

  @override
  String get userRole => 'GRC Director';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navLibrary => 'Library';

  @override
  String get navAssets => 'Assets';

  @override
  String get navRisks => 'Risks';

  @override
  String get navAssessments => 'Assessments';

  @override
  String get navControls => 'Controls';

  @override
  String get navTprm => 'TPRM';

  @override
  String get navPrograms => 'Programs';

  @override
  String get navReviewProgress => 'Review Progress';

  @override
  String get navRoles => 'Roles';

  @override
  String get statTotalRiskExposure => 'Total Risk Exposure';

  @override
  String get statCriticalRisks => 'Critical Risks';

  @override
  String get statControlEffectiveness => 'Avg Control Effectiveness';

  @override
  String get statVendorRiskScore => 'Vendor Risk Score';

  @override
  String get riskExposureTrend => 'Risk Exposure Trend';

  @override
  String get riskExposureLabel => 'Risk Exposure';

  @override
  String get riskByCategory => 'Risk by Category';

  @override
  String get topRiskAssetsTitle => 'Top Risk Assets (by Financial Exposure)';

  @override
  String get viewAll => 'View All →';

  @override
  String get tableRiskId => 'Risk ID';

  @override
  String get tableAsset => 'Asset';

  @override
  String get tableImpactVar => 'Impact (VaR)';

  @override
  String get tableLikelihood => 'Likelihood';

  @override
  String get tableStatus => 'Status';

  @override
  String get likelihoodHigh => 'High';

  @override
  String get likelihoodMedium => 'Medium';

  @override
  String get likelihoodLow => 'Low';

  @override
  String get statusCritical => 'Critical';

  @override
  String get statusHigh => 'High';

  @override
  String get statusMedium => 'Medium';

  @override
  String get summaryCloudWorkloads => 'Cloud Workloads';

  @override
  String get summaryAcrossProviders => 'Across 4 providers';

  @override
  String get summaryActiveControls => 'Active Controls';

  @override
  String get summaryEffectivePercent => '87% effective';

  @override
  String get summarySecurityEvents => 'Security Events';

  @override
  String get summaryLast30Days => 'Last 30 days';

  @override
  String get libraryTitle => 'Question Library';

  @override
  String get librarySubtitle =>
      'Standard evaluation criteria and assessment questions';

  @override
  String get manageQuestions => 'Manage Questions';

  @override
  String get manageCategories => 'Manage Categories';

  @override
  String get exitEditMode => 'Exit Edit Mode';

  @override
  String get addQuestion => 'Add Question';

  @override
  String get exportLibrary => 'Export Library';

  @override
  String get editModeActive => 'Edit Mode Active';

  @override
  String get editModeDescription =>
      'You can now add, edit, or delete questions in this library. Changes are saved locally in your session.';

  @override
  String get manageCategoriesAndWeights => 'Manage categories and weights';

  @override
  String get addNewQuestionsToCategories => 'Add new questions to categories';

  @override
  String get editExistingQuestions => 'Edit existing questions';

  @override
  String get deleteQuestions => 'Delete questions';

  @override
  String get selectFramework => 'Select Framework';

  @override
  String get questionsLower => 'questions';

  @override
  String get allCategories => 'All Categories';

  @override
  String get searchQuestionsPlaceholder => 'Search questions or tags...';

  @override
  String get totalQuestions => 'Total Questions';

  @override
  String get categories => 'Categories';

  @override
  String get requireEvidence => 'Require Evidence';

  @override
  String get libraryVersion => 'Library Version';

  @override
  String get evidenceRequired => 'Evidence Required';

  @override
  String get evaluationCriteria => 'Evaluation Criteria:';

  @override
  String get relatedControls => 'Related Controls:';

  @override
  String get showGuidance => 'Show Guidance';

  @override
  String manageCategoriesSubtitle(String libraryId, int count) {
    return '$libraryId - $count categories';
  }

  @override
  String get totalCategoryWeight => 'Total Category Weight';

  @override
  String get categoryWeightHint =>
      'Category weights should total 100% for accurate scoring';

  @override
  String get addNewCategory => 'Add New Category';

  @override
  String get newCategory => 'New Category';

  @override
  String get categoryId => 'Category ID';

  @override
  String get categoryName => 'Category Name';

  @override
  String get categoryDescription => 'Description';

  @override
  String get weightPercent => 'Weight (%)';

  @override
  String get categoryWeightContributionHint =>
      'This determines the category\'s contribution to the overall score';

  @override
  String get saveCategory => 'Save Category';

  @override
  String get categoryIdPlaceholder => 'e.g., sox-404';

  @override
  String get categoryNamePlaceholder =>
      'e.g., Section 404 - Management Assessment';

  @override
  String get categoryDescriptionPlaceholder =>
      'Brief description of this category...';

  @override
  String get saveAllChanges => 'Save All Changes';

  @override
  String get cancel => 'Cancel';

  @override
  String categoriesFooterSummary(int count, int weight) {
    return '$count categories • Total weight: $weight%';
  }

  @override
  String get editQuestion => 'Edit Question';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get questionId => 'Question ID';

  @override
  String get questionIdHint => 'Question ID cannot be changed';

  @override
  String get questionText => 'Question Text';

  @override
  String get descriptionOptional => 'Description (Optional)';

  @override
  String get questionType => 'Question Type';

  @override
  String get weightRange => 'Weight (1-10)';

  @override
  String get category => 'Category';

  @override
  String get subcategoryOptional => 'Subcategory (Optional)';

  @override
  String get evaluationCriteriaHint =>
      'Select the criteria applicable to this question';

  @override
  String get criteriaDocumentation => 'Documentation';

  @override
  String get criteriaDocumentationDesc =>
      'Policies, procedures, and documentation completeness';

  @override
  String get criteriaImplementation => 'Implementation';

  @override
  String get criteriaImplementationDesc =>
      'Controls and processes are fully operational';

  @override
  String get criteriaEffectiveness => 'Effectiveness';

  @override
  String get criteriaEffectivenessDesc =>
      'Controls achieve their intended objectives';

  @override
  String get criteriaMonitoring => 'Monitoring';

  @override
  String get criteriaMonitoringDesc =>
      'Regular monitoring and measurement mechanisms';

  @override
  String get criteriaContinuousImprovement => 'Continuous Improvement';

  @override
  String get criteriaContinuousImprovementDesc =>
      'Process for improvement and lessons learned';

  @override
  String criteriaWeightLabel(int percent) {
    return 'Weight: $percent%';
  }

  @override
  String get tags => 'Tags';

  @override
  String get addTagPlaceholder => 'Add tag...';

  @override
  String get relatedControlsOptional => 'Related Controls (Optional)';

  @override
  String get addControlPlaceholder => 'Add control ID...';

  @override
  String get additionalSettings => 'Additional Settings';

  @override
  String get requireEvidenceDescription =>
      'Respondents must provide evidence or documentation for this question';

  @override
  String get guidanceNotesOptional => 'Guidance Notes (Optional)';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get questionTypeYesNo => 'Yes No';

  @override
  String get addNewQuestion => 'Add New Question';

  @override
  String get questionIdPlaceholder => 'e.g., sox-404-001';

  @override
  String get questionTextPlaceholder => 'Enter the question text...';

  @override
  String get descriptionPlaceholder => 'Additional context or explanation...';

  @override
  String get categoryPlaceholder => 'e.g., Management Assessment';

  @override
  String get subcategoryPlaceholder => 'e.g., Control Framework';

  @override
  String get guidanceNotesPlaceholder =>
      'Provide guidance for assessors on how to answer this question...';

  @override
  String get assetRegistryTitle => 'Asset Registry';

  @override
  String get assetRegistrySubtitle => 'Manage and monitor enterprise assets';

  @override
  String get addAsset => 'Add Asset';

  @override
  String get statTotalAssets => 'Total Assets';

  @override
  String get statApplications => 'Applications';

  @override
  String get statCloud => 'Cloud';

  @override
  String get statData => 'Data';

  @override
  String get statTotalValue => 'Total Value';

  @override
  String get searchAssetsPlaceholder => 'Search assets by name or ID...';

  @override
  String get allTypes => 'All Types';

  @override
  String get moreFilters => 'More Filters';

  @override
  String get export => 'Export';

  @override
  String get tableAssetId => 'Asset ID';

  @override
  String get tableName => 'Name';

  @override
  String get tableType => 'Type';

  @override
  String get tableBusinessValue => 'Business Value';

  @override
  String get tableOwner => 'Owner';

  @override
  String get tableEnvironment => 'Environment';

  @override
  String get tableCloudProvider => 'Cloud Provider';

  @override
  String get tableRiskLevel => 'Risk Level';

  @override
  String get tableClassification => 'Classification';

  @override
  String get tableActions => 'Actions';

  @override
  String get assetTypeData => 'Data';

  @override
  String get assetTypeApplication => 'Application';

  @override
  String get assetTypeInfrastructure => 'Infrastructure';

  @override
  String get assetTypeCloud => 'Cloud';

  @override
  String get classificationConfidential => 'Confidential';

  @override
  String get classificationInternal => 'Internal';

  @override
  String get addNewAsset => 'Add New Asset';

  @override
  String get assetName => 'Asset Name';

  @override
  String get assetType => 'Asset Type';

  @override
  String get assetDescription => 'Description';

  @override
  String get businessValue => 'Business Value (\$)';

  @override
  String get assetOwner => 'Owner';

  @override
  String get location => 'Location';

  @override
  String get ipAddressEndpoint => 'IP Address / Endpoint';

  @override
  String get criticality => 'Criticality';

  @override
  String get complianceRequirements => 'Compliance Requirements';

  @override
  String get complianceIso27001 => 'ISO 27001';

  @override
  String get complianceSoc2 => 'SOC 2';

  @override
  String get complianceGdpr => 'GDPR';

  @override
  String get complianceHipaa => 'HIPAA';

  @override
  String get compliancePciDss => 'PCI-DSS';

  @override
  String get complianceNist => 'NIST';

  @override
  String get complianceCis => 'CIS';

  @override
  String get complianceFedRamp => 'FedRAMP';

  @override
  String get assetTags => 'Tags';

  @override
  String get enterAssetName => 'Enter asset name';

  @override
  String get assetDescriptionPlaceholder =>
      'Describe the asset and its purpose';

  @override
  String get assetOwnerPlaceholder => 'Owner name or team';

  @override
  String get locationPlaceholder => 'e.g., us-east-1, Europe, Data Center A';

  @override
  String get ipAddressPlaceholder => 'IP address or URL';

  @override
  String get assetTagsPlaceholder =>
      'Separate tags with commas (e.g., critical, customer-facing, pii)';

  @override
  String get envProduction => 'Production';

  @override
  String get envStaging => 'Staging';

  @override
  String get envDevelopment => 'Development';

  @override
  String get envOnPrem => 'On-Prem';

  @override
  String get providerAws => 'AWS';

  @override
  String get providerAzure => 'Azure';

  @override
  String get providerGcp => 'GCP';

  @override
  String get securityInformation => 'Security Information';

  @override
  String get infrastructure => 'Infrastructure';

  @override
  String get relatedItems => 'Related Items';

  @override
  String get linkedRisks => 'Linked Risks';

  @override
  String get appliedControls => 'Applied Controls';

  @override
  String get editAsset => 'Edit Asset';

  @override
  String get viewRisks => 'View Risks';

  @override
  String get viewControls => 'View Controls';

  @override
  String get deleteAsset => 'Delete Asset';

  @override
  String get riskRegistryTitle => 'Risk Register';

  @override
  String get riskRegistrySubtitle =>
      'Comprehensive risk management with quantified assessment';

  @override
  String get addRisk => 'Add Risk';

  @override
  String get statInherentRisk => 'Inherent Risk (VaR)';

  @override
  String get statResidualRisk => 'Residual Risk (VaR)';

  @override
  String get statRiskReduction => 'Risk Reduction';

  @override
  String get riskHeatMapTitle => 'Risk Heat Map (Likelihood × Impact)';

  @override
  String get heatMapLikelihoodHeader => 'Likelihood';

  @override
  String get heatMapColLow => 'Low (1-4)';

  @override
  String get heatMapColMedium => 'Medium (5-9)';

  @override
  String get heatMapColHigh => 'High (10-14)';

  @override
  String get heatMapColCritical => 'Critical (15-25)';

  @override
  String get heatMapRowVeryHigh => 'Very High (5)';

  @override
  String get heatMapRowHigh => 'High (4)';

  @override
  String get heatMapRowMedium => 'Medium (3)';

  @override
  String get heatMapRowLow => 'Low (2)';

  @override
  String get heatMapRowVeryLow => 'Very Low (1)';

  @override
  String get searchRisksPlaceholder => 'Search risks by title or ID...';

  @override
  String get allStatuses => 'All Statuses';

  @override
  String get tableRiskTitle => 'Title';

  @override
  String get tableRiskAssets => 'Assets';

  @override
  String get tableRiskCategory => 'Category';

  @override
  String get tableImpactDollar => 'Impact (\$)';

  @override
  String get tableInherent => 'Inherent';

  @override
  String get tableResidual => 'Residual';

  @override
  String get tableTreatment => 'Treatment';

  @override
  String get statusAssessed => 'Assessed';

  @override
  String get statusTreated => 'Treated';

  @override
  String get statusMonitored => 'Monitored';

  @override
  String get likelihoodVeryHigh => 'Very High';

  @override
  String get likelihoodVeryLow => 'Very Low';

  @override
  String get treatmentMitigate => 'Mitigate';

  @override
  String get treatmentTransfer => 'Transfer';

  @override
  String get treatmentAccept => 'Accept';

  @override
  String get treatmentAvoid => 'Avoid';

  @override
  String get riskManagementIntegration => 'Risk Management Integration';

  @override
  String get integrationLinkedToAssets => 'Linked to Assets';

  @override
  String get integrationLinkedToAssetsDesc =>
      'Connect risks to asset inventory';

  @override
  String get integrationControlMapping => 'Control Mapping';

  @override
  String get integrationControlMappingDesc => 'Map controls to reduce risk';

  @override
  String get integrationAssessmentFramework => 'Assessment Framework';

  @override
  String get integrationAssessmentFrameworkDesc =>
      'Use question library for assessments';

  @override
  String get integrationMitigationPrograms => 'Mitigation Programs';

  @override
  String get integrationMitigationProgramsDesc => 'Track remediation actions';

  @override
  String get addNewRisk => 'Add New Risk';

  @override
  String get stepIdentification => 'Identification';

  @override
  String get stepAssessment => 'Assessment';

  @override
  String get stepTreatment => 'Treatment';

  @override
  String get stepControls => 'Controls';

  @override
  String get stepMitigation => 'Mitigation';

  @override
  String get riskIdentificationTitle => 'Risk Identification';

  @override
  String get riskTitleLabel => 'Risk Title';

  @override
  String get riskTitlePlaceholder => 'e.g., Data Breach - Customer Database';

  @override
  String get riskDescriptionPlaceholder =>
      'Detailed description of the risk...';

  @override
  String get riskSubcategoryLabel => 'Subcategory';

  @override
  String get riskSubcategoryPlaceholder => 'Optional subcategory';

  @override
  String get affectedAssets => 'Affected Assets';

  @override
  String get holdCtrlToSelectMultiple => 'Hold Ctrl/Cmd to select multiple';

  @override
  String get rootCause => 'Root Cause';

  @override
  String get rootCausePlaceholder => 'What is the root cause of this risk?';

  @override
  String get consequences => 'Consequences';

  @override
  String get addConsequencePlaceholder => 'Add consequence...';

  @override
  String get vulnerabilities => 'Vulnerabilities';

  @override
  String get addVulnerabilityPlaceholder => 'Add vulnerability...';

  @override
  String get threats => 'Threats';

  @override
  String get addThreatPlaceholder => 'Add threat...';

  @override
  String get riskOwner => 'Risk Owner';

  @override
  String get riskOwnerPlaceholder => 'e.g., CISO';

  @override
  String get ownerRole => 'Owner Role';

  @override
  String get ownerRolePlaceholder => 'e.g., Chief Information Security Officer';

  @override
  String get department => 'Department';

  @override
  String get departmentPlaceholder => 'e.g., Information Security';

  @override
  String get next => 'Next';

  @override
  String get riskAssessmentTitle => 'Risk Assessment';

  @override
  String get inherentLikelihood => 'Inherent Likelihood';

  @override
  String get inherentImpact => 'Inherent Impact';

  @override
  String get financialImpactUsd => 'Financial Impact (USD)';

  @override
  String get financialImpactHint =>
      'Estimated financial loss if risk materializes';

  @override
  String get inherentRiskScore => 'Inherent Risk Score';

  @override
  String get score => 'Score';

  @override
  String get rating => 'Rating';

  @override
  String get valueAtRisk => 'Value at Risk';

  @override
  String get previous => 'Previous';

  @override
  String get likelihoodVeryLowPct => '20% probability';

  @override
  String get likelihoodLowPct => '40% probability';

  @override
  String get likelihoodMediumPct => '60% probability';

  @override
  String get likelihoodHighPct => '80% probability';

  @override
  String get likelihoodVeryHighPct => '100% probability';

  @override
  String get riskTreatmentStrategyTitle => 'Risk Treatment Strategy';

  @override
  String get treatmentStrategyLabel => 'Treatment Strategy';

  @override
  String get statusLabel => 'Status';

  @override
  String get riskAppetite => 'Risk Appetite';

  @override
  String get riskToleranceUsd => 'Risk Tolerance (USD)';

  @override
  String get treatmentPlan => 'Treatment Plan';

  @override
  String get treatmentPlanPlaceholder =>
      'Describe the treatment plan and strategy...';

  @override
  String get statusIdentified => 'Identified';

  @override
  String get appetiteCautious => 'Cautious';

  @override
  String get appetiteModerate => 'Moderate';

  @override
  String get appetiteAggressive => 'Aggressive';

  @override
  String get controlEffectivenessTitle => 'Control Effectiveness';

  @override
  String get overallControlEffectiveness => 'Overall Control Effectiveness (%)';

  @override
  String get residualRiskAfterControls => 'Residual Risk (After Controls)';

  @override
  String get controlsNoteText =>
      'Note: Link specific controls in the next step to track individual control effectiveness and test results.';

  @override
  String get likelihood => 'Likelihood';

  @override
  String get impact => 'Impact';

  @override
  String reduction(String pct) {
    return '↓ $pct% reduction';
  }

  @override
  String get mitigationActionsTitle => 'Mitigation Actions';

  @override
  String get mitigationInfoText =>
      'After saving, you can add detailed mitigation actions, link controls, and track progress in the risk detail view.';

  @override
  String get notesLabel => 'Notes';

  @override
  String get notesPlaceholder => 'Additional notes or comments...';

  @override
  String get riskSummary => 'Risk Summary';

  @override
  String get summaryTitle => 'Title';

  @override
  String get inherentRisk => 'Inherent Risk';

  @override
  String get residualRisk => 'Residual Risk';

  @override
  String get summaryTreatment => 'Treatment';

  @override
  String get summaryOwner => 'Owner';

  @override
  String get saveRisk => 'Save Risk';

  @override
  String get notSet => 'Not set';

  @override
  String get categoryCyberSecurity => 'Cyber Security';

  @override
  String get categoryDataSecurity => 'Data Security';

  @override
  String get categoryOperational => 'Operational';

  @override
  String get categoryCloudSecurity => 'Cloud Security';

  @override
  String get categoryAccessControl => 'Access Control';

  @override
  String get categoryThirdPartyRisk => 'Third Party Risk';

  @override
  String get categoryTechnology => 'Technology';

  @override
  String get riskInformation => 'Risk Information';

  @override
  String get linkedAssetsLabel => 'Linked Assets';

  @override
  String get inherentRiskVar => 'Inherent Risk (VaR)';

  @override
  String get controlEffectivenessLabel => 'Control Effectiveness';

  @override
  String get residualRiskVar => 'Residual Risk (VaR)';

  @override
  String get riskReductionLabel => 'Risk Reduction';

  @override
  String get editRisk => 'Edit Risk';

  @override
  String get riskIdPrefix => 'Risk ID:';

  @override
  String get likelihoodLabel => 'Likelihood';

  @override
  String get impactLabel => 'Impact';

  @override
  String get frameworkAssessmentsTitle => 'Framework Assessments';

  @override
  String get frameworkAssessmentsSubtitle =>
      'Manage and assess compliance across multiple frameworks';

  @override
  String get assessmentHubTitle => 'Assessment Hub';

  @override
  String get assessmentHubSubtitle =>
      'Comprehensive framework assessments with standardized criteria';

  @override
  String get assessmentHubDescription =>
      'Access the question library with 42 questions across 3 frameworks. Conduct assessments with weighted scoring, evidence collection, and real-time compliance tracking.';

  @override
  String get launchAssessmentHub => 'Launch Assessment Hub';

  @override
  String get hubLibraries => 'Libraries';

  @override
  String get hubQuestions => 'Questions';

  @override
  String get hubCriteria => 'Criteria';

  @override
  String get statTotalFrameworks => 'Total Frameworks';

  @override
  String get statAvgCompliance => 'Avg Compliance';

  @override
  String get statTotalControls => 'Total Controls';

  @override
  String get statActiveFrameworks => 'Active Frameworks';

  @override
  String get complianceLevel => 'Compliance Level';

  @override
  String get frameworkStatusLabel => 'Status';

  @override
  String get frameworkControlsLabel => 'Controls';

  @override
  String get lastAssessmentLabel => 'Last Assessment';

  @override
  String get frameworkStatusActive => 'Active';

  @override
  String get frameworkStatusInProgress => 'In Progress';

  @override
  String get exportReport => 'Export Report';

  @override
  String get complianceScore => 'Compliance Score';

  @override
  String get compliantControls => 'Compliant Controls';

  @override
  String outOfTotal(int total) {
    return 'Out of $total total';
  }

  @override
  String get partialComplianceLabel => 'Partial Compliance';

  @override
  String get needsImprovement => 'Needs improvement';

  @override
  String get nonCompliantLabel => 'Non-Compliant';

  @override
  String get immediateActionRequired => 'Immediate action required';

  @override
  String get complianceShort => 'Compliance';

  @override
  String compliantCount(int count) {
    return '$count Compliant';
  }

  @override
  String partialCount(int count) {
    return '$count Partial';
  }

  @override
  String nonCompliantCount(int count) {
    return '$count Non-Compliant';
  }

  @override
  String get remediationActionItems => 'Remediation Action Items';

  @override
  String openCompletedSummary(int open, int completed) {
    return '$open open items • $completed completed';
  }

  @override
  String get addAction => 'Add Action';

  @override
  String dueDate(String date) {
    return 'Due: $date';
  }

  @override
  String ownerName(String name) {
    return 'Owner: $name';
  }

  @override
  String get priorityHigh => 'high';

  @override
  String get priorityMedium => 'medium';

  @override
  String get remediationStatusOpen => 'open';

  @override
  String get remediationStatusInProgress => 'in-progress';

  @override
  String get answerYes => 'Yes';

  @override
  String get answerPartial => 'Partial';

  @override
  String get answerNo => 'No';

  @override
  String get answerNa => 'N/A';

  @override
  String get evidenceLabel => 'Evidence';

  @override
  String get addRemediationAction => 'Add Remediation Action';

  @override
  String get relatedSectionLabel => 'Related Section';

  @override
  String get selectSectionHint => 'Select section';

  @override
  String get actionTitleLabel => 'Action Title';

  @override
  String get actionTitleHint => 'Brief action item title';

  @override
  String get actionDescriptionLabel => 'Description';

  @override
  String get actionDescriptionHint =>
      'Detailed description of the action needed';

  @override
  String get priorityLabel => 'Priority';

  @override
  String get dueDateLabel => 'Due Date';

  @override
  String get ownerLabel => 'Owner';

  @override
  String get ownerHint => 'Responsible person/team';

  @override
  String get createAction => 'Create Action';

  @override
  String get optionHigh => 'High';

  @override
  String get optionMedium => 'Medium';

  @override
  String get optionLow => 'Low';

  @override
  String get optionOpen => 'Open';

  @override
  String get optionInProgress => 'In Progress';

  @override
  String get optionCompleted => 'Completed';

  @override
  String get hubPageSubtitle =>
      'Comprehensive framework assessments with standardized evaluation criteria';

  @override
  String get addAssessment => 'Add Assessment';

  @override
  String get hubQuestionLibraries => 'Question Libraries';

  @override
  String get hubTotalQuestions => 'Total Questions';

  @override
  String get hubStandardCriteria => 'Standard Criteria';

  @override
  String get hubCustomAssessments => 'Custom Assessments';

  @override
  String get hubStandardEvaluationCriteria => 'Standard Evaluation Criteria';

  @override
  String get hubCriteriaIntro =>
      'All assessments use these standardized criteria to ensure consistent and objective evaluation across frameworks.';

  @override
  String get hubStandardFrameworkAssessments =>
      'Standard Framework Assessments';

  @override
  String get hubAssessmentFeatures => 'Assessment Features';

  @override
  String weightValue(int value) {
    return 'Weight: $value%';
  }

  @override
  String get soxComplianceAssessment => 'SOX Compliance Assessment';

  @override
  String get soxComplianceDesc =>
      'Comprehensive assessment for Sarbanes-Oxley Act compliance with 14 questions across 3 categories.';

  @override
  String get cosoErmAssessment => 'COSO ERM Assessment';

  @override
  String get cosoErmDesc =>
      'Enterprise Risk Management framework assessment with 8 questions across 3 components.';

  @override
  String get cybersecurityAssessment => 'Cybersecurity Assessment';

  @override
  String get cybersecurityDesc =>
      'NIST CSF and ISO 27001 aligned assessment with 20 questions across 5 functions.';

  @override
  String get hubQuestionsLabel => 'Questions:';

  @override
  String get hubCategoriesLabel => 'Categories:';

  @override
  String get hubEstTimeLabel => 'Est. Time:';

  @override
  String get startAssessment => 'Start Assessment';

  @override
  String get featureWeightedScoring => 'Weighted Scoring';

  @override
  String get featureWeightedScoringDesc =>
      'Questions and criteria weighted by importance';

  @override
  String get featureRealTimeScoring => 'Real-time Scoring';

  @override
  String get featureRealTimeScoringDesc =>
      'Automatic calculation as you answer';

  @override
  String get featureEvidenceCollection => 'Evidence Collection';

  @override
  String get featureEvidenceCollectionDesc =>
      'Attach evidence and documentation';

  @override
  String get featureProgressTracking => 'Progress Tracking';

  @override
  String get featureProgressTrackingDesc => 'Track completion by category';

  @override
  String get qlibSaveDraft => 'Save Draft';

  @override
  String get qlibSubmit => 'Submit Assessment';

  @override
  String get qlibQuestionsAnswered => 'Questions Answered';

  @override
  String get qlibOverallScore => 'Overall Score';

  @override
  String get qlibNeedsImprovement => 'Needs Improvement';

  @override
  String get qlibEvidenceAttached => 'Evidence Attached';

  @override
  String get qlibFindings => 'Findings';

  @override
  String get qlibCategories => 'Categories';

  @override
  String get qlibCategoryProgress => 'Category Progress';

  @override
  String qlibAnswered(int answered, int total) {
    return '$answered/$total answered';
  }

  @override
  String get qlibResponse => 'Response';

  @override
  String qlibQuestionWeight(int value) {
    return 'Weight: $value';
  }

  @override
  String get qlibNotesOptional => 'Notes (Optional)';

  @override
  String get qlibEvidencePlaceholder =>
      'Provide evidence or reference documentation...';

  @override
  String get qlibNotesPlaceholder => 'Additional notes or context...';

  @override
  String get qlibPreviousCategory => 'Previous Category';

  @override
  String get qlibNextCategory => 'Next Category';

  @override
  String qlibCategoryOf(int current, int total) {
    return 'Category $current of $total';
  }

  @override
  String get qlibAnsweredBadge => 'Answered';

  @override
  String qlibScore(int value) {
    return 'Score: $value%';
  }

  @override
  String get qlibSelectOption => 'Select an option...';

  @override
  String get caTitle => 'Create New Assessment';

  @override
  String get caNameLabel => 'Assessment Name';

  @override
  String get caNameHint => 'e.g., Custom Security Assessment';

  @override
  String get caDescriptionLabel => 'Description';

  @override
  String get caDescriptionHint => 'Brief description of the assessment';

  @override
  String get caSelectCategory => 'Select category';

  @override
  String get caColorThemeLabel => 'Color Theme';

  @override
  String get caQuestionsLabel => 'Questions';

  @override
  String get caEstTimeLabel => 'Est. Time';

  @override
  String get caEstTimeHint => '30-45 min';

  @override
  String get createAssessment => 'Create Assessment';

  @override
  String get caCatCompliance => 'Compliance';

  @override
  String get caCatSecurity => 'Security';

  @override
  String get caCatPrivacy => 'Privacy';

  @override
  String get caCatOperational => 'Operational';

  @override
  String get caCatFinancial => 'Financial';

  @override
  String get themeBlue => 'Blue';

  @override
  String get themeGreen => 'Green';

  @override
  String get themePurple => 'Purple';

  @override
  String get themeOrange => 'Orange';

  @override
  String get themeRed => 'Red';
}
