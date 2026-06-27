import 'candidate_data.dart';

class RequisitionFindCandidatesTabConfig {
  RequisitionFindCandidatesTabConfig._();

  static List<CandidateData> get mockCandidates => [
    CandidateData(
      id: 'CAN-001',
      name: 'Michael Chen',
      role: 'Senior Software Engineer',
      company: 'Tech Giants Inc',
      matchPercentage: 95,
      experience: '7 years',
      location: 'San Francisco, CA',
      email: 'michael.chen@email.com',
      availability: 'Available in 2 weeks',
      keySkills: ['JavaScript', 'React', 'Node.js', 'Python', 'AWS', 'System Design'],
      talentPool: 'Software Engineering - Senior Level',
      education: "Master's in Computer Science",
    ),
    CandidateData(
      id: 'CAN-002',
      name: 'Sarah Williams',
      role: 'Lead Software Engineer',
      company: 'Innovative Solutions',
      matchPercentage: 92,
      experience: '9 years',
      location: 'San Jose, CA',
      email: 'sarah.williams@email.com',
      availability: 'Immediate',
      keySkills: ['Java', 'Spring Boot', 'Microservices', 'Kubernetes', 'React', 'Architecture'],
      talentPool: 'Software Engineering - Senior Level',
      education: "Bachelor's in Software Engineering",
    ),
    CandidateData(
      id: 'CAN-003',
      name: 'Emily Rodriguez',
      role: 'Senior Backend Engineer',
      company: 'StartupHub',
      matchPercentage: 90,
      experience: '8 years',
      location: 'Austin, TX',
      email: 'emily.rodriguez@email.com',
      availability: 'Available in 3 weeks',
      keySkills: ['Python', 'Django', 'PostgreSQL', 'Redis', 'AWS', 'CI/CD'],
      talentPool: 'Software Engineering - Senior Level',
      education: 'Ph.D. in Computer Science',
    ),
    CandidateData(
      id: 'CAN-004',
      name: 'David Kumar',
      role: 'Senior Full Stack Developer',
      company: 'Cloud Systems Corp',
      matchPercentage: 88,
      experience: '6 years',
      location: 'Remote (US)',
      email: 'david.kumar@email.com',
      availability: 'Available in 1 month',
      keySkills: ['TypeScript', 'React', 'Node.js', 'GraphQL', 'MongoDB', 'Docker'],
      talentPool: 'Software Engineering - Senior Level',
      education: "Master's in Computer Science",
    ),
  ];

  static const int pageSize = 10;
}
