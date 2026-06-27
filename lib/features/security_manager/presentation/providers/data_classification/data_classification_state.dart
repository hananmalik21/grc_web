import 'package:grc/gen/assets.gen.dart';

enum DataClassificationType { public, confidential, restricted }

extension DataClassificationTypeX on DataClassificationType {
  String get label => switch (this) {
    DataClassificationType.public => 'Public',
    DataClassificationType.confidential => 'Confidential',
    DataClassificationType.restricted => 'Restricted',
  };

  String get subtitle => switch (this) {
    DataClassificationType.public => 'Information that can be freely shared',
    DataClassificationType.confidential => 'Sensitive information requiring protection',
    DataClassificationType.restricted => 'Highly sensitive information with strict access controls',
  };

  String get iconPath => switch (this) {
    DataClassificationType.public => Assets.icons.blueEyeIcon.path,
    DataClassificationType.confidential => Assets.icons.leaveManagement.shield.path,
    DataClassificationType.restricted => Assets.icons.lockIcon.path,
  };
}

class DataClassificationLevel {
  final DataClassificationType type;
  final List<String> protectedFields;
  final List<String> accessRoles;

  const DataClassificationLevel({required this.type, required this.protectedFields, required this.accessRoles});

  int get fieldsCount => protectedFields.length;
}

class DataClassificationState {
  final String query;
  final List<DataClassificationLevel> levels;

  const DataClassificationState({this.query = '', this.levels = const []});

  DataClassificationState copyWith({String? query, List<DataClassificationLevel>? levels}) {
    return DataClassificationState(query: query ?? this.query, levels: levels ?? this.levels);
  }
}
