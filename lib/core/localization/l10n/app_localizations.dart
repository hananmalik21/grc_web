import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'GRC Web'**
  String get appTitle;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authTitle;

  /// No description provided for @loadUser.
  ///
  /// In en, this message translates to:
  /// **'Load user'**
  String get loadUser;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Greeting for signed-in user
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String userGreeting(String name);

  /// No description provided for @noUserYet.
  ///
  /// In en, this message translates to:
  /// **'No user loaded yet'**
  String get noUserYet;

  /// Label showing user id
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String userId(String id);

  /// No description provided for @toggleLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get toggleLanguage;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get toggleTheme;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-time system overview and controls'**
  String get dashboardSubtitle;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @activeProjects.
  ///
  /// In en, this message translates to:
  /// **'Active Projects'**
  String get activeProjects;

  /// No description provided for @systemHealth.
  ///
  /// In en, this message translates to:
  /// **'System Health'**
  String get systemHealth;

  /// No description provided for @recentActivities.
  ///
  /// In en, this message translates to:
  /// **'Recent Activities'**
  String get recentActivities;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @analyticsOverview.
  ///
  /// In en, this message translates to:
  /// **'Analytics Overview'**
  String get analyticsOverview;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search dashboard...'**
  String get searchPlaceholder;

  /// No description provided for @headerTitle.
  ///
  /// In en, this message translates to:
  /// **'Integrated GRC Platform'**
  String get headerTitle;

  /// No description provided for @headerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cybersecurity, Governance & Security Management'**
  String get headerSubtitle;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'John Smith'**
  String get userName;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'GRC Director'**
  String get userRole;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get navAssets;

  /// No description provided for @navRisks.
  ///
  /// In en, this message translates to:
  /// **'Risks'**
  String get navRisks;

  /// No description provided for @navAssessments.
  ///
  /// In en, this message translates to:
  /// **'Assessments'**
  String get navAssessments;

  /// No description provided for @navControls.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get navControls;

  /// No description provided for @navTprm.
  ///
  /// In en, this message translates to:
  /// **'TPRM'**
  String get navTprm;

  /// No description provided for @navPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get navPrograms;

  /// No description provided for @navReviewProgress.
  ///
  /// In en, this message translates to:
  /// **'Review Progress'**
  String get navReviewProgress;

  /// No description provided for @navRoles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get navRoles;

  /// No description provided for @statTotalRiskExposure.
  ///
  /// In en, this message translates to:
  /// **'Total Risk Exposure'**
  String get statTotalRiskExposure;

  /// No description provided for @statCriticalRisks.
  ///
  /// In en, this message translates to:
  /// **'Critical Risks'**
  String get statCriticalRisks;

  /// No description provided for @statControlEffectiveness.
  ///
  /// In en, this message translates to:
  /// **'Avg Control Effectiveness'**
  String get statControlEffectiveness;

  /// No description provided for @statVendorRiskScore.
  ///
  /// In en, this message translates to:
  /// **'Vendor Risk Score'**
  String get statVendorRiskScore;

  /// No description provided for @riskExposureTrend.
  ///
  /// In en, this message translates to:
  /// **'Risk Exposure Trend'**
  String get riskExposureTrend;

  /// No description provided for @riskExposureLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Exposure'**
  String get riskExposureLabel;

  /// No description provided for @riskByCategory.
  ///
  /// In en, this message translates to:
  /// **'Risk by Category'**
  String get riskByCategory;

  /// No description provided for @topRiskAssetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Risk Assets (by Financial Exposure)'**
  String get topRiskAssetsTitle;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All →'**
  String get viewAll;

  /// No description provided for @tableRiskId.
  ///
  /// In en, this message translates to:
  /// **'Risk ID'**
  String get tableRiskId;

  /// No description provided for @tableAsset.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get tableAsset;

  /// No description provided for @tableImpactVar.
  ///
  /// In en, this message translates to:
  /// **'Impact (VaR)'**
  String get tableImpactVar;

  /// No description provided for @tableLikelihood.
  ///
  /// In en, this message translates to:
  /// **'Likelihood'**
  String get tableLikelihood;

  /// No description provided for @tableStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tableStatus;

  /// No description provided for @likelihoodHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get likelihoodHigh;

  /// No description provided for @likelihoodMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get likelihoodMedium;

  /// No description provided for @likelihoodLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get likelihoodLow;

  /// No description provided for @statusCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get statusCritical;

  /// No description provided for @statusHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get statusHigh;

  /// No description provided for @statusMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get statusMedium;

  /// No description provided for @summaryCloudWorkloads.
  ///
  /// In en, this message translates to:
  /// **'Cloud Workloads'**
  String get summaryCloudWorkloads;

  /// No description provided for @summaryAcrossProviders.
  ///
  /// In en, this message translates to:
  /// **'Across 4 providers'**
  String get summaryAcrossProviders;

  /// No description provided for @summaryActiveControls.
  ///
  /// In en, this message translates to:
  /// **'Active Controls'**
  String get summaryActiveControls;

  /// No description provided for @summaryEffectivePercent.
  ///
  /// In en, this message translates to:
  /// **'87% effective'**
  String get summaryEffectivePercent;

  /// No description provided for @summarySecurityEvents.
  ///
  /// In en, this message translates to:
  /// **'Security Events'**
  String get summarySecurityEvents;

  /// No description provided for @summaryLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get summaryLast30Days;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Question Library'**
  String get libraryTitle;

  /// No description provided for @librarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Standard evaluation criteria and assessment questions'**
  String get librarySubtitle;

  /// No description provided for @manageQuestions.
  ///
  /// In en, this message translates to:
  /// **'Manage Questions'**
  String get manageQuestions;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get manageCategories;

  /// No description provided for @exitEditMode.
  ///
  /// In en, this message translates to:
  /// **'Exit Edit Mode'**
  String get exitEditMode;

  /// No description provided for @addQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add Question'**
  String get addQuestion;

  /// No description provided for @exportLibrary.
  ///
  /// In en, this message translates to:
  /// **'Export Library'**
  String get exportLibrary;

  /// No description provided for @editModeActive.
  ///
  /// In en, this message translates to:
  /// **'Edit Mode Active'**
  String get editModeActive;

  /// No description provided for @editModeDescription.
  ///
  /// In en, this message translates to:
  /// **'You can now add, edit, or delete questions in this library. Changes are saved locally in your session.'**
  String get editModeDescription;

  /// No description provided for @manageCategoriesAndWeights.
  ///
  /// In en, this message translates to:
  /// **'Manage categories and weights'**
  String get manageCategoriesAndWeights;

  /// No description provided for @addNewQuestionsToCategories.
  ///
  /// In en, this message translates to:
  /// **'Add new questions to categories'**
  String get addNewQuestionsToCategories;

  /// No description provided for @editExistingQuestions.
  ///
  /// In en, this message translates to:
  /// **'Edit existing questions'**
  String get editExistingQuestions;

  /// No description provided for @deleteQuestions.
  ///
  /// In en, this message translates to:
  /// **'Delete questions'**
  String get deleteQuestions;

  /// No description provided for @selectFramework.
  ///
  /// In en, this message translates to:
  /// **'Select Framework'**
  String get selectFramework;

  /// No description provided for @questionsLower.
  ///
  /// In en, this message translates to:
  /// **'questions'**
  String get questionsLower;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @searchQuestionsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search questions or tags...'**
  String get searchQuestionsPlaceholder;

  /// No description provided for @totalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get totalQuestions;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @requireEvidence.
  ///
  /// In en, this message translates to:
  /// **'Require Evidence'**
  String get requireEvidence;

  /// No description provided for @libraryVersion.
  ///
  /// In en, this message translates to:
  /// **'Library Version'**
  String get libraryVersion;

  /// No description provided for @evidenceRequired.
  ///
  /// In en, this message translates to:
  /// **'Evidence Required'**
  String get evidenceRequired;

  /// No description provided for @evaluationCriteria.
  ///
  /// In en, this message translates to:
  /// **'Evaluation Criteria:'**
  String get evaluationCriteria;

  /// No description provided for @relatedControls.
  ///
  /// In en, this message translates to:
  /// **'Related Controls:'**
  String get relatedControls;

  /// No description provided for @showGuidance.
  ///
  /// In en, this message translates to:
  /// **'Show Guidance'**
  String get showGuidance;

  /// No description provided for @manageCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{libraryId} - {count} categories'**
  String manageCategoriesSubtitle(String libraryId, int count);

  /// No description provided for @totalCategoryWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Category Weight'**
  String get totalCategoryWeight;

  /// No description provided for @categoryWeightHint.
  ///
  /// In en, this message translates to:
  /// **'Category weights should total 100% for accurate scoring'**
  String get categoryWeightHint;

  /// No description provided for @addNewCategory.
  ///
  /// In en, this message translates to:
  /// **'Add New Category'**
  String get addNewCategory;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @categoryId.
  ///
  /// In en, this message translates to:
  /// **'Category ID'**
  String get categoryId;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @categoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get categoryDescription;

  /// No description provided for @weightPercent.
  ///
  /// In en, this message translates to:
  /// **'Weight (%)'**
  String get weightPercent;

  /// No description provided for @categoryWeightContributionHint.
  ///
  /// In en, this message translates to:
  /// **'This determines the category\'s contribution to the overall score'**
  String get categoryWeightContributionHint;

  /// No description provided for @saveCategory.
  ///
  /// In en, this message translates to:
  /// **'Save Category'**
  String get saveCategory;

  /// No description provided for @categoryIdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., sox-404'**
  String get categoryIdPlaceholder;

  /// No description provided for @categoryNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Section 404 - Management Assessment'**
  String get categoryNamePlaceholder;

  /// No description provided for @categoryDescriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Brief description of this category...'**
  String get categoryDescriptionPlaceholder;

  /// No description provided for @saveAllChanges.
  ///
  /// In en, this message translates to:
  /// **'Save All Changes'**
  String get saveAllChanges;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @categoriesFooterSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} categories • Total weight: {weight}%'**
  String categoriesFooterSummary(int count, int weight);

  /// No description provided for @editQuestion.
  ///
  /// In en, this message translates to:
  /// **'Edit Question'**
  String get editQuestion;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @questionId.
  ///
  /// In en, this message translates to:
  /// **'Question ID'**
  String get questionId;

  /// No description provided for @questionIdHint.
  ///
  /// In en, this message translates to:
  /// **'Question ID cannot be changed'**
  String get questionIdHint;

  /// No description provided for @questionText.
  ///
  /// In en, this message translates to:
  /// **'Question Text'**
  String get questionText;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @questionType.
  ///
  /// In en, this message translates to:
  /// **'Question Type'**
  String get questionType;

  /// No description provided for @weightRange.
  ///
  /// In en, this message translates to:
  /// **'Weight (1-10)'**
  String get weightRange;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @subcategoryOptional.
  ///
  /// In en, this message translates to:
  /// **'Subcategory (Optional)'**
  String get subcategoryOptional;

  /// No description provided for @evaluationCriteriaHint.
  ///
  /// In en, this message translates to:
  /// **'Select the criteria applicable to this question'**
  String get evaluationCriteriaHint;

  /// No description provided for @criteriaDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get criteriaDocumentation;

  /// No description provided for @criteriaDocumentationDesc.
  ///
  /// In en, this message translates to:
  /// **'Policies, procedures, and documentation completeness'**
  String get criteriaDocumentationDesc;

  /// No description provided for @criteriaImplementation.
  ///
  /// In en, this message translates to:
  /// **'Implementation'**
  String get criteriaImplementation;

  /// No description provided for @criteriaImplementationDesc.
  ///
  /// In en, this message translates to:
  /// **'Controls and processes are fully operational'**
  String get criteriaImplementationDesc;

  /// No description provided for @criteriaEffectiveness.
  ///
  /// In en, this message translates to:
  /// **'Effectiveness'**
  String get criteriaEffectiveness;

  /// No description provided for @criteriaEffectivenessDesc.
  ///
  /// In en, this message translates to:
  /// **'Controls achieve their intended objectives'**
  String get criteriaEffectivenessDesc;

  /// No description provided for @criteriaMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get criteriaMonitoring;

  /// No description provided for @criteriaMonitoringDesc.
  ///
  /// In en, this message translates to:
  /// **'Regular monitoring and measurement mechanisms'**
  String get criteriaMonitoringDesc;

  /// No description provided for @criteriaContinuousImprovement.
  ///
  /// In en, this message translates to:
  /// **'Continuous Improvement'**
  String get criteriaContinuousImprovement;

  /// No description provided for @criteriaContinuousImprovementDesc.
  ///
  /// In en, this message translates to:
  /// **'Process for improvement and lessons learned'**
  String get criteriaContinuousImprovementDesc;

  /// No description provided for @criteriaWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight: {percent}%'**
  String criteriaWeightLabel(int percent);

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @addTagPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add tag...'**
  String get addTagPlaceholder;

  /// No description provided for @relatedControlsOptional.
  ///
  /// In en, this message translates to:
  /// **'Related Controls (Optional)'**
  String get relatedControlsOptional;

  /// No description provided for @addControlPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add control ID...'**
  String get addControlPlaceholder;

  /// No description provided for @additionalSettings.
  ///
  /// In en, this message translates to:
  /// **'Additional Settings'**
  String get additionalSettings;

  /// No description provided for @requireEvidenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Respondents must provide evidence or documentation for this question'**
  String get requireEvidenceDescription;

  /// No description provided for @guidanceNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Guidance Notes (Optional)'**
  String get guidanceNotesOptional;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @questionTypeYesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes No'**
  String get questionTypeYesNo;

  /// No description provided for @addNewQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add New Question'**
  String get addNewQuestion;

  /// No description provided for @questionIdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., sox-404-001'**
  String get questionIdPlaceholder;

  /// No description provided for @questionTextPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter the question text...'**
  String get questionTextPlaceholder;

  /// No description provided for @descriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Additional context or explanation...'**
  String get descriptionPlaceholder;

  /// No description provided for @categoryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Management Assessment'**
  String get categoryPlaceholder;

  /// No description provided for @subcategoryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Control Framework'**
  String get subcategoryPlaceholder;

  /// No description provided for @guidanceNotesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Provide guidance for assessors on how to answer this question...'**
  String get guidanceNotesPlaceholder;

  /// No description provided for @assetRegistryTitle.
  ///
  /// In en, this message translates to:
  /// **'Asset Registry'**
  String get assetRegistryTitle;

  /// No description provided for @assetRegistrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and monitor enterprise assets'**
  String get assetRegistrySubtitle;

  /// No description provided for @addAsset.
  ///
  /// In en, this message translates to:
  /// **'Add Asset'**
  String get addAsset;

  /// No description provided for @statTotalAssets.
  ///
  /// In en, this message translates to:
  /// **'Total Assets'**
  String get statTotalAssets;

  /// No description provided for @statApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get statApplications;

  /// No description provided for @statCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get statCloud;

  /// No description provided for @statData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get statData;

  /// No description provided for @statTotalValue.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get statTotalValue;

  /// No description provided for @searchAssetsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search assets by name or ID...'**
  String get searchAssetsPlaceholder;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypes;

  /// No description provided for @moreFilters.
  ///
  /// In en, this message translates to:
  /// **'More Filters'**
  String get moreFilters;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @tableAssetId.
  ///
  /// In en, this message translates to:
  /// **'Asset ID'**
  String get tableAssetId;

  /// No description provided for @tableName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get tableName;

  /// No description provided for @tableType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tableType;

  /// No description provided for @tableBusinessValue.
  ///
  /// In en, this message translates to:
  /// **'Business Value'**
  String get tableBusinessValue;

  /// No description provided for @tableOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get tableOwner;

  /// No description provided for @tableEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get tableEnvironment;

  /// No description provided for @tableCloudProvider.
  ///
  /// In en, this message translates to:
  /// **'Cloud Provider'**
  String get tableCloudProvider;

  /// No description provided for @tableRiskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk Level'**
  String get tableRiskLevel;

  /// No description provided for @tableClassification.
  ///
  /// In en, this message translates to:
  /// **'Classification'**
  String get tableClassification;

  /// No description provided for @tableActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get tableActions;

  /// No description provided for @assetTypeData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get assetTypeData;

  /// No description provided for @assetTypeApplication.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get assetTypeApplication;

  /// No description provided for @assetTypeInfrastructure.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure'**
  String get assetTypeInfrastructure;

  /// No description provided for @assetTypeCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get assetTypeCloud;

  /// No description provided for @classificationConfidential.
  ///
  /// In en, this message translates to:
  /// **'Confidential'**
  String get classificationConfidential;

  /// No description provided for @classificationInternal.
  ///
  /// In en, this message translates to:
  /// **'Internal'**
  String get classificationInternal;

  /// No description provided for @addNewAsset.
  ///
  /// In en, this message translates to:
  /// **'Add New Asset'**
  String get addNewAsset;

  /// No description provided for @assetName.
  ///
  /// In en, this message translates to:
  /// **'Asset Name'**
  String get assetName;

  /// No description provided for @assetType.
  ///
  /// In en, this message translates to:
  /// **'Asset Type'**
  String get assetType;

  /// No description provided for @assetDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get assetDescription;

  /// No description provided for @businessValue.
  ///
  /// In en, this message translates to:
  /// **'Business Value (\$)'**
  String get businessValue;

  /// No description provided for @assetOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get assetOwner;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @ipAddressEndpoint.
  ///
  /// In en, this message translates to:
  /// **'IP Address / Endpoint'**
  String get ipAddressEndpoint;

  /// No description provided for @criticality.
  ///
  /// In en, this message translates to:
  /// **'Criticality'**
  String get criticality;

  /// No description provided for @complianceRequirements.
  ///
  /// In en, this message translates to:
  /// **'Compliance Requirements'**
  String get complianceRequirements;

  /// No description provided for @complianceIso27001.
  ///
  /// In en, this message translates to:
  /// **'ISO 27001'**
  String get complianceIso27001;

  /// No description provided for @complianceSoc2.
  ///
  /// In en, this message translates to:
  /// **'SOC 2'**
  String get complianceSoc2;

  /// No description provided for @complianceGdpr.
  ///
  /// In en, this message translates to:
  /// **'GDPR'**
  String get complianceGdpr;

  /// No description provided for @complianceHipaa.
  ///
  /// In en, this message translates to:
  /// **'HIPAA'**
  String get complianceHipaa;

  /// No description provided for @compliancePciDss.
  ///
  /// In en, this message translates to:
  /// **'PCI-DSS'**
  String get compliancePciDss;

  /// No description provided for @complianceNist.
  ///
  /// In en, this message translates to:
  /// **'NIST'**
  String get complianceNist;

  /// No description provided for @complianceCis.
  ///
  /// In en, this message translates to:
  /// **'CIS'**
  String get complianceCis;

  /// No description provided for @complianceFedRamp.
  ///
  /// In en, this message translates to:
  /// **'FedRAMP'**
  String get complianceFedRamp;

  /// No description provided for @assetTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get assetTags;

  /// No description provided for @enterAssetName.
  ///
  /// In en, this message translates to:
  /// **'Enter asset name'**
  String get enterAssetName;

  /// No description provided for @assetDescriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe the asset and its purpose'**
  String get assetDescriptionPlaceholder;

  /// No description provided for @assetOwnerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Owner name or team'**
  String get assetOwnerPlaceholder;

  /// No description provided for @locationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., us-east-1, Europe, Data Center A'**
  String get locationPlaceholder;

  /// No description provided for @ipAddressPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'IP address or URL'**
  String get ipAddressPlaceholder;

  /// No description provided for @assetTagsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Separate tags with commas (e.g., critical, customer-facing, pii)'**
  String get assetTagsPlaceholder;

  /// No description provided for @envProduction.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get envProduction;

  /// No description provided for @envStaging.
  ///
  /// In en, this message translates to:
  /// **'Staging'**
  String get envStaging;

  /// No description provided for @envDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get envDevelopment;

  /// No description provided for @envOnPrem.
  ///
  /// In en, this message translates to:
  /// **'On-Prem'**
  String get envOnPrem;

  /// No description provided for @providerAws.
  ///
  /// In en, this message translates to:
  /// **'AWS'**
  String get providerAws;

  /// No description provided for @providerAzure.
  ///
  /// In en, this message translates to:
  /// **'Azure'**
  String get providerAzure;

  /// No description provided for @providerGcp.
  ///
  /// In en, this message translates to:
  /// **'GCP'**
  String get providerGcp;

  /// No description provided for @securityInformation.
  ///
  /// In en, this message translates to:
  /// **'Security Information'**
  String get securityInformation;

  /// No description provided for @infrastructure.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure'**
  String get infrastructure;

  /// No description provided for @relatedItems.
  ///
  /// In en, this message translates to:
  /// **'Related Items'**
  String get relatedItems;

  /// No description provided for @linkedRisks.
  ///
  /// In en, this message translates to:
  /// **'Linked Risks'**
  String get linkedRisks;

  /// No description provided for @appliedControls.
  ///
  /// In en, this message translates to:
  /// **'Applied Controls'**
  String get appliedControls;

  /// No description provided for @editAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit Asset'**
  String get editAsset;

  /// No description provided for @viewRisks.
  ///
  /// In en, this message translates to:
  /// **'View Risks'**
  String get viewRisks;

  /// No description provided for @viewControls.
  ///
  /// In en, this message translates to:
  /// **'View Controls'**
  String get viewControls;

  /// No description provided for @deleteAsset.
  ///
  /// In en, this message translates to:
  /// **'Delete Asset'**
  String get deleteAsset;

  /// No description provided for @riskRegistryTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Register'**
  String get riskRegistryTitle;

  /// No description provided for @riskRegistrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive risk management with quantified assessment'**
  String get riskRegistrySubtitle;

  /// No description provided for @addRisk.
  ///
  /// In en, this message translates to:
  /// **'Add Risk'**
  String get addRisk;

  /// No description provided for @statInherentRisk.
  ///
  /// In en, this message translates to:
  /// **'Inherent Risk (VaR)'**
  String get statInherentRisk;

  /// No description provided for @statResidualRisk.
  ///
  /// In en, this message translates to:
  /// **'Residual Risk (VaR)'**
  String get statResidualRisk;

  /// No description provided for @statRiskReduction.
  ///
  /// In en, this message translates to:
  /// **'Risk Reduction'**
  String get statRiskReduction;

  /// No description provided for @riskHeatMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Heat Map (Likelihood × Impact)'**
  String get riskHeatMapTitle;

  /// No description provided for @heatMapLikelihoodHeader.
  ///
  /// In en, this message translates to:
  /// **'Likelihood'**
  String get heatMapLikelihoodHeader;

  /// No description provided for @heatMapColLow.
  ///
  /// In en, this message translates to:
  /// **'Low (1-4)'**
  String get heatMapColLow;

  /// No description provided for @heatMapColMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium (5-9)'**
  String get heatMapColMedium;

  /// No description provided for @heatMapColHigh.
  ///
  /// In en, this message translates to:
  /// **'High (10-14)'**
  String get heatMapColHigh;

  /// No description provided for @heatMapColCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical (15-25)'**
  String get heatMapColCritical;

  /// No description provided for @heatMapRowVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High (5)'**
  String get heatMapRowVeryHigh;

  /// No description provided for @heatMapRowHigh.
  ///
  /// In en, this message translates to:
  /// **'High (4)'**
  String get heatMapRowHigh;

  /// No description provided for @heatMapRowMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium (3)'**
  String get heatMapRowMedium;

  /// No description provided for @heatMapRowLow.
  ///
  /// In en, this message translates to:
  /// **'Low (2)'**
  String get heatMapRowLow;

  /// No description provided for @heatMapRowVeryLow.
  ///
  /// In en, this message translates to:
  /// **'Very Low (1)'**
  String get heatMapRowVeryLow;

  /// No description provided for @searchRisksPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search risks by title or ID...'**
  String get searchRisksPlaceholder;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get allStatuses;

  /// No description provided for @tableRiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tableRiskTitle;

  /// No description provided for @tableRiskAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get tableRiskAssets;

  /// No description provided for @tableRiskCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get tableRiskCategory;

  /// No description provided for @tableImpactDollar.
  ///
  /// In en, this message translates to:
  /// **'Impact (\$)'**
  String get tableImpactDollar;

  /// No description provided for @tableInherent.
  ///
  /// In en, this message translates to:
  /// **'Inherent'**
  String get tableInherent;

  /// No description provided for @tableResidual.
  ///
  /// In en, this message translates to:
  /// **'Residual'**
  String get tableResidual;

  /// No description provided for @tableTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get tableTreatment;

  /// No description provided for @statusAssessed.
  ///
  /// In en, this message translates to:
  /// **'Assessed'**
  String get statusAssessed;

  /// No description provided for @statusTreated.
  ///
  /// In en, this message translates to:
  /// **'Treated'**
  String get statusTreated;

  /// No description provided for @statusMonitored.
  ///
  /// In en, this message translates to:
  /// **'Monitored'**
  String get statusMonitored;

  /// No description provided for @likelihoodVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get likelihoodVeryHigh;

  /// No description provided for @likelihoodVeryLow.
  ///
  /// In en, this message translates to:
  /// **'Very Low'**
  String get likelihoodVeryLow;

  /// No description provided for @treatmentMitigate.
  ///
  /// In en, this message translates to:
  /// **'Mitigate'**
  String get treatmentMitigate;

  /// No description provided for @treatmentTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get treatmentTransfer;

  /// No description provided for @treatmentAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get treatmentAccept;

  /// No description provided for @treatmentAvoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get treatmentAvoid;

  /// No description provided for @riskManagementIntegration.
  ///
  /// In en, this message translates to:
  /// **'Risk Management Integration'**
  String get riskManagementIntegration;

  /// No description provided for @integrationLinkedToAssets.
  ///
  /// In en, this message translates to:
  /// **'Linked to Assets'**
  String get integrationLinkedToAssets;

  /// No description provided for @integrationLinkedToAssetsDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect risks to asset inventory'**
  String get integrationLinkedToAssetsDesc;

  /// No description provided for @integrationControlMapping.
  ///
  /// In en, this message translates to:
  /// **'Control Mapping'**
  String get integrationControlMapping;

  /// No description provided for @integrationControlMappingDesc.
  ///
  /// In en, this message translates to:
  /// **'Map controls to reduce risk'**
  String get integrationControlMappingDesc;

  /// No description provided for @integrationAssessmentFramework.
  ///
  /// In en, this message translates to:
  /// **'Assessment Framework'**
  String get integrationAssessmentFramework;

  /// No description provided for @integrationAssessmentFrameworkDesc.
  ///
  /// In en, this message translates to:
  /// **'Use question library for assessments'**
  String get integrationAssessmentFrameworkDesc;

  /// No description provided for @integrationMitigationPrograms.
  ///
  /// In en, this message translates to:
  /// **'Mitigation Programs'**
  String get integrationMitigationPrograms;

  /// No description provided for @integrationMitigationProgramsDesc.
  ///
  /// In en, this message translates to:
  /// **'Track remediation actions'**
  String get integrationMitigationProgramsDesc;

  /// No description provided for @addNewRisk.
  ///
  /// In en, this message translates to:
  /// **'Add New Risk'**
  String get addNewRisk;

  /// No description provided for @stepIdentification.
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get stepIdentification;

  /// No description provided for @stepAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get stepAssessment;

  /// No description provided for @stepTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get stepTreatment;

  /// No description provided for @stepControls.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get stepControls;

  /// No description provided for @stepMitigation.
  ///
  /// In en, this message translates to:
  /// **'Mitigation'**
  String get stepMitigation;

  /// No description provided for @riskIdentificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Identification'**
  String get riskIdentificationTitle;

  /// No description provided for @riskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Title'**
  String get riskTitleLabel;

  /// No description provided for @riskTitlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Data Breach - Customer Database'**
  String get riskTitlePlaceholder;

  /// No description provided for @riskDescriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Detailed description of the risk...'**
  String get riskDescriptionPlaceholder;

  /// No description provided for @riskSubcategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get riskSubcategoryLabel;

  /// No description provided for @riskSubcategoryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Optional subcategory'**
  String get riskSubcategoryPlaceholder;

  /// No description provided for @affectedAssets.
  ///
  /// In en, this message translates to:
  /// **'Affected Assets'**
  String get affectedAssets;

  /// No description provided for @holdCtrlToSelectMultiple.
  ///
  /// In en, this message translates to:
  /// **'Hold Ctrl/Cmd to select multiple'**
  String get holdCtrlToSelectMultiple;

  /// No description provided for @rootCause.
  ///
  /// In en, this message translates to:
  /// **'Root Cause'**
  String get rootCause;

  /// No description provided for @rootCausePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'What is the root cause of this risk?'**
  String get rootCausePlaceholder;

  /// No description provided for @consequences.
  ///
  /// In en, this message translates to:
  /// **'Consequences'**
  String get consequences;

  /// No description provided for @addConsequencePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add consequence...'**
  String get addConsequencePlaceholder;

  /// No description provided for @vulnerabilities.
  ///
  /// In en, this message translates to:
  /// **'Vulnerabilities'**
  String get vulnerabilities;

  /// No description provided for @addVulnerabilityPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add vulnerability...'**
  String get addVulnerabilityPlaceholder;

  /// No description provided for @threats.
  ///
  /// In en, this message translates to:
  /// **'Threats'**
  String get threats;

  /// No description provided for @addThreatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add threat...'**
  String get addThreatPlaceholder;

  /// No description provided for @riskOwner.
  ///
  /// In en, this message translates to:
  /// **'Risk Owner'**
  String get riskOwner;

  /// No description provided for @riskOwnerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., CISO'**
  String get riskOwnerPlaceholder;

  /// No description provided for @ownerRole.
  ///
  /// In en, this message translates to:
  /// **'Owner Role'**
  String get ownerRole;

  /// No description provided for @ownerRolePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Chief Information Security Officer'**
  String get ownerRolePlaceholder;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @departmentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Information Security'**
  String get departmentPlaceholder;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @riskAssessmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Assessment'**
  String get riskAssessmentTitle;

  /// No description provided for @inherentLikelihood.
  ///
  /// In en, this message translates to:
  /// **'Inherent Likelihood'**
  String get inherentLikelihood;

  /// No description provided for @inherentImpact.
  ///
  /// In en, this message translates to:
  /// **'Inherent Impact'**
  String get inherentImpact;

  /// No description provided for @financialImpactUsd.
  ///
  /// In en, this message translates to:
  /// **'Financial Impact (USD)'**
  String get financialImpactUsd;

  /// No description provided for @financialImpactHint.
  ///
  /// In en, this message translates to:
  /// **'Estimated financial loss if risk materializes'**
  String get financialImpactHint;

  /// No description provided for @inherentRiskScore.
  ///
  /// In en, this message translates to:
  /// **'Inherent Risk Score'**
  String get inherentRiskScore;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @valueAtRisk.
  ///
  /// In en, this message translates to:
  /// **'Value at Risk'**
  String get valueAtRisk;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @likelihoodVeryLowPct.
  ///
  /// In en, this message translates to:
  /// **'20% probability'**
  String get likelihoodVeryLowPct;

  /// No description provided for @likelihoodLowPct.
  ///
  /// In en, this message translates to:
  /// **'40% probability'**
  String get likelihoodLowPct;

  /// No description provided for @likelihoodMediumPct.
  ///
  /// In en, this message translates to:
  /// **'60% probability'**
  String get likelihoodMediumPct;

  /// No description provided for @likelihoodHighPct.
  ///
  /// In en, this message translates to:
  /// **'80% probability'**
  String get likelihoodHighPct;

  /// No description provided for @likelihoodVeryHighPct.
  ///
  /// In en, this message translates to:
  /// **'100% probability'**
  String get likelihoodVeryHighPct;

  /// No description provided for @riskTreatmentStrategyTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Treatment Strategy'**
  String get riskTreatmentStrategyTitle;

  /// No description provided for @treatmentStrategyLabel.
  ///
  /// In en, this message translates to:
  /// **'Treatment Strategy'**
  String get treatmentStrategyLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @riskAppetite.
  ///
  /// In en, this message translates to:
  /// **'Risk Appetite'**
  String get riskAppetite;

  /// No description provided for @riskToleranceUsd.
  ///
  /// In en, this message translates to:
  /// **'Risk Tolerance (USD)'**
  String get riskToleranceUsd;

  /// No description provided for @treatmentPlan.
  ///
  /// In en, this message translates to:
  /// **'Treatment Plan'**
  String get treatmentPlan;

  /// No description provided for @treatmentPlanPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe the treatment plan and strategy...'**
  String get treatmentPlanPlaceholder;

  /// No description provided for @statusIdentified.
  ///
  /// In en, this message translates to:
  /// **'Identified'**
  String get statusIdentified;

  /// No description provided for @appetiteCautious.
  ///
  /// In en, this message translates to:
  /// **'Cautious'**
  String get appetiteCautious;

  /// No description provided for @appetiteModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get appetiteModerate;

  /// No description provided for @appetiteAggressive.
  ///
  /// In en, this message translates to:
  /// **'Aggressive'**
  String get appetiteAggressive;

  /// No description provided for @controlEffectivenessTitle.
  ///
  /// In en, this message translates to:
  /// **'Control Effectiveness'**
  String get controlEffectivenessTitle;

  /// No description provided for @overallControlEffectiveness.
  ///
  /// In en, this message translates to:
  /// **'Overall Control Effectiveness (%)'**
  String get overallControlEffectiveness;

  /// No description provided for @residualRiskAfterControls.
  ///
  /// In en, this message translates to:
  /// **'Residual Risk (After Controls)'**
  String get residualRiskAfterControls;

  /// No description provided for @controlsNoteText.
  ///
  /// In en, this message translates to:
  /// **'Note: Link specific controls in the next step to track individual control effectiveness and test results.'**
  String get controlsNoteText;

  /// No description provided for @likelihood.
  ///
  /// In en, this message translates to:
  /// **'Likelihood'**
  String get likelihood;

  /// No description provided for @impact.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get impact;

  /// No description provided for @reduction.
  ///
  /// In en, this message translates to:
  /// **'↓ {pct}% reduction'**
  String reduction(String pct);

  /// No description provided for @mitigationActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mitigation Actions'**
  String get mitigationActionsTitle;

  /// No description provided for @mitigationInfoText.
  ///
  /// In en, this message translates to:
  /// **'After saving, you can add detailed mitigation actions, link controls, and track progress in the risk detail view.'**
  String get mitigationInfoText;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @notesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Additional notes or comments...'**
  String get notesPlaceholder;

  /// No description provided for @riskSummary.
  ///
  /// In en, this message translates to:
  /// **'Risk Summary'**
  String get riskSummary;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get summaryTitle;

  /// No description provided for @inherentRisk.
  ///
  /// In en, this message translates to:
  /// **'Inherent Risk'**
  String get inherentRisk;

  /// No description provided for @residualRisk.
  ///
  /// In en, this message translates to:
  /// **'Residual Risk'**
  String get residualRisk;

  /// No description provided for @summaryTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get summaryTreatment;

  /// No description provided for @summaryOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get summaryOwner;

  /// No description provided for @saveRisk.
  ///
  /// In en, this message translates to:
  /// **'Save Risk'**
  String get saveRisk;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @categoryCyberSecurity.
  ///
  /// In en, this message translates to:
  /// **'Cyber Security'**
  String get categoryCyberSecurity;

  /// No description provided for @categoryDataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get categoryDataSecurity;

  /// No description provided for @categoryOperational.
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get categoryOperational;

  /// No description provided for @categoryCloudSecurity.
  ///
  /// In en, this message translates to:
  /// **'Cloud Security'**
  String get categoryCloudSecurity;

  /// No description provided for @categoryAccessControl.
  ///
  /// In en, this message translates to:
  /// **'Access Control'**
  String get categoryAccessControl;

  /// No description provided for @categoryThirdPartyRisk.
  ///
  /// In en, this message translates to:
  /// **'Third Party Risk'**
  String get categoryThirdPartyRisk;

  /// No description provided for @categoryTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get categoryTechnology;

  /// No description provided for @riskInformation.
  ///
  /// In en, this message translates to:
  /// **'Risk Information'**
  String get riskInformation;

  /// No description provided for @linkedAssetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked Assets'**
  String get linkedAssetsLabel;

  /// No description provided for @inherentRiskVar.
  ///
  /// In en, this message translates to:
  /// **'Inherent Risk (VaR)'**
  String get inherentRiskVar;

  /// No description provided for @controlEffectivenessLabel.
  ///
  /// In en, this message translates to:
  /// **'Control Effectiveness'**
  String get controlEffectivenessLabel;

  /// No description provided for @residualRiskVar.
  ///
  /// In en, this message translates to:
  /// **'Residual Risk (VaR)'**
  String get residualRiskVar;

  /// No description provided for @riskReductionLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Reduction'**
  String get riskReductionLabel;

  /// No description provided for @editRisk.
  ///
  /// In en, this message translates to:
  /// **'Edit Risk'**
  String get editRisk;

  /// No description provided for @riskIdPrefix.
  ///
  /// In en, this message translates to:
  /// **'Risk ID:'**
  String get riskIdPrefix;

  /// No description provided for @likelihoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Likelihood'**
  String get likelihoodLabel;

  /// No description provided for @impactLabel.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get impactLabel;

  /// No description provided for @frameworkAssessmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Framework Assessments'**
  String get frameworkAssessmentsTitle;

  /// No description provided for @frameworkAssessmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and assess compliance across multiple frameworks'**
  String get frameworkAssessmentsSubtitle;

  /// No description provided for @assessmentHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Assessment Hub'**
  String get assessmentHubTitle;

  /// No description provided for @assessmentHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive framework assessments with standardized criteria'**
  String get assessmentHubSubtitle;

  /// No description provided for @assessmentHubDescription.
  ///
  /// In en, this message translates to:
  /// **'Access the question library with 42 questions across 3 frameworks. Conduct assessments with weighted scoring, evidence collection, and real-time compliance tracking.'**
  String get assessmentHubDescription;

  /// No description provided for @launchAssessmentHub.
  ///
  /// In en, this message translates to:
  /// **'Launch Assessment Hub'**
  String get launchAssessmentHub;

  /// No description provided for @hubLibraries.
  ///
  /// In en, this message translates to:
  /// **'Libraries'**
  String get hubLibraries;

  /// No description provided for @hubQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get hubQuestions;

  /// No description provided for @hubCriteria.
  ///
  /// In en, this message translates to:
  /// **'Criteria'**
  String get hubCriteria;

  /// No description provided for @statTotalFrameworks.
  ///
  /// In en, this message translates to:
  /// **'Total Frameworks'**
  String get statTotalFrameworks;

  /// No description provided for @statAvgCompliance.
  ///
  /// In en, this message translates to:
  /// **'Avg Compliance'**
  String get statAvgCompliance;

  /// No description provided for @statTotalControls.
  ///
  /// In en, this message translates to:
  /// **'Total Controls'**
  String get statTotalControls;

  /// No description provided for @statActiveFrameworks.
  ///
  /// In en, this message translates to:
  /// **'Active Frameworks'**
  String get statActiveFrameworks;

  /// No description provided for @complianceLevel.
  ///
  /// In en, this message translates to:
  /// **'Compliance Level'**
  String get complianceLevel;

  /// No description provided for @frameworkStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get frameworkStatusLabel;

  /// No description provided for @frameworkControlsLabel.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get frameworkControlsLabel;

  /// No description provided for @lastAssessmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Assessment'**
  String get lastAssessmentLabel;

  /// No description provided for @frameworkStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get frameworkStatusActive;

  /// No description provided for @frameworkStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get frameworkStatusInProgress;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @complianceScore.
  ///
  /// In en, this message translates to:
  /// **'Compliance Score'**
  String get complianceScore;

  /// No description provided for @compliantControls.
  ///
  /// In en, this message translates to:
  /// **'Compliant Controls'**
  String get compliantControls;

  /// No description provided for @outOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Out of {total} total'**
  String outOfTotal(int total);

  /// No description provided for @partialComplianceLabel.
  ///
  /// In en, this message translates to:
  /// **'Partial Compliance'**
  String get partialComplianceLabel;

  /// No description provided for @needsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs improvement'**
  String get needsImprovement;

  /// No description provided for @nonCompliantLabel.
  ///
  /// In en, this message translates to:
  /// **'Non-Compliant'**
  String get nonCompliantLabel;

  /// No description provided for @immediateActionRequired.
  ///
  /// In en, this message translates to:
  /// **'Immediate action required'**
  String get immediateActionRequired;

  /// No description provided for @complianceShort.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get complianceShort;

  /// No description provided for @compliantCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Compliant'**
  String compliantCount(int count);

  /// No description provided for @partialCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Partial'**
  String partialCount(int count);

  /// No description provided for @nonCompliantCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Non-Compliant'**
  String nonCompliantCount(int count);

  /// No description provided for @remediationActionItems.
  ///
  /// In en, this message translates to:
  /// **'Remediation Action Items'**
  String get remediationActionItems;

  /// No description provided for @openCompletedSummary.
  ///
  /// In en, this message translates to:
  /// **'{open} open items • {completed} completed'**
  String openCompletedSummary(int open, int completed);

  /// No description provided for @addAction.
  ///
  /// In en, this message translates to:
  /// **'Add Action'**
  String get addAction;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String dueDate(String date);

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner: {name}'**
  String ownerName(String name);

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get priorityHigh;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'medium'**
  String get priorityMedium;

  /// No description provided for @remediationStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get remediationStatusOpen;

  /// No description provided for @remediationStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'in-progress'**
  String get remediationStatusInProgress;

  /// No description provided for @answerYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get answerYes;

  /// No description provided for @answerPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get answerPartial;

  /// No description provided for @answerNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get answerNo;

  /// No description provided for @answerNa.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get answerNa;

  /// No description provided for @evidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get evidenceLabel;

  /// No description provided for @addRemediationAction.
  ///
  /// In en, this message translates to:
  /// **'Add Remediation Action'**
  String get addRemediationAction;

  /// No description provided for @relatedSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Related Section'**
  String get relatedSectionLabel;

  /// No description provided for @selectSectionHint.
  ///
  /// In en, this message translates to:
  /// **'Select section'**
  String get selectSectionHint;

  /// No description provided for @actionTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Action Title'**
  String get actionTitleLabel;

  /// No description provided for @actionTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Brief action item title'**
  String get actionTitleHint;

  /// No description provided for @actionDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get actionDescriptionLabel;

  /// No description provided for @actionDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Detailed description of the action needed'**
  String get actionDescriptionHint;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityLabel;

  /// No description provided for @dueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDateLabel;

  /// No description provided for @ownerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerLabel;

  /// No description provided for @ownerHint.
  ///
  /// In en, this message translates to:
  /// **'Responsible person/team'**
  String get ownerHint;

  /// No description provided for @createAction.
  ///
  /// In en, this message translates to:
  /// **'Create Action'**
  String get createAction;

  /// No description provided for @optionHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get optionHigh;

  /// No description provided for @optionMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get optionMedium;

  /// No description provided for @optionLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get optionLow;

  /// No description provided for @optionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get optionOpen;

  /// No description provided for @optionInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get optionInProgress;

  /// No description provided for @optionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get optionCompleted;

  /// No description provided for @hubPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive framework assessments with standardized evaluation criteria'**
  String get hubPageSubtitle;

  /// No description provided for @addAssessment.
  ///
  /// In en, this message translates to:
  /// **'Add Assessment'**
  String get addAssessment;

  /// No description provided for @hubQuestionLibraries.
  ///
  /// In en, this message translates to:
  /// **'Question Libraries'**
  String get hubQuestionLibraries;

  /// No description provided for @hubTotalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get hubTotalQuestions;

  /// No description provided for @hubStandardCriteria.
  ///
  /// In en, this message translates to:
  /// **'Standard Criteria'**
  String get hubStandardCriteria;

  /// No description provided for @hubCustomAssessments.
  ///
  /// In en, this message translates to:
  /// **'Custom Assessments'**
  String get hubCustomAssessments;

  /// No description provided for @hubStandardEvaluationCriteria.
  ///
  /// In en, this message translates to:
  /// **'Standard Evaluation Criteria'**
  String get hubStandardEvaluationCriteria;

  /// No description provided for @hubCriteriaIntro.
  ///
  /// In en, this message translates to:
  /// **'All assessments use these standardized criteria to ensure consistent and objective evaluation across frameworks.'**
  String get hubCriteriaIntro;

  /// No description provided for @hubStandardFrameworkAssessments.
  ///
  /// In en, this message translates to:
  /// **'Standard Framework Assessments'**
  String get hubStandardFrameworkAssessments;

  /// No description provided for @hubAssessmentFeatures.
  ///
  /// In en, this message translates to:
  /// **'Assessment Features'**
  String get hubAssessmentFeatures;

  /// No description provided for @weightValue.
  ///
  /// In en, this message translates to:
  /// **'Weight: {value}%'**
  String weightValue(int value);

  /// No description provided for @soxComplianceAssessment.
  ///
  /// In en, this message translates to:
  /// **'SOX Compliance Assessment'**
  String get soxComplianceAssessment;

  /// No description provided for @soxComplianceDesc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive assessment for Sarbanes-Oxley Act compliance with 14 questions across 3 categories.'**
  String get soxComplianceDesc;

  /// No description provided for @cosoErmAssessment.
  ///
  /// In en, this message translates to:
  /// **'COSO ERM Assessment'**
  String get cosoErmAssessment;

  /// No description provided for @cosoErmDesc.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Risk Management framework assessment with 8 questions across 3 components.'**
  String get cosoErmDesc;

  /// No description provided for @cybersecurityAssessment.
  ///
  /// In en, this message translates to:
  /// **'Cybersecurity Assessment'**
  String get cybersecurityAssessment;

  /// No description provided for @cybersecurityDesc.
  ///
  /// In en, this message translates to:
  /// **'NIST CSF and ISO 27001 aligned assessment with 20 questions across 5 functions.'**
  String get cybersecurityDesc;

  /// No description provided for @hubQuestionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions:'**
  String get hubQuestionsLabel;

  /// No description provided for @hubCategoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories:'**
  String get hubCategoriesLabel;

  /// No description provided for @hubEstTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Est. Time:'**
  String get hubEstTimeLabel;

  /// No description provided for @startAssessment.
  ///
  /// In en, this message translates to:
  /// **'Start Assessment'**
  String get startAssessment;

  /// No description provided for @featureWeightedScoring.
  ///
  /// In en, this message translates to:
  /// **'Weighted Scoring'**
  String get featureWeightedScoring;

  /// No description provided for @featureWeightedScoringDesc.
  ///
  /// In en, this message translates to:
  /// **'Questions and criteria weighted by importance'**
  String get featureWeightedScoringDesc;

  /// No description provided for @featureRealTimeScoring.
  ///
  /// In en, this message translates to:
  /// **'Real-time Scoring'**
  String get featureRealTimeScoring;

  /// No description provided for @featureRealTimeScoringDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatic calculation as you answer'**
  String get featureRealTimeScoringDesc;

  /// No description provided for @featureEvidenceCollection.
  ///
  /// In en, this message translates to:
  /// **'Evidence Collection'**
  String get featureEvidenceCollection;

  /// No description provided for @featureEvidenceCollectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Attach evidence and documentation'**
  String get featureEvidenceCollectionDesc;

  /// No description provided for @featureProgressTracking.
  ///
  /// In en, this message translates to:
  /// **'Progress Tracking'**
  String get featureProgressTracking;

  /// No description provided for @featureProgressTrackingDesc.
  ///
  /// In en, this message translates to:
  /// **'Track completion by category'**
  String get featureProgressTrackingDesc;

  /// No description provided for @qlibSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get qlibSaveDraft;

  /// No description provided for @qlibSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Assessment'**
  String get qlibSubmit;

  /// No description provided for @qlibQuestionsAnswered.
  ///
  /// In en, this message translates to:
  /// **'Questions Answered'**
  String get qlibQuestionsAnswered;

  /// No description provided for @qlibOverallScore.
  ///
  /// In en, this message translates to:
  /// **'Overall Score'**
  String get qlibOverallScore;

  /// No description provided for @qlibNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get qlibNeedsImprovement;

  /// No description provided for @qlibEvidenceAttached.
  ///
  /// In en, this message translates to:
  /// **'Evidence Attached'**
  String get qlibEvidenceAttached;

  /// No description provided for @qlibFindings.
  ///
  /// In en, this message translates to:
  /// **'Findings'**
  String get qlibFindings;

  /// No description provided for @qlibCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get qlibCategories;

  /// No description provided for @qlibCategoryProgress.
  ///
  /// In en, this message translates to:
  /// **'Category Progress'**
  String get qlibCategoryProgress;

  /// No description provided for @qlibAnswered.
  ///
  /// In en, this message translates to:
  /// **'{answered}/{total} answered'**
  String qlibAnswered(int answered, int total);

  /// No description provided for @qlibResponse.
  ///
  /// In en, this message translates to:
  /// **'Response'**
  String get qlibResponse;

  /// No description provided for @qlibQuestionWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight: {value}'**
  String qlibQuestionWeight(int value);

  /// No description provided for @qlibNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get qlibNotesOptional;

  /// No description provided for @qlibEvidencePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Provide evidence or reference documentation...'**
  String get qlibEvidencePlaceholder;

  /// No description provided for @qlibNotesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Additional notes or context...'**
  String get qlibNotesPlaceholder;

  /// No description provided for @qlibPreviousCategory.
  ///
  /// In en, this message translates to:
  /// **'Previous Category'**
  String get qlibPreviousCategory;

  /// No description provided for @qlibNextCategory.
  ///
  /// In en, this message translates to:
  /// **'Next Category'**
  String get qlibNextCategory;

  /// No description provided for @qlibCategoryOf.
  ///
  /// In en, this message translates to:
  /// **'Category {current} of {total}'**
  String qlibCategoryOf(int current, int total);

  /// No description provided for @qlibAnsweredBadge.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get qlibAnsweredBadge;

  /// No description provided for @qlibScore.
  ///
  /// In en, this message translates to:
  /// **'Score: {value}%'**
  String qlibScore(int value);

  /// No description provided for @qlibSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Select an option...'**
  String get qlibSelectOption;

  /// No description provided for @caTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Assessment'**
  String get caTitle;

  /// No description provided for @caNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Assessment Name'**
  String get caNameLabel;

  /// No description provided for @caNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Custom Security Assessment'**
  String get caNameHint;

  /// No description provided for @caDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get caDescriptionLabel;

  /// No description provided for @caDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Brief description of the assessment'**
  String get caDescriptionHint;

  /// No description provided for @caSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get caSelectCategory;

  /// No description provided for @caColorThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get caColorThemeLabel;

  /// No description provided for @caQuestionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get caQuestionsLabel;

  /// No description provided for @caEstTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Est. Time'**
  String get caEstTimeLabel;

  /// No description provided for @caEstTimeHint.
  ///
  /// In en, this message translates to:
  /// **'30-45 min'**
  String get caEstTimeHint;

  /// No description provided for @createAssessment.
  ///
  /// In en, this message translates to:
  /// **'Create Assessment'**
  String get createAssessment;

  /// No description provided for @caCatCompliance.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get caCatCompliance;

  /// No description provided for @caCatSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get caCatSecurity;

  /// No description provided for @caCatPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get caCatPrivacy;

  /// No description provided for @caCatOperational.
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get caCatOperational;

  /// No description provided for @caCatFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get caCatFinancial;

  /// No description provided for @themeBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get themeBlue;

  /// No description provided for @themeGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get themeGreen;

  /// No description provided for @themePurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get themePurple;

  /// No description provided for @themeOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get themeOrange;

  /// No description provided for @themeRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get themeRed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
