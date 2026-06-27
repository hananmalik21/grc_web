import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/hiring/data/dto/create_requisition_request_dto.dart';
import 'package:grc/features/hiring/data/dto/requisition_full_dto.dart';
import 'package:grc/features/hiring/data/dto/requisitions_dto.dart';
import 'package:grc/features/hiring/data/services/create_requisition_multipart_form_service.dart';

abstract class RequisitionsRemoteDataSource {
  Future<RequisitionsPageDto> getRequisitions({required int enterpriseId, int page = 1, int pageSize = 10});

  Future<RequisitionFullDto> getRequisitionByGuid({required String requisitionGuid, required int enterpriseId});

  Future<Map<String, dynamic>> createRequisition(CreateRequisitionRequestDto request);

  Future<Map<String, dynamic>> updateRequisition({
    required String requisitionGuid,
    required int enterpriseId,
    required CreateRequisitionRequestDto request,
  });

  Future<Map<String, dynamic>> approveRequisition({required String requisitionGuid, required int enterpriseId});

  Future<Map<String, dynamic>> rejectRequisition({
    required String requisitionGuid,
    required int enterpriseId,
    required String rejectionReason,
  });

  Future<Map<String, dynamic>> deleteRequisition({required String requisitionGuid, required int enterpriseId});

  Future<Map<String, dynamic>> reopenRequisition({required String requisitionGuid, required int enterpriseId});

  Future<Map<String, dynamic>> closeRequisition({required String requisitionGuid, required int enterpriseId});

  Future<Map<String, dynamic>> holdRequisition({required String requisitionGuid, required int enterpriseId});
}

class RequisitionsRemoteDataSourceImpl implements RequisitionsRemoteDataSource {
  const RequisitionsRemoteDataSourceImpl({
    required this.apiClient,
    CreateRequisitionMultipartFormService? multipartFormService,
  }) : _multipartFormService = multipartFormService ?? const CreateRequisitionMultipartFormService();

  final ApiClient apiClient;
  final CreateRequisitionMultipartFormService _multipartFormService;

  @override
  Future<RequisitionsPageDto> getRequisitions({required int enterpriseId, int page = 1, int pageSize = 10}) async {
    try {
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('page_size must be between 1 and 100');
      }

      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final response = await apiClient.get(ApiEndpoints.recRequisitions, queryParameters: queryParameters);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch requisitions';
        throw ServerException(message, statusCode: 400);
      }

      return RequisitionsPageDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch requisitions: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<RequisitionFullDto> getRequisitionByGuid({required String requisitionGuid, required int enterpriseId}) async {
    try {
      if (requisitionGuid.trim().isEmpty) {
        throw ValidationException('requisition_guid is required');
      }
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final response = await apiClient.get(
        ApiEndpoints.recRequisitionByGuid(requisitionGuid),
        queryParameters: {'enterprise_id': enterpriseId.toString()},
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch requisition';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ServerException('No data found in response', statusCode: 404);
      }

      return RequisitionFullDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch requisition: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> createRequisition(CreateRequisitionRequestDto request) async {
    try {
      final formData = await _multipartFormService.build(fields: request.fields, attachment: request.attachment);
      final response = await apiClient.postMultipart(ApiEndpoints.recRequisitions, formData: formData);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to create requisition';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create requisition: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateRequisition({
    required String requisitionGuid,
    required int enterpriseId,
    required CreateRequisitionRequestDto request,
  }) async {
    try {
      if (requisitionGuid.trim().isEmpty) {
        throw ValidationException('requisition_guid is required');
      }
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final formData = await _multipartFormService.build(fields: request.fields, attachment: request.attachment);
      final endpoint = ApiEndpoints.recRequisitionByGuid(requisitionGuid);
      final response = await apiClient.putMultipart(endpoint, formData: formData);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to update requisition';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update requisition: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> approveRequisition({required String requisitionGuid, required int enterpriseId}) async {
    try {
      if (requisitionGuid.trim().isEmpty) {
        throw ValidationException('requisition_guid is required');
      }
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final endpoint = '${ApiEndpoints.recRequisitions}/$requisitionGuid/approve?enterprise_id=$enterpriseId';
      final response = await apiClient.post(endpoint, body: const <String, dynamic>{});

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to approve requisition';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to approve requisition: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> rejectRequisition({
    required String requisitionGuid,
    required int enterpriseId,
    required String rejectionReason,
  }) async {
    try {
      if (requisitionGuid.trim().isEmpty) {
        throw ValidationException('requisition_guid is required');
      }
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final endpoint = '${ApiEndpoints.recRequisitions}/$requisitionGuid/reject?enterprise_id=$enterpriseId';
      final response = await apiClient.post(
        endpoint,
        body: <String, dynamic>{'rejected_by': 'admin', 'rejection_reason': rejectionReason},
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to reject requisition';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to reject requisition: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> deleteRequisition({required String requisitionGuid, required int enterpriseId}) async {
    try {
      if (requisitionGuid.trim().isEmpty) {
        throw ValidationException('requisition_guid is required');
      }
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final endpoint = ApiEndpoints.recRequisitions;
      final response = await apiClient.delete(
        '$endpoint/$requisitionGuid',
        queryParameters: {'enterprise_id': enterpriseId.toString()},
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to delete requisition';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete requisition: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> reopenRequisition({required String requisitionGuid, required int enterpriseId}) async {
    try {
      if (requisitionGuid.trim().isEmpty) {
        throw ValidationException('requisition_guid is required');
      }
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final endpoint = '${ApiEndpoints.recRequisitions}/$requisitionGuid/reopen?enterprise_id=$enterpriseId';
      final response = await apiClient.post(endpoint, body: const <String, dynamic>{});

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to reopen requisition';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to reopen requisition: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> closeRequisition({required String requisitionGuid, required int enterpriseId}) async {
    try {
      if (requisitionGuid.trim().isEmpty) {
        throw ValidationException('requisition_guid is required');
      }
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final endpoint = '${ApiEndpoints.recRequisitions}/$requisitionGuid/close?enterprise_id=$enterpriseId';
      final response = await apiClient.post(endpoint, body: const <String, dynamic>{});

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to close requisition';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to close requisition: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> holdRequisition({required String requisitionGuid, required int enterpriseId}) async {
    try {
      if (requisitionGuid.trim().isEmpty) {
        throw ValidationException('requisition_guid is required');
      }
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final endpoint = '${ApiEndpoints.recRequisitions}/$requisitionGuid/hold?enterprise_id=$enterpriseId';
      final response = await apiClient.post(endpoint, body: const <String, dynamic>{});

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to put requisition on hold';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to put requisition on hold: ${e.toString()}', originalError: e);
    }
  }
}
