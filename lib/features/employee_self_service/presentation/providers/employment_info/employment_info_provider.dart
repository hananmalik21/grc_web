import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'employment_info_state.dart';

class EmploymentInfoNotifier extends StateNotifier<EmploymentInfoState> {
  EmploymentInfoNotifier() : super(_initial());

  static EmploymentInfoState _initial() {
    return const EmploymentInfoState(
      headerTitle: 'Employment & Assignment',
      headerSubtitle: 'Official records of your current role and position',
      businessUnit: 'PURCHASING',
      businessUnitSubtitle: 'Digify HR',
      position: 'HR Manager',
      originalHireDate: '2010-01-01',
      seniorityDate: '2010-01-01',
      grade: 'Grade 8 - Senior Manager',
      step: 'N/A',
      workSchedule: 'standard-40hr',
      assignmentStatus: 'Probation',
      employmentSector: 'Private Sector (Law 6/2010)',
      contractType: 'Permanent',
      contractEndDate: '--',
      overtimeEligibility: 'Not Eligible',
      workLocation: 'Registered HQ',
      directManager: ReportingPersonInfo(
        label: 'Direct Manager',
        name: 'Khalid Al-Rashidi',
        subtitle: 'Senior HR Director',
      ),
      myTeam: ReportingPersonInfo(
        label: 'My Team',
        name: '8 Direct Reports',
        subtitle: 'Manage team attendance & leave',
      ),
    );
  }
}

final employmentInfoProvider =
    StateNotifierProvider<EmploymentInfoNotifier, EmploymentInfoState>((ref) {
      return EmploymentInfoNotifier();
    });

