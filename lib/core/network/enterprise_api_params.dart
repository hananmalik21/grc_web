/// Shared helpers for attaching [enterprise_id] to GRC API requests.
class EnterpriseApiParams {
  EnterpriseApiParams._();

  static Map<String, dynamic> withEnterpriseId(
    Map<String, dynamic> params,
    int enterpriseId,
  ) {
    return {...params, 'enterprise_id': enterpriseId};
  }

  static Map<String, dynamic> bodyWithEnterpriseId(
    Map<String, dynamic> body,
    int enterpriseId,
  ) {
    return {...body, 'enterprise_id': enterpriseId};
  }
}
