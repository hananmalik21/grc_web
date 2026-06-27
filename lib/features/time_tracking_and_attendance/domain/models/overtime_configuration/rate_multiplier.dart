class RateMultiplier {
  final String otRateTypeId;
  final String rateCode;
  final String rateName;
  final String rateDescription;
  final String categoryCode;
  final String multiplier;
  final String otRateMultiplierId;

  RateMultiplier({
    this.otRateTypeId = '',
    this.rateName = '',
    this.rateCode = '',
    this.rateDescription = '',
    this.categoryCode = '',
    this.multiplier = '',
    this.otRateMultiplierId = '',
  });

  RateMultiplier copyWith({
    String? id,
    String? name,
    String? rateCode,
    String? description,
    String? category,
    String? multiplier,
    String? otRateMultiplierId,
  }) {
    return RateMultiplier(
      otRateTypeId: id ?? otRateTypeId,
      rateName: name ?? rateName,
      rateCode: rateCode ?? this.rateCode,
      rateDescription: description ?? rateDescription,
      categoryCode: category ?? categoryCode,
      multiplier: multiplier ?? this.multiplier,
      otRateMultiplierId: otRateMultiplierId ?? this.otRateMultiplierId,
    );
  }

  factory RateMultiplier.fromJson(Map<String, dynamic> json) {
    final multipliers = json['multipliers'] as List<dynamic>? ?? [];
    String multiplierVal = '';
    String otRateMultiplierIdVal = '';
    if (multipliers.isNotEmpty) {
      final first = multipliers[0] as Map?;
      if (first != null) {
        multiplierVal = first['multiplier']?.toString() ?? '';
        otRateMultiplierIdVal = first['ot_rate_multiplier_id']?.toString() ?? '';
      }
    }

    return RateMultiplier(
      otRateTypeId: json['ot_rate_type_id']?.toString() ?? '',
      rateCode: json['rate_code']?.toString() ?? '',
      rateName: json['rate_name']?.toString() ?? '',
      rateDescription: json['rate_description']?.toString() ?? '',
      categoryCode: json['category_code']?.toString() ?? '',
      multiplier: multiplierVal,
      otRateMultiplierId: otRateMultiplierIdVal,
    );
  }
}
