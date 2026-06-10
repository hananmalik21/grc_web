import 'package:dio/dio.dart';
import 'package:grc_web/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:grc_web/features/auth/data/models/user_dto.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserDto> getCurrentUser() async {
    // Example stub. Replace with a real endpoint later.
    await Future<void>.delayed(const Duration(milliseconds: 700));

    // Touch Dio so the layer is wired (and ready for real networking).
    // This request is intentionally not executed.
    _dio.options.headers;

    return const UserDto(id: '1', name: 'Alex');
  }
}

