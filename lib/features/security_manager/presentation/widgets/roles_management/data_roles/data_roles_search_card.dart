import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataRolesSearchCard extends StatelessWidget {
  const DataRolesSearchCard({
    super.key,
    required this.searchController,
    required this.selectedDataType,
    required this.dataTypeOptions,
    required this.dataTypesLoading,
    required this.onSearchChanged,
    required this.onDataTypeChanged,
  });

  final TextEditingController searchController;
  final SecurityLookupValue? selectedDataType;
  final List<SecurityLookupValue> dataTypeOptions;
  final bool dataTypesLoading;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onDataTypeChanged;

  String get _hint => dataTypesLoading ? 'Loading data types...' : 'All Data Types';

  @override
  Widget build(BuildContext context) {
    return RolesManagementSurfaceCard(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.isMobile
              ? Column(
                  children: [
                    DigifyTextField.search(
                      labelText: 'Search',
                      controller: searchController,
                      hintText: 'Search by role name, code, or description...',
                      filled: true,
                      fillColor: Colors.transparent,
                      onChanged: onSearchChanged,
                    ),
                    Gap(14.h),
                    DigifySelectFieldWithLabel<SecurityLookupValue?>(
                      label: 'Data Type',
                      value: selectedDataType,
                      items: [null, ...dataTypeOptions],
                      itemLabelBuilder: (item) => item?.valueName ?? 'All Data Types',
                      hint: _hint,
                      onChanged: dataTypesLoading ? null : (v) => onDataTypeChanged(v?.valueCode),
                      fillColor: Colors.transparent,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: DigifyTextField.search(
                        labelText: 'Search',
                        controller: searchController,
                        hintText: 'Search by role name, code, or description...',
                        filled: true,
                        fillColor: Colors.transparent,
                        onChanged: onSearchChanged,
                      ),
                    ),
                    Gap(14.w),
                    Expanded(
                      child: DigifySelectFieldWithLabel<SecurityLookupValue?>(
                        label: 'Data Type',
                        value: selectedDataType,
                        items: [null, ...dataTypeOptions],
                        itemLabelBuilder: (item) => item?.valueName ?? 'All Data Types',
                        hint: _hint,
                        onChanged: dataTypesLoading ? null : (v) => onDataTypeChanged(v?.valueCode),
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
