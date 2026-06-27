import 'package:grc/features/compensation/data/dto/components/comp_component_dto.dart';
import 'package:grc/features/compensation/data/dto/components/comp_components_pagination_dto.dart';
import 'package:grc/features/compensation/domain/models/components/comp_components_page.dart';

class CompComponentsPageDto {
  final List<CompComponentDto> items;
  final CompComponentsPaginationDto? pagination;

  const CompComponentsPageDto({required this.items, required this.pagination});

  factory CompComponentsPageDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(CompComponentDto.fromJson)
        .toList();

    final paginationJson = json['pagination'];
    final pagination = paginationJson is Map<String, dynamic>
        ? CompComponentsPaginationDto.fromJson(paginationJson)
        : null;

    return CompComponentsPageDto(items: data, pagination: pagination);
  }

  CompComponentsPage toDomain() {
    return CompComponentsPage(items: items.map((e) => e.toDomain()).toList(), pagination: pagination?.toDomain());
  }
}
