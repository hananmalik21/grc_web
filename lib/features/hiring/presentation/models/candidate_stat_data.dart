class CandidateStatData {
  const CandidateStatData({
    required this.title,
    required this.value,
    required this.iconPath,
    this.subtext,
    this.showTrendIcon = false,
  });

  final String title;
  final String value;
  final String iconPath;
  final String? subtext;
  final bool showTrendIcon;
}
