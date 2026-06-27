class LeaveBalancesLocalDataSource {
  List<Map<String, dynamic>> getEmployees() {
    return [
      {
        'name': 'Ahmed Al-Mutairi',
        'id': 'EMP001',
        'department': 'IT',
        'joinDate': '2020-01-15',
        'annualLeave': 23,
        'sickLeave': 15,
        'unpaidLeave': 0,
        'totalAvailable': 38,
      },
      {
        'name': 'Fatima Al-Rashid',
        'id': 'EMP002',
        'department': 'Human Resources',
        'joinDate': '2019-03-20',
        'annualLeave': 30,
        'sickLeave': 15,
        'unpaidLeave': 0,
        'totalAvailable': 45,
      },
      {
        'name': 'Mohammed Al-Sabah',
        'id': 'EMP003',
        'department': 'Finance',
        'joinDate': '2021-06-10',
        'annualLeave': 30,
        'sickLeave': 15,
        'unpaidLeave': 0,
        'totalAvailable': 45,
      },
    ];
  }

  List<String> getDepartments() {
    return ['All Departments', 'IT', 'Human Resources', 'Finance'];
  }
}
