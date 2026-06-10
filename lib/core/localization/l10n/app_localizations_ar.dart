// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'نظام الحوكمة';

  @override
  String get authTitle => 'تسجيل الدخول';

  @override
  String get loadUser => 'تحميل المستخدم';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get errorGeneric => 'حدث خطأ ما';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String userGreeting(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get noUserYet => 'لم يتم تحميل مستخدم بعد';

  @override
  String userId(String id) {
    return 'المعرّف: $id';
  }

  @override
  String get toggleLanguage => 'اللغة';

  @override
  String get toggleTheme => 'المظهر';

  @override
  String get dashboardTitle => 'لوحة التحكم';

  @override
  String get dashboardSubtitle => 'نظرة عامة على النظام والتحكم بالوقت الفعلي';

  @override
  String get totalUsers => 'إجمالي المستخدمين';

  @override
  String get revenue => 'الإيرادات';

  @override
  String get activeProjects => 'المشاريع النشطة';

  @override
  String get systemHealth => 'صحة النظام';

  @override
  String get recentActivities => 'الأنشطة الأخيرة';

  @override
  String get quickActions => 'الإجراءات السريعة';

  @override
  String get analyticsOverview => 'نظرة عامة على التحليلات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get searchPlaceholder => 'البحث في لوحة التحكم...';

  @override
  String get headerTitle => 'منصة الحوكمة وإدارة المخاطر والامتثال';

  @override
  String get headerSubtitle => 'الأمن السيبراني والحوكمة وإدارة الأمن';

  @override
  String get userName => 'جون سميث';

  @override
  String get userRole => 'مدير الحوكمة';

  @override
  String get navDashboard => 'لوحة التحكم';

  @override
  String get navLibrary => 'المكتبة';

  @override
  String get navAssets => 'الأصول';

  @override
  String get navRisks => 'المخاطر';

  @override
  String get navAssessments => 'التقييمات';

  @override
  String get navControls => 'الضوابط';

  @override
  String get navTprm => 'إدارة مخاطر الأطراف';

  @override
  String get navPrograms => 'البرامج';

  @override
  String get navReviewProgress => 'مراجعة التقدم';

  @override
  String get navRoles => 'الأدوار';

  @override
  String get statTotalRiskExposure => 'إجمالي التعرّض للمخاطر';

  @override
  String get statCriticalRisks => 'المخاطر الحرجة';

  @override
  String get statControlEffectiveness => 'متوسط فعالية الضوابط';

  @override
  String get statVendorRiskScore => 'مؤشر مخاطر المورّد';

  @override
  String get riskExposureTrend => 'اتجاه التعرّض للمخاطر';

  @override
  String get riskExposureLabel => 'التعرّض للمخاطر';

  @override
  String get riskByCategory => 'المخاطر حسب الفئة';

  @override
  String get topRiskAssetsTitle =>
      'أهم الأصول عالية المخاطر (حسب التعرض المالي)';

  @override
  String get viewAll => 'عرض الكل →';

  @override
  String get tableRiskId => 'معرّف الخطر';

  @override
  String get tableAsset => 'الأصل';

  @override
  String get tableImpactVar => 'الأثر (VaR)';

  @override
  String get tableLikelihood => 'الاحتمالية';

  @override
  String get tableStatus => 'الحالة';

  @override
  String get likelihoodHigh => 'عالية';

  @override
  String get likelihoodMedium => 'متوسطة';

  @override
  String get likelihoodLow => 'منخفضة';

  @override
  String get statusCritical => 'حرج';

  @override
  String get statusHigh => 'عالية';

  @override
  String get statusMedium => 'متوسطة';

  @override
  String get summaryCloudWorkloads => 'أحمال السحابة';

  @override
  String get summaryAcrossProviders => 'عبر 4 مزودين';

  @override
  String get summaryActiveControls => 'الضوابط النشطة';

  @override
  String get summaryEffectivePercent => 'فعّالة بنسبة 87%';

  @override
  String get summarySecurityEvents => 'الأحداث الأمنية';

  @override
  String get summaryLast30Days => 'آخر 30 يومًا';

  @override
  String get libraryTitle => 'مكتبة الأسئلة';

  @override
  String get librarySubtitle => 'معايير التقييم القياسية وأسئلة التقييم';

  @override
  String get manageQuestions => 'إدارة الأسئلة';

  @override
  String get manageCategories => 'إدارة الفئات';

  @override
  String get exitEditMode => 'الخروج من وضع التحرير';

  @override
  String get addQuestion => 'إضافة سؤال';

  @override
  String get exportLibrary => 'تصدير المكتبة';

  @override
  String get editModeActive => 'وضع التحرير نشط';

  @override
  String get editModeDescription =>
      'يمكنك الآن إضافة أو تعديل أو حذف الأسئلة في هذه المكتبة. يتم حفظ التغييرات محليًا في جلستك.';

  @override
  String get manageCategoriesAndWeights => 'إدارة الفئات والأوزان';

  @override
  String get addNewQuestionsToCategories => 'إضافة أسئلة جديدة إلى الفئات';

  @override
  String get editExistingQuestions => 'تعديل الأسئلة الحالية';

  @override
  String get deleteQuestions => 'حذف الأسئلة';

  @override
  String get selectFramework => 'اختر الإطار';

  @override
  String get questionsLower => 'سؤال';

  @override
  String get allCategories => 'جميع الفئات';

  @override
  String get searchQuestionsPlaceholder => 'ابحث في الأسئلة أو الوسوم...';

  @override
  String get totalQuestions => 'إجمالي الأسئلة';

  @override
  String get categories => 'الفئات';

  @override
  String get requireEvidence => 'يتطلب أدلة';

  @override
  String get libraryVersion => 'إصدار المكتبة';

  @override
  String get evidenceRequired => 'يتطلب أدلة';

  @override
  String get evaluationCriteria => 'معايير التقييم:';

  @override
  String get relatedControls => 'الضوابط ذات الصلة:';

  @override
  String get showGuidance => 'عرض الإرشادات';

  @override
  String manageCategoriesSubtitle(String libraryId, int count) {
    return '$libraryId - $count فئات';
  }

  @override
  String get totalCategoryWeight => 'إجمالي وزن الفئات';

  @override
  String get categoryWeightHint =>
      'يجب أن يصل مجموع أوزان الفئات إلى 100% للحصول على scoring دقيق';

  @override
  String get addNewCategory => 'إضافة فئة جديدة';

  @override
  String get newCategory => 'فئة جديدة';

  @override
  String get categoryId => 'معرف الفئة';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get categoryDescription => 'الوصف';

  @override
  String get weightPercent => 'الوزن (%)';

  @override
  String get categoryWeightContributionHint =>
      'يحدد هذا مساهمة الفئة في النتيجة الإجمالية';

  @override
  String get saveCategory => 'حفظ الفئة';

  @override
  String get categoryIdPlaceholder => 'مثال: sox-404';

  @override
  String get categoryNamePlaceholder => 'مثال: القسم 404 - تقييم الإدارة';

  @override
  String get categoryDescriptionPlaceholder => 'وصف موجز لهذه الفئة...';

  @override
  String get saveAllChanges => 'حفظ جميع التغييرات';

  @override
  String get cancel => 'إلغاء';

  @override
  String categoriesFooterSummary(int count, int weight) {
    return '$count فئات • إجمالي الوزن: $weight%';
  }

  @override
  String get editQuestion => 'تعديل السؤال';

  @override
  String get basicInformation => 'المعلومات الأساسية';

  @override
  String get questionId => 'معرف السؤال';

  @override
  String get questionIdHint => 'لا يمكن تغيير معرف السؤال';

  @override
  String get questionText => 'نص السؤال';

  @override
  String get descriptionOptional => 'الوصف (اختياري)';

  @override
  String get questionType => 'نوع السؤال';

  @override
  String get weightRange => 'الوزن (1-10)';

  @override
  String get category => 'الفئة';

  @override
  String get subcategoryOptional => 'الفئة الفرعية (اختياري)';

  @override
  String get evaluationCriteriaHint => 'حدد المعايير المنطبقة على هذا السؤال';

  @override
  String get criteriaDocumentation => 'التوثيق';

  @override
  String get criteriaDocumentationDesc => 'اكتمال السياسات والإجراءات والوثائق';

  @override
  String get criteriaImplementation => 'التنفيذ';

  @override
  String get criteriaImplementationDesc => 'الضوابط والعمليات تعمل بالكامل';

  @override
  String get criteriaEffectiveness => 'الفعالية';

  @override
  String get criteriaEffectivenessDesc => 'الضوابط تحقق أهدافها المقصودة';

  @override
  String get criteriaMonitoring => 'المراقبة';

  @override
  String get criteriaMonitoringDesc => 'آليات المراقبة والقياس المنتظمة';

  @override
  String get criteriaContinuousImprovement => 'التحسين المستمر';

  @override
  String get criteriaContinuousImprovementDesc =>
      'عملية التحسين والدروس المستفادة';

  @override
  String criteriaWeightLabel(int percent) {
    return 'الوزن: $percent%';
  }

  @override
  String get tags => 'الوسوم';

  @override
  String get addTagPlaceholder => 'أضف وسماً...';

  @override
  String get relatedControlsOptional => 'الضوابط ذات الصلة (اختياري)';

  @override
  String get addControlPlaceholder => 'إضافة معرف ضابط...';

  @override
  String get additionalSettings => 'إعدادات إضافية';

  @override
  String get requireEvidenceDescription =>
      'يجب على المُجيبين تقديم أدلة أو وثائق لهذا السؤال';

  @override
  String get guidanceNotesOptional => 'ملاحظات إرشادية (اختياري)';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get questionTypeYesNo => 'نعم / لا';

  @override
  String get addNewQuestion => 'إضافة سؤال جديد';

  @override
  String get questionIdPlaceholder => 'مثال: sox-404-001';

  @override
  String get questionTextPlaceholder => 'أدخل نص السؤال...';

  @override
  String get descriptionPlaceholder => 'سياق أو شرح إضافي...';

  @override
  String get categoryPlaceholder => 'مثال: تقييم الإدارة';

  @override
  String get subcategoryPlaceholder => 'مثال: إطار الضوابط';

  @override
  String get guidanceNotesPlaceholder =>
      'قدّم إرشادات للمقيّمين حول كيفية الإجابة على هذا السؤال...';

  @override
  String get assetRegistryTitle => 'سجل الأصول';

  @override
  String get assetRegistrySubtitle => 'إدارة ومراقبة أصول المؤسسة';

  @override
  String get addAsset => 'إضافة أصل';

  @override
  String get statTotalAssets => 'إجمالي الأصول';

  @override
  String get statApplications => 'التطبيقات';

  @override
  String get statCloud => 'السحابة';

  @override
  String get statData => 'البيانات';

  @override
  String get statTotalValue => 'القيمة الإجمالية';

  @override
  String get searchAssetsPlaceholder => 'البحث عن الأصول بالاسم أو المعرف...';

  @override
  String get allTypes => 'جميع الأنواع';

  @override
  String get moreFilters => 'المزيد من الفلاتر';

  @override
  String get export => 'تصدير';

  @override
  String get tableAssetId => 'معرف الأصل';

  @override
  String get tableName => 'الاسم';

  @override
  String get tableType => 'النوع';

  @override
  String get tableBusinessValue => 'القيمة التجارية';

  @override
  String get tableOwner => 'المالك';

  @override
  String get tableEnvironment => 'البيئة';

  @override
  String get tableCloudProvider => 'مزود السحابة';

  @override
  String get tableRiskLevel => 'مستوى المخاطر';

  @override
  String get tableClassification => 'التصنيف';

  @override
  String get tableActions => 'الإجراءات';

  @override
  String get assetTypeData => 'بيانات';

  @override
  String get assetTypeApplication => 'تطبيق';

  @override
  String get assetTypeInfrastructure => 'بنية تحتية';

  @override
  String get assetTypeCloud => 'سحابة';

  @override
  String get classificationConfidential => 'سري';

  @override
  String get classificationInternal => 'داخلي';

  @override
  String get addNewAsset => 'إضافة أصل جديد';

  @override
  String get assetName => 'اسم الأصل';

  @override
  String get assetType => 'نوع الأصل';

  @override
  String get assetDescription => 'الوصف';

  @override
  String get businessValue => 'القيمة التجارية (\$)';

  @override
  String get assetOwner => 'المالك';

  @override
  String get location => 'الموقع';

  @override
  String get ipAddressEndpoint => 'عنوان IP / نقطة النهاية';

  @override
  String get criticality => 'الأهمية';

  @override
  String get complianceRequirements => 'متطلبات الامتثال';

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
  String get assetTags => 'الوسوم';

  @override
  String get enterAssetName => 'أدخل اسم الأصل';

  @override
  String get assetDescriptionPlaceholder => 'صف الأصل والغرض منه';

  @override
  String get assetOwnerPlaceholder => 'اسم المالك أو الفريق';

  @override
  String get locationPlaceholder => 'مثال: us-east-1، أوروبا، مركز البيانات A';

  @override
  String get ipAddressPlaceholder => 'عنوان IP أو URL';

  @override
  String get assetTagsPlaceholder =>
      'افصل الوسوم بفواصل (مثال: critical, customer-facing, pii)';

  @override
  String get envProduction => 'الإنتاج';

  @override
  String get envStaging => 'التجهيز';

  @override
  String get envDevelopment => 'التطوير';

  @override
  String get envOnPrem => 'محلي';

  @override
  String get providerAws => 'AWS';

  @override
  String get providerAzure => 'Azure';

  @override
  String get providerGcp => 'GCP';

  @override
  String get securityInformation => 'معلومات الأمان';

  @override
  String get infrastructure => 'البنية التحتية';

  @override
  String get relatedItems => 'العناصر ذات الصلة';

  @override
  String get linkedRisks => 'المخاطر المرتبطة';

  @override
  String get appliedControls => 'الضوابط المطبقة';

  @override
  String get editAsset => 'تعديل الأصل';

  @override
  String get viewRisks => 'عرض المخاطر';

  @override
  String get viewControls => 'عرض الضوابط';

  @override
  String get deleteAsset => 'حذف الأصل';

  @override
  String get riskRegistryTitle => 'سجل المخاطر';

  @override
  String get riskRegistrySubtitle => 'إدارة شاملة للمخاطر مع تقييم كمي';

  @override
  String get addRisk => 'إضافة مخاطرة';

  @override
  String get statInherentRisk => 'المخاطر الكامنة (VaR)';

  @override
  String get statResidualRisk => 'المخاطر المتبقية (VaR)';

  @override
  String get statRiskReduction => 'تخفيض المخاطر';

  @override
  String get riskHeatMapTitle => 'خريطة حرارة المخاطر (الاحتمالية × الأثر)';

  @override
  String get heatMapLikelihoodHeader => 'الاحتمالية';

  @override
  String get heatMapColLow => 'منخفض (1-4)';

  @override
  String get heatMapColMedium => 'متوسط (5-9)';

  @override
  String get heatMapColHigh => 'مرتفع (10-14)';

  @override
  String get heatMapColCritical => 'حرج (15-25)';

  @override
  String get heatMapRowVeryHigh => 'مرتفع جداً (5)';

  @override
  String get heatMapRowHigh => 'مرتفع (4)';

  @override
  String get heatMapRowMedium => 'متوسط (3)';

  @override
  String get heatMapRowLow => 'منخفض (2)';

  @override
  String get heatMapRowVeryLow => 'منخفض جداً (1)';

  @override
  String get searchRisksPlaceholder => 'ابحث عن المخاطر بالعنوان أو المعرف...';

  @override
  String get allStatuses => 'جميع الحالات';

  @override
  String get tableRiskTitle => 'العنوان';

  @override
  String get tableRiskAssets => 'الأصول';

  @override
  String get tableRiskCategory => 'الفئة';

  @override
  String get tableImpactDollar => 'الأثر (\$)';

  @override
  String get tableInherent => 'كامن';

  @override
  String get tableResidual => 'متبقي';

  @override
  String get tableTreatment => 'المعالجة';

  @override
  String get statusAssessed => 'مُقيَّم';

  @override
  String get statusTreated => 'مُعالَج';

  @override
  String get statusMonitored => 'مُراقَب';

  @override
  String get likelihoodVeryHigh => 'مرتفع جداً';

  @override
  String get likelihoodVeryLow => 'منخفض جداً';

  @override
  String get treatmentMitigate => 'تخفيف';

  @override
  String get treatmentTransfer => 'نقل';

  @override
  String get treatmentAccept => 'قبول';

  @override
  String get treatmentAvoid => 'تجنب';

  @override
  String get riskManagementIntegration => 'تكامل إدارة المخاطر';

  @override
  String get integrationLinkedToAssets => 'مرتبط بالأصول';

  @override
  String get integrationLinkedToAssetsDesc => 'ربط المخاطر بمخزون الأصول';

  @override
  String get integrationControlMapping => 'رسم خرائط الضوابط';

  @override
  String get integrationControlMappingDesc =>
      'رسم خرائط الضوابط لتقليل المخاطر';

  @override
  String get integrationAssessmentFramework => 'إطار التقييم';

  @override
  String get integrationAssessmentFrameworkDesc =>
      'استخدام مكتبة الأسئلة للتقييمات';

  @override
  String get integrationMitigationPrograms => 'برامج التخفيف';

  @override
  String get integrationMitigationProgramsDesc => 'تتبع إجراءات المعالجة';

  @override
  String get addNewRisk => 'إضافة مخاطرة جديدة';

  @override
  String get stepIdentification => 'التحديد';

  @override
  String get stepAssessment => 'التقييم';

  @override
  String get stepTreatment => 'المعالجة';

  @override
  String get stepControls => 'الضوابط';

  @override
  String get stepMitigation => 'التخفيف';

  @override
  String get riskIdentificationTitle => 'تحديد المخاطرة';

  @override
  String get riskTitleLabel => 'عنوان المخاطرة';

  @override
  String get riskTitlePlaceholder =>
      'مثال: اختراق البيانات - قاعدة بيانات العملاء';

  @override
  String get riskDescriptionPlaceholder => 'وصف تفصيلي للمخاطرة...';

  @override
  String get riskSubcategoryLabel => 'الفئة الفرعية';

  @override
  String get riskSubcategoryPlaceholder => 'فئة فرعية اختيارية';

  @override
  String get affectedAssets => 'الأصول المتأثرة';

  @override
  String get holdCtrlToSelectMultiple => 'اضغط Ctrl/Cmd لتحديد عناصر متعددة';

  @override
  String get rootCause => 'السبب الجذري';

  @override
  String get rootCausePlaceholder => 'ما هو السبب الجذري لهذه المخاطرة؟';

  @override
  String get consequences => 'العواقب';

  @override
  String get addConsequencePlaceholder => 'أضف عاقبة...';

  @override
  String get vulnerabilities => 'الثغرات';

  @override
  String get addVulnerabilityPlaceholder => 'أضف ثغرة...';

  @override
  String get threats => 'التهديدات';

  @override
  String get addThreatPlaceholder => 'أضف تهديداً...';

  @override
  String get riskOwner => 'مالك المخاطرة';

  @override
  String get riskOwnerPlaceholder => 'مثال: CISO';

  @override
  String get ownerRole => 'دور المالك';

  @override
  String get ownerRolePlaceholder => 'مثال: مسؤول أمن المعلومات الرئيسي';

  @override
  String get department => 'القسم';

  @override
  String get departmentPlaceholder => 'مثال: أمن المعلومات';

  @override
  String get next => 'التالي';

  @override
  String get riskAssessmentTitle => 'تقييم المخاطر';

  @override
  String get inherentLikelihood => 'الاحتمالية الكامنة';

  @override
  String get inherentImpact => 'التأثير الكامن';

  @override
  String get financialImpactUsd => 'التأثير المالي (دولار)';

  @override
  String get financialImpactHint => 'الخسارة المالية المقدرة إذا تحقق الخطر';

  @override
  String get inherentRiskScore => 'درجة المخاطرة الكامنة';

  @override
  String get score => 'الدرجة';

  @override
  String get rating => 'التصنيف';

  @override
  String get valueAtRisk => 'القيمة المعرضة للخطر';

  @override
  String get previous => 'السابق';

  @override
  String get likelihoodVeryLowPct => 'احتمالية 20%';

  @override
  String get likelihoodLowPct => 'احتمالية 40%';

  @override
  String get likelihoodMediumPct => 'احتمالية 60%';

  @override
  String get likelihoodHighPct => 'احتمالية 80%';

  @override
  String get likelihoodVeryHighPct => 'احتمالية 100%';

  @override
  String get riskTreatmentStrategyTitle => 'استراتيجية معالجة المخاطر';

  @override
  String get treatmentStrategyLabel => 'استراتيجية المعالجة';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get riskAppetite => 'شهية المخاطر';

  @override
  String get riskToleranceUsd => 'تحمل المخاطر (دولار)';

  @override
  String get treatmentPlan => 'خطة المعالجة';

  @override
  String get treatmentPlanPlaceholder => 'وصف خطة واستراتيجية المعالجة...';

  @override
  String get statusIdentified => 'محدد';

  @override
  String get appetiteCautious => 'حذر';

  @override
  String get appetiteModerate => 'معتدل';

  @override
  String get appetiteAggressive => 'عدواني';

  @override
  String get controlEffectivenessTitle => 'فعالية الضوابط';

  @override
  String get overallControlEffectiveness => 'فعالية الضوابط الإجمالية (%)';

  @override
  String get residualRiskAfterControls => 'المخاطر المتبقية (بعد الضوابط)';

  @override
  String get controlsNoteText =>
      'ملاحظة: اربط الضوابط المحددة في الخطوة التالية لتتبع فعالية الضوابط الفردية ونتائج الاختبار.';

  @override
  String get likelihood => 'الاحتمالية';

  @override
  String get impact => 'التأثير';

  @override
  String reduction(String pct) {
    return '↓ $pct% تخفيض';
  }

  @override
  String get mitigationActionsTitle => 'إجراءات التخفيف';

  @override
  String get mitigationInfoText =>
      'بعد الحفظ، يمكنك إضافة إجراءات تخفيف مفصلة وربط الضوابط وتتبع التقدم في عرض تفاصيل المخاطر.';

  @override
  String get notesLabel => 'ملاحظات';

  @override
  String get notesPlaceholder => 'ملاحظات أو تعليقات إضافية...';

  @override
  String get riskSummary => 'ملخص المخاطرة';

  @override
  String get summaryTitle => 'العنوان';

  @override
  String get inherentRisk => 'المخاطرة الكامنة';

  @override
  String get residualRisk => 'المخاطرة المتبقية';

  @override
  String get summaryTreatment => 'المعالجة';

  @override
  String get summaryOwner => 'المالك';

  @override
  String get saveRisk => 'حفظ المخاطرة';

  @override
  String get notSet => 'غير محدد';

  @override
  String get categoryCyberSecurity => 'أمن المعلومات';

  @override
  String get categoryDataSecurity => 'أمن البيانات';

  @override
  String get categoryOperational => 'تشغيلي';

  @override
  String get categoryCloudSecurity => 'أمن السحابة';

  @override
  String get categoryAccessControl => 'التحكم في الوصول';

  @override
  String get categoryThirdPartyRisk => 'مخاطر الطرف الثالث';

  @override
  String get categoryTechnology => 'التكنولوجيا';

  @override
  String get riskInformation => 'معلومات المخاطرة';

  @override
  String get linkedAssetsLabel => 'الأصول المرتبطة';

  @override
  String get inherentRiskVar => 'المخاطرة الكامنة (VaR)';

  @override
  String get controlEffectivenessLabel => 'فعالية الضوابط';

  @override
  String get residualRiskVar => 'المخاطرة المتبقية (VaR)';

  @override
  String get riskReductionLabel => 'تخفيض المخاطرة';

  @override
  String get editRisk => 'تعديل المخاطرة';

  @override
  String get riskIdPrefix => 'رقم المخاطرة:';

  @override
  String get likelihoodLabel => 'الاحتمالية';

  @override
  String get impactLabel => 'التأثير';

  @override
  String get frameworkAssessmentsTitle => 'تقييمات الأطر';

  @override
  String get frameworkAssessmentsSubtitle =>
      'إدارة وتقييم الامتثال عبر أطر متعددة';

  @override
  String get assessmentHubTitle => 'مركز التقييم';

  @override
  String get assessmentHubSubtitle => 'تقييمات شاملة للأطر بمعايير موحدة';

  @override
  String get assessmentHubDescription =>
      'الوصول إلى مكتبة الأسئلة التي تضم 42 سؤالاً عبر 3 أطر. إجراء التقييمات باستخدام التقييم الموزون وجمع الأدلة وتتبع الامتثال في الوقت الفعلي.';

  @override
  String get launchAssessmentHub => 'تشغيل مركز التقييم';

  @override
  String get hubLibraries => 'المكتبات';

  @override
  String get hubQuestions => 'الأسئلة';

  @override
  String get hubCriteria => 'المعايير';

  @override
  String get statTotalFrameworks => 'إجمالي الأطر';

  @override
  String get statAvgCompliance => 'متوسط الامتثال';

  @override
  String get statTotalControls => 'إجمالي الضوابط';

  @override
  String get statActiveFrameworks => 'الأطر النشطة';

  @override
  String get complianceLevel => 'مستوى الامتثال';

  @override
  String get frameworkStatusLabel => 'الحالة';

  @override
  String get frameworkControlsLabel => 'الضوابط';

  @override
  String get lastAssessmentLabel => 'آخر تقييم';

  @override
  String get frameworkStatusActive => 'نشط';

  @override
  String get frameworkStatusInProgress => 'قيد التنفيذ';

  @override
  String get exportReport => 'تصدير التقرير';

  @override
  String get complianceScore => 'درجة الامتثال';

  @override
  String get compliantControls => 'الضوابط الممتثلة';

  @override
  String outOfTotal(int total) {
    return 'من أصل $total';
  }

  @override
  String get partialComplianceLabel => 'امتثال جزئي';

  @override
  String get needsImprovement => 'بحاجة إلى تحسين';

  @override
  String get nonCompliantLabel => 'غير ممتثل';

  @override
  String get immediateActionRequired => 'يتطلب إجراءً فورياً';

  @override
  String get complianceShort => 'الامتثال';

  @override
  String compliantCount(int count) {
    return '$count ممتثل';
  }

  @override
  String partialCount(int count) {
    return '$count جزئي';
  }

  @override
  String nonCompliantCount(int count) {
    return '$count غير ممتثل';
  }

  @override
  String get remediationActionItems => 'إجراءات المعالجة';

  @override
  String openCompletedSummary(int open, int completed) {
    return '$open عناصر مفتوحة • $completed مكتملة';
  }

  @override
  String get addAction => 'إضافة إجراء';

  @override
  String dueDate(String date) {
    return 'الاستحقاق: $date';
  }

  @override
  String ownerName(String name) {
    return 'المالك: $name';
  }

  @override
  String get priorityHigh => 'عالية';

  @override
  String get priorityMedium => 'متوسطة';

  @override
  String get remediationStatusOpen => 'مفتوح';

  @override
  String get remediationStatusInProgress => 'قيد التنفيذ';

  @override
  String get answerYes => 'نعم';

  @override
  String get answerPartial => 'جزئي';

  @override
  String get answerNo => 'لا';

  @override
  String get answerNa => 'غير منطبق';

  @override
  String get evidenceLabel => 'الدليل';

  @override
  String get addRemediationAction => 'إضافة إجراء معالجة';

  @override
  String get relatedSectionLabel => 'القسم المرتبط';

  @override
  String get selectSectionHint => 'اختر القسم';

  @override
  String get actionTitleLabel => 'عنوان الإجراء';

  @override
  String get actionTitleHint => 'عنوان مختصر لعنصر الإجراء';

  @override
  String get actionDescriptionLabel => 'الوصف';

  @override
  String get actionDescriptionHint => 'وصف تفصيلي للإجراء المطلوب';

  @override
  String get priorityLabel => 'الأولوية';

  @override
  String get dueDateLabel => 'تاريخ الاستحقاق';

  @override
  String get ownerLabel => 'المسؤول';

  @override
  String get ownerHint => 'الشخص/الفريق المسؤول';

  @override
  String get createAction => 'إنشاء إجراء';

  @override
  String get optionHigh => 'عالية';

  @override
  String get optionMedium => 'متوسطة';

  @override
  String get optionLow => 'منخفضة';

  @override
  String get optionOpen => 'مفتوح';

  @override
  String get optionInProgress => 'قيد التنفيذ';

  @override
  String get optionCompleted => 'مكتمل';

  @override
  String get hubPageSubtitle => 'تقييمات شاملة للأطر مع معايير تقييم موحدة';

  @override
  String get addAssessment => 'إضافة تقييم';

  @override
  String get hubQuestionLibraries => 'مكتبات الأسئلة';

  @override
  String get hubTotalQuestions => 'إجمالي الأسئلة';

  @override
  String get hubStandardCriteria => 'المعايير القياسية';

  @override
  String get hubCustomAssessments => 'التقييمات المخصصة';

  @override
  String get hubStandardEvaluationCriteria => 'معايير التقييم القياسية';

  @override
  String get hubCriteriaIntro =>
      'تستخدم جميع التقييمات هذه المعايير الموحدة لضمان تقييم متسق وموضوعي عبر الأطر.';

  @override
  String get hubStandardFrameworkAssessments => 'تقييمات الأطر القياسية';

  @override
  String get hubAssessmentFeatures => 'ميزات التقييم';

  @override
  String weightValue(int value) {
    return 'الوزن: $value%';
  }

  @override
  String get soxComplianceAssessment => 'تقييم الامتثال SOX';

  @override
  String get soxComplianceDesc =>
      'تقييم شامل للامتثال لقانون ساربينز-أوكسلي مع 14 سؤالاً عبر 3 فئات.';

  @override
  String get cosoErmAssessment => 'تقييم COSO ERM';

  @override
  String get cosoErmDesc =>
      'تقييم إطار إدارة مخاطر المؤسسة مع 8 أسئلة عبر 3 مكونات.';

  @override
  String get cybersecurityAssessment => 'تقييم الأمن السيبراني';

  @override
  String get cybersecurityDesc =>
      'تقييم متوافق مع NIST CSF وISO 27001 مع 20 سؤالاً عبر 5 وظائف.';

  @override
  String get hubQuestionsLabel => 'الأسئلة:';

  @override
  String get hubCategoriesLabel => 'الفئات:';

  @override
  String get hubEstTimeLabel => 'الوقت المقدر:';

  @override
  String get startAssessment => 'بدء التقييم';

  @override
  String get featureWeightedScoring => 'التقييم المرجح';

  @override
  String get featureWeightedScoringDesc =>
      'الأسئلة والمعايير مرجحة حسب الأهمية';

  @override
  String get featureRealTimeScoring => 'التقييم الفوري';

  @override
  String get featureRealTimeScoringDesc => 'حساب تلقائي أثناء الإجابة';

  @override
  String get featureEvidenceCollection => 'جمع الأدلة';

  @override
  String get featureEvidenceCollectionDesc => 'إرفاق الأدلة والوثائق';

  @override
  String get featureProgressTracking => 'تتبع التقدم';

  @override
  String get featureProgressTrackingDesc => 'تتبع الإنجاز حسب الفئة';

  @override
  String get qlibSaveDraft => 'حفظ المسودة';

  @override
  String get qlibSubmit => 'إرسال التقييم';

  @override
  String get qlibQuestionsAnswered => 'الأسئلة المجابة';

  @override
  String get qlibOverallScore => 'النتيجة الإجمالية';

  @override
  String get qlibNeedsImprovement => 'يحتاج إلى تحسين';

  @override
  String get qlibEvidenceAttached => 'الأدلة المرفقة';

  @override
  String get qlibFindings => 'النتائج';

  @override
  String get qlibCategories => 'الفئات';

  @override
  String get qlibCategoryProgress => 'تقدم الفئات';

  @override
  String qlibAnswered(int answered, int total) {
    return '$answered/$total مجابة';
  }

  @override
  String get qlibResponse => 'الإجابة';

  @override
  String qlibQuestionWeight(int value) {
    return 'الوزن: $value';
  }

  @override
  String get qlibNotesOptional => 'ملاحظات (اختياري)';

  @override
  String get qlibEvidencePlaceholder => 'قدّم دليلاً أو وثيقة مرجعية...';

  @override
  String get qlibNotesPlaceholder => 'ملاحظات أو سياق إضافي...';

  @override
  String get qlibPreviousCategory => 'الفئة السابقة';

  @override
  String get qlibNextCategory => 'الفئة التالية';

  @override
  String qlibCategoryOf(int current, int total) {
    return 'الفئة $current من $total';
  }

  @override
  String get qlibAnsweredBadge => 'تمت الإجابة';

  @override
  String qlibScore(int value) {
    return 'النتيجة: $value%';
  }

  @override
  String get qlibSelectOption => 'اختر خياراً...';

  @override
  String get caTitle => 'إنشاء تقييم جديد';

  @override
  String get caNameLabel => 'اسم التقييم';

  @override
  String get caNameHint => 'مثال: تقييم أمني مخصص';

  @override
  String get caDescriptionLabel => 'الوصف';

  @override
  String get caDescriptionHint => 'وصف موجز للتقييم';

  @override
  String get caSelectCategory => 'اختر الفئة';

  @override
  String get caColorThemeLabel => 'لون السمة';

  @override
  String get caQuestionsLabel => 'الأسئلة';

  @override
  String get caEstTimeLabel => 'الوقت المقدّر';

  @override
  String get caEstTimeHint => '30-45 دقيقة';

  @override
  String get createAssessment => 'إنشاء التقييم';

  @override
  String get caCatCompliance => 'الامتثال';

  @override
  String get caCatSecurity => 'الأمن';

  @override
  String get caCatPrivacy => 'الخصوصية';

  @override
  String get caCatOperational => 'التشغيلية';

  @override
  String get caCatFinancial => 'المالية';

  @override
  String get themeBlue => 'أزرق';

  @override
  String get themeGreen => 'أخضر';

  @override
  String get themePurple => 'بنفسجي';

  @override
  String get themeOrange => 'برتقالي';

  @override
  String get themeRed => 'أحمر';
}
