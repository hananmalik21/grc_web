class RequisitionsFilterOption {
  const RequisitionsFilterOption({required this.value, required this.label});

  final String value;
  final String label;
}

const requisitionsDepartmentFilterOptions = <RequisitionsFilterOption>[
  RequisitionsFilterOption(value: 'engineering', label: 'Engineering'),
  RequisitionsFilterOption(value: 'hr', label: 'Human Resources'),
  RequisitionsFilterOption(value: 'finance', label: 'Finance'),
  RequisitionsFilterOption(value: 'operations', label: 'Operations'),
];

const requisitionsPriorityFilterOptions = <RequisitionsFilterOption>[
  RequisitionsFilterOption(value: 'high', label: 'High'),
  RequisitionsFilterOption(value: 'medium', label: 'Medium'),
  RequisitionsFilterOption(value: 'low', label: 'Low'),
];

const requisitionsStatusFilterOptions = <RequisitionsFilterOption>[
  RequisitionsFilterOption(value: 'draft', label: 'Draft'),
  RequisitionsFilterOption(value: 'pending_approval', label: 'Pending Approval'),
  RequisitionsFilterOption(value: 'approved', label: 'Approved'),
  RequisitionsFilterOption(value: 'open', label: 'Open'),
  RequisitionsFilterOption(value: 'on_hold', label: 'On Hold'),
  RequisitionsFilterOption(value: 'closed', label: 'Closed'),
];

const requisitionsWorkModeFilterOptions = <RequisitionsFilterOption>[
  RequisitionsFilterOption(value: 'onsite', label: 'On-site'),
  RequisitionsFilterOption(value: 'remote', label: 'Remote'),
  RequisitionsFilterOption(value: 'hybrid', label: 'Hybrid'),
];

const requisitionsEmploymentTypeFilterOptions = <RequisitionsFilterOption>[
  RequisitionsFilterOption(value: 'full_time', label: 'Full-time'),
  RequisitionsFilterOption(value: 'part_time', label: 'Part-time'),
  RequisitionsFilterOption(value: 'contract', label: 'Contract'),
];

String requisitionsFilterLabelForValue(List<RequisitionsFilterOption> options, String? value, String allLabel) {
  if (value == null) return allLabel;
  for (final option in options) {
    if (option.value == value) return option.label;
  }
  return allLabel;
}
