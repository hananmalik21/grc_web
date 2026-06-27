class AccessRoleDetail {
  final String id;
  final String name;
  final String description;
  final String type;
  final int assignedUsersCount;
  final List<AccessRolePermission> permissions;
  final List<AccessAssignedUser> assignedUsers;
  final List<AccessActivity> activities;

  AccessRoleDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.assignedUsersCount,
    this.permissions = const [],
    this.assignedUsers = const [],
    this.activities = const [],
  });

  AccessRoleDetail copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    int? assignedUsersCount,
    List<AccessRolePermission>? permissions,
    List<AccessAssignedUser>? assignedUsers,
    List<AccessActivity>? activities,
  }) {
    return AccessRoleDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      assignedUsersCount: assignedUsersCount ?? this.assignedUsersCount,
      permissions: permissions ?? this.permissions,
      assignedUsers: assignedUsers ?? this.assignedUsers,
      activities: activities ?? this.activities,
    );
  }
}

class AccessRole {
  final String id;
  final String name;
  final String description;
  final String type;
  final int assignedUsersCount;

  AccessRole({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.assignedUsersCount,
  });
}

class AccessAssignedUser {
  final int? id;
  final String? name;
  final String? email;
  final String? code;
  final String? status;
  final DateTime? assignedDate;

  AccessAssignedUser({
    this.id,
    this.name,
    this.email,
    this.code,
    this.status,
    this.assignedDate,
  });

  AccessAssignedUser copyWith({
    int? id,
    String? name,
    String? email,
    String? code,
    String? status,
    DateTime? assignedDate,
  }) {
    return AccessAssignedUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      code: code ?? this.code,
      status: status ?? this.status,
      assignedDate: assignedDate ?? this.assignedDate,
    );
  }
}

class AccessActivity {
  final String? id;
  final String? title;
  final String? description;
  final String? user;
  final DateTime? timestamp;

  AccessActivity({
    this.id,
    this.title,
    this.description,
    this.user,
    this.timestamp,
  });

  AccessActivity copyWith({
    String? id,
    String? title,
    String? description,
    String? user,
    DateTime? timestamp,
  }) {
    return AccessActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      user: user ?? this.user,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class AccessRolePermission {
  final String id;
  final String name;
  final bool view;
  final bool create;
  final bool edit;
  final bool delete;

  AccessRolePermission({
    required this.id,
    required this.name,
    this.view = false,
    this.create = false,
    this.edit = false,
    this.delete = false,
  });

  AccessRolePermission copyWith({
    String? id,
    String? name,
    bool? view,
    bool? create,
    bool? edit,
    bool? delete,
  }) {
    return AccessRolePermission(
      id: id ?? this.id,
      name: name ?? this.name,
      view: view ?? this.view,
      create: create ?? this.create,
      edit: edit ?? this.edit,
      delete: delete ?? this.delete,
    );
  }
}
