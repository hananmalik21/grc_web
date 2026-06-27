/// Configuration and static data for salary structure creation flow
class SalaryStructureCreationConfig {
  // Structure Types
  static const List<String> structureTypes = ['Standard', 'Custom', 'Grade-based', 'Fixed Rate'];

  // Currencies
  static const List<String> currencies = [
    'KWD - Kuwaiti Dinar',
    'USD - US Dollar',
    'EUR - Euro',
    'GBP - British Pound',
  ];

  // Countries - can be expanded with more countries
  static const List<String> countries = ['Kuwait', 'Saudi Arabia', 'United Arab Emirates', 'Bahrain', 'Qatar', 'Oman'];

  // Companies - example placeholder data
  static const List<String> companies = ['Main Company', 'Regional Office', 'Branch Office'];

  // Enterprises - example placeholder data
  static const List<String> enterprises = ['Enterprise A', 'Enterprise B', 'Enterprise C'];

  // Business Units - example placeholder data
  static const List<String> businessUnits = ['Human Resources', 'Finance', 'Operations', 'Sales', 'Marketing', 'IT'];

  // Employee Categories
  static const List<String> employeeCategories = [
    'Executive',
    'Manager',
    'Senior Staff',
    'Staff',
    'Junior Staff',
    'Consultant',
  ];

  // Helper method to get all dropdown configurations
  static Map<String, List<String>> getAllDropdownValues() => {
    'structureTypes': structureTypes,
    'currencies': currencies,
    'countries': countries,
    'companies': companies,
    'enterprises': enterprises,
    'businessUnits': businessUnits,
    'employeeCategories': employeeCategories,
  };
}
