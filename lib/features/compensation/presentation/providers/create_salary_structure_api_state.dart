enum CreateSalaryStructureApiStatus { idle, loading, success, failure }

class CreateSalaryStructureApiState {
  final CreateSalaryStructureApiStatus status;
  final String? errorMessage;

  const CreateSalaryStructureApiState._(this.status, {this.errorMessage});

  const CreateSalaryStructureApiState.idle() : this._(CreateSalaryStructureApiStatus.idle);

  const CreateSalaryStructureApiState.loading() : this._(CreateSalaryStructureApiStatus.loading);

  const CreateSalaryStructureApiState.success() : this._(CreateSalaryStructureApiStatus.success);

  const CreateSalaryStructureApiState.failure(String message)
    : this._(CreateSalaryStructureApiStatus.failure, errorMessage: message);

  bool get isLoading => status == CreateSalaryStructureApiStatus.loading;
}
