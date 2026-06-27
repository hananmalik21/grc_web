/// Base exception for all API-related errors
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const AppException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.statusCode, super.originalError});
}

/// Server error exceptions (5xx)
class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode, super.originalError});
}

/// Client error exceptions (4xx)
class ClientException extends AppException {
  const ClientException(super.message, {super.statusCode, super.originalError});
}

/// Unauthorized exception (401)
class UnauthorizedException extends ClientException {
  const UnauthorizedException(super.message, {super.statusCode, super.originalError});
}

/// Forbidden exception (403)
class ForbiddenException extends ClientException {
  const ForbiddenException(super.message, {super.statusCode, super.originalError});
}

/// Not found exception (404)
class NotFoundException extends ClientException {
  const NotFoundException(super.message, {super.statusCode, super.originalError});
}

/// Validation exception (422)
class ValidationException extends ClientException {
  final Map<String, dynamic>? errors;

  const ValidationException(super.message, {super.statusCode, super.originalError, this.errors});
}

extension AppExceptionMessage on AppException {
  String get displayMessage {
    final trimmedMessage = message.trim();
    if (this is! ValidationException) return trimmedMessage;

    final validationErrors = (this as ValidationException).errors;
    if (validationErrors == null || validationErrors.isEmpty) {
      return trimmedMessage;
    }

    final details = validationErrors.values
        .map(_formatValidationErrorValue)
        .where((value) => value.trim().isNotEmpty)
        .join(', ');
    if (details.isEmpty) return trimmedMessage;

    if (trimmedMessage.isEmpty || trimmedMessage == 'Validation failed' || trimmedMessage == 'Validation error') {
      return details;
    }
    if (trimmedMessage.contains(details)) return trimmedMessage;
    return '$trimmedMessage: $details';
  }
}

String _formatValidationErrorValue(dynamic value) {
  if (value is List) {
    return value.map((item) => item.toString()).join(', ');
  }
  return value.toString();
}

/// Timeout exception
class TimeoutException extends NetworkException {
  const TimeoutException(super.message, {super.statusCode, super.originalError});
}

/// Connection exception
class ConnectionException extends NetworkException {
  const ConnectionException(super.message, {super.statusCode, super.originalError});
}

/// Conflict exception (409)
class ConflictException extends ClientException {
  final Map<String, dynamic>? details;

  const ConflictException(super.message, {super.statusCode, super.originalError, this.details});
}

/// Unknown exception
class UnknownException extends AppException {
  const UnknownException(super.message, {super.statusCode, super.originalError});
}
