import 'package:grc/features/compensation/data/dto/compensation_plans/compensation_plan_dto.dart';
import 'package:grc/features/compensation/data/dto/compensation_plans/compensation_plans_pagination_dto.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plans_page.dart';

class CompensationPlansPageDto {
  final List<CompensationPlanDto> items;
  final CompensationPlansPaginationDto? pagination;

  const CompensationPlansPageDto({required this.items, required this.pagination});

  factory CompensationPlansPageDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(CompensationPlanDto.fromJson)
        .toList();

    final paginationJson = json['pagination'];
    final pagination = paginationJson is Map<String, dynamic>
        ? CompensationPlansPaginationDto.fromJson(paginationJson)
        : null;

    return CompensationPlansPageDto(items: data, pagination: pagination);
  }

  CompensationPlansPage toDomain() {
    return CompensationPlansPage(items: items.map((e) => e.toDomain()).toList(), pagination: pagination?.toDomain());
  }
}
