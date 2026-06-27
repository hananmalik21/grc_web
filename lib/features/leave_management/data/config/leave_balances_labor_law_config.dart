class LeaveBalancesLaborLawCard {
  final String title;
  final String description;
  final String backgroundColorKey;
  final String titleColorKey;
  final String descriptionColorKey;

  const LeaveBalancesLaborLawCard({
    required this.title,
    required this.description,
    required this.backgroundColorKey,
    required this.titleColorKey,
    required this.descriptionColorKey,
  });
}

class LeaveBalancesLaborLawConfig {
  static List<LeaveBalancesLaborLawCard> getCards() {
    return const [
      LeaveBalancesLaborLawCard(
        title: 'Standard Annual Leave',
        description: '30 days per year after 1 year of service',
        backgroundColorKey: 'infoBg',
        titleColorKey: 'infoText',
        descriptionColorKey: 'infoTextSecondary',
      ),
      LeaveBalancesLaborLawCard(
        title: 'Sick Leave',
        description: '15 days full pay + 10 days half pay + 10 days unpaid',
        backgroundColorKey: 'greenBg',
        titleColorKey: 'greenText',
        descriptionColorKey: 'greenTextSecondary',
      ),
      LeaveBalancesLaborLawCard(
        title: 'Leave Accrual',
        description: 'Accrues monthly at 2.5 days per month',
        backgroundColorKey: 'purpleBg',
        titleColorKey: 'purpleText',
        descriptionColorKey: 'purpleTextSecondary',
      ),
    ];
  }
}
