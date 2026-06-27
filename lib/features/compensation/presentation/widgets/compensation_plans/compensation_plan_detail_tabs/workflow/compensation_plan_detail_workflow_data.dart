class WorkflowActor {
  final String initials;
  final String name;

  const WorkflowActor({required this.initials, required this.name});
}

class WorkflowEvent {
  final String title;
  final String description;
  final String timestamp;
  final WorkflowActor actor;

  const WorkflowEvent({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.actor,
  });
}

class CompensationPlanDetailWorkflowData {
  CompensationPlanDetailWorkflowData._();

  static const events = <WorkflowEvent>[
    WorkflowEvent(
      title: 'Draft Created',
      description: 'Initial draft created for 2026 executive compensation',
      timestamp: '2025-11-15 at 10:30 AM',
      actor: WorkflowActor(initials: 'SJ', name: 'Sarah Johnson'),
    ),
    WorkflowEvent(
      title: 'Components Added',
      description: 'Added all required compensation components',
      timestamp: '2025-11-18 at 2:15 PM',
      actor: WorkflowActor(initials: 'SJ', name: 'Sarah Johnson'),
    ),
    WorkflowEvent(
      title: 'Eligibility Rules Configured',
      description: 'Defined eligibility criteria for executive grades',
      timestamp: '2025-11-20 at 11:00 AM',
      actor: WorkflowActor(initials: 'SJ', name: 'Sarah Johnson'),
    ),
    WorkflowEvent(
      title: 'Submitted for Approval',
      description: 'Submitted to compensation committee for review',
      timestamp: '2025-11-22 at 4:30 PM',
      actor: WorkflowActor(initials: 'SJ', name: 'Sarah Johnson'),
    ),
    WorkflowEvent(
      title: 'HR Manager Approval',
      description: 'Approved after review - compensation structure aligns with budget',
      timestamp: '2025-11-25 at 9:45 AM',
      actor: WorkflowActor(initials: 'MC', name: 'Michael Chen'),
    ),
    WorkflowEvent(
      title: 'Finance Approval',
      description: 'Financial approval granted - budget allocated',
      timestamp: '2025-11-28 at 3:20 PM',
      actor: WorkflowActor(initials: 'JW', name: 'Jennifer Wilson'),
    ),
    WorkflowEvent(
      title: 'Published',
      description: 'Plan published and effective from Jan 1, 2026',
      timestamp: '2025-12-01 at 10:00 AM',
      actor: WorkflowActor(initials: 'SJ', name: 'Sarah Johnson'),
    ),
  ];
}

