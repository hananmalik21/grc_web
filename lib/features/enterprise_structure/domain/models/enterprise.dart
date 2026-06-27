/// Domain model for Enterprise
class Enterprise {
  final int id;
  final String name;
  final String? code;
  final bool isActive;

  const Enterprise({
    required this.id,
    required this.name,
    this.code,
    required this.isActive,
  });
}

