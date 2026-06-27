sealed class Failure {
  const Failure({required this.message});
  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}

class EnterpriseNotSelectedFailure extends Failure {
  const EnterpriseNotSelectedFailure({
    super.message = 'Please select an enterprise.',
  });
}

