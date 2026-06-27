import 'package:grc/features/enterprise_structure/domain/models/section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sectionListProvider = Provider<List<SectionOverview>>((ref) {
  return const [
    SectionOverview(
      id: 'sec_1',
      name: 'Cash Management Section',
      nameArabic: 'قسم إدارة النقد',
      code: 'SEC-CASH',
      departmentName: 'Treasury Department',
      businessUnitName: 'Corporate Finance',
      divisionName: 'Finance & Accounting Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Mubarak Al-Dosari',
      headEmail: 'mubarak.dosari@kuwaitholdings.com',
      headPhone: '+965 2211 2233',
      isActive: true,
      employees: 8,
      budget: '300K',
      focusArea: 'Cash Operations',
    ),
    SectionOverview(
      id: 'sec_2',
      name: 'Foreign Exchange Section',
      nameArabic: 'قسم الصرف الأجنبي',
      code: 'SEC-FX',
      departmentName: 'Treasury Department',
      businessUnitName: 'Corporate Finance',
      divisionName: 'Finance & Accounting Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Reem Al-Hajri',
      headEmail: 'reem.hajri@kuwaitholdings.com',
      headPhone: '+965 2222 3344',
      isActive: true,
      employees: 7,
      budget: '300K',
      focusArea: 'FX Trading',
    ),
    SectionOverview(
      id: 'sec_3',
      name: 'Equity Investments',
      nameArabic: 'استثمارات الأسهم',
      code: 'SEC-EQUITY',
      departmentName: 'Investment Department',
      businessUnitName: 'Corporate Finance',
      divisionName: 'Finance & Accounting Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Jaber Al-Khalifa',
      headEmail: 'jaber.khalifa@kuwaitholdings.com',
      headPhone: '+965 2233 4455',
      isActive: true,
      employees: 6,
      budget: '280K',
      focusArea: 'Equity',
    ),
    SectionOverview(
      id: 'sec_4',
      name: 'Fixed Income',
      nameArabic: 'الدخل الثابت',
      code: 'SEC-FI',
      departmentName: 'Investment Department',
      businessUnitName: 'Corporate Finance',
      divisionName: 'Finance & Accounting Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Dana Al-Sabah',
      headEmail: 'dana.sabah@kuwaitholdings.com',
      headPhone: '+965 2244 5566',
      isActive: true,
      employees: 6,
      budget: '270K',
      focusArea: 'Fixed Income',
    ),
    SectionOverview(
      id: 'sec_5',
      name: 'General Ledger',
      nameArabic: 'دفتر الأستاذ العام',
      code: 'SEC-GL',
      departmentName: 'Financial Reporting',
      businessUnitName: 'Accounting & Reporting',
      divisionName: 'Finance & Accounting Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Hessa Al-Roumi',
      headEmail: 'hessa.roumi@kuwaitholdings.com',
      headPhone: '+965 2255 6677',
      isActive: true,
      employees: 9,
      budget: '250K',
      focusArea: 'Accounting',
    ),
    SectionOverview(
      id: 'sec_6',
      name: 'Compliance Reporting',
      nameArabic: 'تقارير الامتثال',
      code: 'SEC-COMP',
      departmentName: 'Financial Reporting',
      businessUnitName: 'Accounting & Reporting',
      divisionName: 'Finance & Accounting Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Fahad Al-Shatti',
      headEmail: 'fahad.shatti@kuwaitholdings.com',
      headPhone: '+965 2266 7788',
      isActive: true,
      employees: 9,
      budget: '250K',
      focusArea: 'Compliance',
    ),
    SectionOverview(
      id: 'sec_7',
      name: 'Sourcing Section',
      nameArabic: 'قسم التوظيف',
      code: 'SEC-SOURCE',
      departmentName: 'Recruitment',
      businessUnitName: 'Recruitment & Talent',
      divisionName: 'HR Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Noura Al-Ibrahim',
      headEmail: 'noura.ibrahim@kuwaitholdings.com',
      headPhone: '+965 2277 8899',
      isActive: true,
      employees: 7,
      budget: '280K',
      focusArea: 'Talent Sourcing',
    ),
    SectionOverview(
      id: 'sec_8',
      name: 'Onboarding Section',
      nameArabic: 'قسم التأهيل',
      code: 'SEC-ONBOARD',
      departmentName: 'Recruitment',
      businessUnitName: 'Recruitment & Talent',
      divisionName: 'HR Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Khalid Al-Wazzan',
      headEmail: 'khalid.wazzan@kuwaitholdings.com',
      headPhone: '+965 2288 9900',
      isActive: true,
      employees: 7,
      budget: '270K',
      focusArea: 'Onboarding',
    ),
  ];
});

final sectionSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredSectionsProvider = Provider<List<SectionOverview>>((ref) {
  final sections = ref.watch(sectionListProvider);
  final query = ref.watch(sectionSearchQueryProvider).toLowerCase();

  if (query.isEmpty) return sections;

  return sections.where((section) {
    return section.name.toLowerCase().contains(query) ||
        section.code.toLowerCase().contains(query) ||
        section.headName.toLowerCase().contains(query);
  }).toList();
});

