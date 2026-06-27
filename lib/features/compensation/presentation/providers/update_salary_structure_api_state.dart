enum UpdateSalaryStructureApiStatus { idle, loading, success, failure }

class UpdateSalaryStructureApiState {
  final UpdateSalaryStructureApiStatus status;
  final String? errorMessage;

  const UpdateSalaryStructureApiState._(this.status, {this.errorMessage});

  const UpdateSalaryStructureApiState.idle()
      : this._(UpdateSalaryStructureApiStatus.idle);

  const UpdateSalaryStructureApiState.loading()
      : this._(UpdateSalaryStructureApiStatus.loading);

  const UpdateSalaryStructureApiState.success()
      : this._(UpdateSalaryStructureApiStatus.success);

  const UpdateSalaryStructureApiState.failure(String message)
      : this._(UpdateSalaryStructureApiStatus.failure, errorMessage: message);

  bool get isLoading => status == UpdateSalaryStructureApiStatus.loading;
}
