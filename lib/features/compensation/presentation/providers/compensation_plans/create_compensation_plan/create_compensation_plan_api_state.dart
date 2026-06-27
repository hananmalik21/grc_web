enum CreateCompensationPlanApiStatus { idle, loading, success, failure }

class CreateCompensationPlanApiState {
  final CreateCompensationPlanApiStatus status;
  final String? errorMessage;

  const CreateCompensationPlanApiState._(this.status, {this.errorMessage});

  const CreateCompensationPlanApiState.idle() : this._(CreateCompensationPlanApiStatus.idle);
  const CreateCompensationPlanApiState.loading() : this._(CreateCompensationPlanApiStatus.loading);
  const CreateCompensationPlanApiState.success() : this._(CreateCompensationPlanApiStatus.success);
  const CreateCompensationPlanApiState.failure(String message)
    : this._(CreateCompensationPlanApiStatus.failure, errorMessage: message);

  bool get isLoading => status == CreateCompensationPlanApiStatus.loading;
  bool get isSuccess => status == CreateCompensationPlanApiStatus.success;
  bool get isFailure => status == CreateCompensationPlanApiStatus.failure;
}
