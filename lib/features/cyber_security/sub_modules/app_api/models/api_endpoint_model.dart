import 'package:flutter/material.dart';

enum HttpMethod {
  get('GET', Color(0xFF00BCD4)),
  post('POST', Color(0xFF10B981)),
  delete('DELETE', Color(0xFF38BDF8)),
  put('PUT', Color(0xFFF59E0B)),
  patch('PATCH', Color(0xFFA855F7));

  final String label;
  final Color color;
  const HttpMethod(this.label, this.color);
}

enum EndpointRisk {
  critical('CRITICAL', Color(0xFFEF4444)),
  high('HIGH', Color(0xFFF97316)),
  medium('MEDIUM', Color(0xFFFBBF24)),
  low('LOW', Color(0xFF38BDF8)),
  info('INFO', Color(0xFF64748B));

  final String label;
  final Color color;
  const EndpointRisk(this.label, this.color);
}

class ApiEndpointModel {
  final String endpoint;
  final HttpMethod method;
  final String auth;
  final bool isAuthMissing;
  final bool rateLimitEnabled;
  final int issuesCount;
  final EndpointRisk risk;

  const ApiEndpointModel({
    required this.endpoint,
    required this.method,
    required this.auth,
    this.isAuthMissing = false,
    required this.rateLimitEnabled,
    required this.issuesCount,
    required this.risk,
  });

  static List<ApiEndpointModel> getMockEndpoints() => const [
    ApiEndpointModel(
      endpoint: '/api/v2/users',
      method: HttpMethod.get,
      auth: 'JWT',
      rateLimitEnabled: true,
      issuesCount: 0,
      risk: EndpointRisk.low,
    ),
    ApiEndpointModel(
      endpoint: '/api/v2/payments',
      method: HttpMethod.post,
      auth: 'JWT',
      rateLimitEnabled: true,
      issuesCount: 1,
      risk: EndpointRisk.medium,
    ),
    ApiEndpointModel(
      endpoint: '/api/v1/export',
      method: HttpMethod.get,
      auth: 'API Key',
      rateLimitEnabled: false,
      issuesCount: 3,
      risk: EndpointRisk.high,
    ),
    ApiEndpointModel(
      endpoint: '/api/v2/admin/users',
      method: HttpMethod.delete,
      auth: 'JWT',
      rateLimitEnabled: false,
      issuesCount: 2,
      risk: EndpointRisk.high,
    ),
    ApiEndpointModel(
      endpoint: '/api/v1/reports',
      method: HttpMethod.get,
      auth: 'None',
      isAuthMissing: true,
      rateLimitEnabled: false,
      issuesCount: 5,
      risk: EndpointRisk.critical,
    ),
    ApiEndpointModel(
      endpoint: '/api/v2/health',
      method: HttpMethod.get,
      auth: 'None',
      isAuthMissing: true,
      rateLimitEnabled: true,
      issuesCount: 0,
      risk: EndpointRisk.info,
    ),
  ];
}
