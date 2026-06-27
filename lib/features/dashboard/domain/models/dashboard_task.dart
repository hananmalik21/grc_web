class DashboardTask {
  final String id;
  final String title;
  final String subtitle;
  final bool isCompleted;

  DashboardTask({required this.id, required this.title, required this.subtitle, required this.isCompleted});

  DashboardTask copyWith({String? id, String? title, String? subtitle, bool? isCompleted}) {
    return DashboardTask(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
