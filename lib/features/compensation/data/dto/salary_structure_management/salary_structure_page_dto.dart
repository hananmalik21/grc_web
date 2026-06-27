import 'package:grc/features/compensation/data/dto/salary_structure_management/salary_structure_item_dto.dart';
import 'package:grc/features/compensation/data/dto/salary_structure_management/salary_structure_pagination_dto.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_page.dart';

class SalaryStructurePageDto {
  final List<SalaryStructureItemDto> items;
  final SalaryStructurePaginationDto? pagination;

  const SalaryStructurePageDto({required this.items, required this.pagination});

  factory SalaryStructurePageDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(SalaryStructureItemDto.fromJson)
        .toList();

    final paginationJson = json['pagination'];
    final pagination = paginationJson is Map<String, dynamic>
        ? SalaryStructurePaginationDto.fromJson(paginationJson)
        : null;

    return SalaryStructurePageDto(items: data, pagination: pagination);
  }

  SalaryStructurePage toDomain() {
    return SalaryStructurePage(items: items.map((e) => e.toDomain()).toList(), pagination: pagination?.toDomain());
  }
}
