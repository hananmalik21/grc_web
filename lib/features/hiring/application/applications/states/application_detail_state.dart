import 'package:grc/features/hiring/presentation/models/application_detail_data.dart';

class ApplicationDetailParams {
  const ApplicationDetailParams({required this.enterpriseId, required this.applicationGuid});

  final int enterpriseId;
  final String applicationGuid;

  @override
  bool operator ==(Object other) {
    return other is ApplicationDetailParams &&
        other.enterpriseId == enterpriseId &&
        other.applicationGuid == applicationGuid;
  }

  @override
  int get hashCode => Object.hash(enterpriseId, applicationGuid);
}

class ApplicationDetailState {
  const ApplicationDetailState({this.detail, this.isLoading = false, this.error});

  final ApplicationDetailData? detail;
  final bool isLoading;
  final String? error;

  factory ApplicationDetailState.initial() => const ApplicationDetailState();

  ApplicationDetailState copyWith({
    ApplicationDetailData? detail,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearDetail = false,
  }) {
    return ApplicationDetailState(
      detail: clearDetail ? null : (detail ?? this.detail),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
