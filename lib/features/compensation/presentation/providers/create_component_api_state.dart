enum CreateComponentApiStatus { idle, loading, success, failure }

class CreateComponentApiState {
  final CreateComponentApiStatus status;
  final String? errorMessage;

  const CreateComponentApiState._(this.status, {this.errorMessage});

  const CreateComponentApiState.idle() : this._(CreateComponentApiStatus.idle);
  const CreateComponentApiState.loading() : this._(CreateComponentApiStatus.loading);
  const CreateComponentApiState.success() : this._(CreateComponentApiStatus.success);
  const CreateComponentApiState.failure(String message)
    : this._(CreateComponentApiStatus.failure, errorMessage: message);

  bool get isLoading => status == CreateComponentApiStatus.loading;
  bool get isSuccess => status == CreateComponentApiStatus.success;
  bool get isFailure => status == CreateComponentApiStatus.failure;
}
