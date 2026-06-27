class LeaveType {
  final String name;
  final String nameArabic;
  final List<String> tags;
  final bool isActive;
  final bool isSelected;

  const LeaveType({
    required this.name,
    required this.nameArabic,
    required this.tags,
    this.isActive = true,
    this.isSelected = false,
  });
}
