class PersonResultEmployee {
  const PersonResultEmployee({
    required this.name,
    required this.businessTitle,
    required this.personNumber,
    required this.assignmentNumber,
    required this.isActive,
    required this.workerType,
    required this.workEmail,
    required this.workPhone,
  });

  final String name;
  final String businessTitle;
  final String personNumber;
  final String assignmentNumber;
  final bool isActive;
  final String workerType;
  final String workEmail;
  final String workPhone;

  bool matchesQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;

    final statusLabel = isActive ? 'active' : 'inactive';

    return name.toLowerCase().contains(normalized) ||
        businessTitle.toLowerCase().contains(normalized) ||
        personNumber.toLowerCase().contains(normalized) ||
        assignmentNumber.toLowerCase().contains(normalized) ||
        statusLabel.contains(normalized) ||
        workerType.toLowerCase().contains(normalized) ||
        workEmail.toLowerCase().contains(normalized) ||
        workPhone.toLowerCase().contains(normalized);
  }
}

const kMockPersonResultEmployees = <PersonResultEmployee>[
  PersonResultEmployee(
    name: 'MANZOOR ALI MOHAMMED',
    businessTitle: 'WAREHOUSE SUPERVISOR',
    personNumber: 'EMP-10023',
    assignmentNumber: 'ASG-10023-01',
    isActive: true,
    workerType: 'Employee',
    workEmail: 'manzoor.ali@company.com',
    workPhone: '+965 2234 5678',
  ),
  PersonResultEmployee(
    name: 'OVAIS IQBAL SHAIKH',
    businessTitle: 'SALES DISTRIBUTION EXECUTIVE',
    personNumber: 'EMP-10031',
    assignmentNumber: 'ASG-10031-01',
    isActive: true,
    workerType: 'Employee',
    workEmail: 'ovais.iqbal@company.com',
    workPhone: '+965 2234 6789',
  ),
  PersonResultEmployee(
    name: 'HAMMAD RAZA',
    businessTitle: 'SENIOR SALES EXECUTIVE',
    personNumber: 'EMP-10045',
    assignmentNumber: 'ASG-10045-01',
    isActive: true,
    workerType: 'Employee',
    workEmail: 'hammad.raza@company.com',
    workPhone: '+965 2234 7890',
  ),
  PersonResultEmployee(
    name: 'KHURAM KHALID PERVAIZ SHAHZAD',
    businessTitle: 'FINANCE MANAGER',
    personNumber: 'EMP-10012',
    assignmentNumber: 'ASG-10012-01',
    isActive: true,
    workerType: 'Employee',
    workEmail: 'khuram.khalid@company.com',
    workPhone: '+965 2234 8901',
  ),
  PersonResultEmployee(
    name: 'SARA AL-MUTAIRI',
    businessTitle: 'HR BUSINESS PARTNER',
    personNumber: 'EMP-10067',
    assignmentNumber: 'ASG-10067-01',
    isActive: false,
    workerType: 'Employee',
    workEmail: 'sara.mutairi@company.com',
    workPhone: '+965 2234 9012',
  ),
];
