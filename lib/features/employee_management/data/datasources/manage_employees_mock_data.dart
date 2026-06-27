import 'package:grc/features/employee_management/data/dto/employees_response_dto.dart';

EmployeesResponseDto getManageEmployeesMockResponse() {
  const mockData = [
    EmployeeListItemDto(
      enterpriseId: 1,
      employeeId: 1,
      employeeGuid: 'mock-guid-1',
      firstNameEn: 'Khuram',
      middleNameEn: 'K P',
      lastNameEn: 'Shahzad',
      email: 'khuram@example.com',
      phoneNumber: '+965 12345678',
      employeeStatus: 'ACTIVE',
      employeeIsActive: 'Y',
      employeeNumber: 'EMP-1',
    ),
    EmployeeListItemDto(
      enterpriseId: 1,
      employeeId: 2,
      employeeGuid: 'mock-guid-2',
      firstNameEn: 'Sarah',
      lastNameEn: 'Ahmed',
      email: 'sarah@example.com',
      phoneNumber: '+965 87654321',
      employeeStatus: 'ACTIVE',
      employeeIsActive: 'Y',
      employeeNumber: 'EMP-2',
    ),
  ];

  const mockMeta = PaginationMetaDto(
    page: 1,
    pageSize: 10,
    total: 2,
    totalPages: 1,
    hasNext: false,
    hasPrevious: false,
  );

  return EmployeesResponseDto(success: true, meta: mockMeta, data: mockData);
}
