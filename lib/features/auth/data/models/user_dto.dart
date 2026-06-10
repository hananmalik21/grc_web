import 'package:grc_web/features/auth/domain/entities/app_user.dart';

class UserDto {
  const UserDto({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  AppUser toEntity() => AppUser(id: id, name: name);
}

