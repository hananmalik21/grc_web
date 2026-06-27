import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/data/custom_status_cell.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/enterprise_structure/domain/models/component_value.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentTableView extends StatelessWidget {
  final List<ComponentValue> components;
  final List<ComponentValue> allComponents;
  final ComponentType? filterType;
  final List<StructureListItem>? orgStructures;
  final bool isLoading;
  final Function(ComponentValue component)? onView;
  final Function(ComponentValue component)? onEdit;
  final Function(ComponentValue component)? onDelete;
  final Function(ComponentValue component)? onDuplicate;

  const ComponentTableView({
    super.key,
    required this.components,
    required this.allComponents,
    this.filterType,
    this.orgStructures,
    this.isLoading = false,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    if (isLoading && components.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLoadingIndicator(type: LoadingType.fadingCircle, color: AppColors.primary),
              Gap(16.h),
              Text(
                localizations.pleaseWait,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (components.isEmpty) {
      return Container(
        padding: EdgeInsets.all(40.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, -1)),
          ],
        ),
        child: Center(
          child: Text(
            localizations.noComponentsFound,
            style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          ),
        ),
      );
    }

    final columnWidths = _getColumnWidths(filterType);

    final totalWidth = columnWidths.values.fold<double>(0, (sum, width) => sum + width);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, -1)),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: totalWidth.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTableHeader(context, localizations, isDark, columnWidths),
              _buildTableBody(context, localizations, isDark, columnWidths),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, double> _getColumnWidths(ComponentType? type) {
    switch (type) {
      case ComponentType.company:
        return {
          'code': 156.47,
          'name': 216.37,
          'arabicName': 165.45,
          'parent': 120.4,
          'manager': 211.76,
          'location': 151.59,
          'status': 124.5,
          'lastUpdated': 174.27,
          'actions': 141.2,
        };
      case ComponentType.division:
        return {
          'code': 108.2,
          'name': 224.6,
          'arabicName': 162.91,
          'parent': 266.43,
          'manager': 195.02,
          'location': 148.12,
          'status': 100.94,
          'lastUpdated': 141.29,
          'actions': 114.48,
        };
      case ComponentType.businessUnit:
        return {
          'code': 120.1,
          'name': 216.6,
          'arabicName': 148.71,
          'parent': 249.21,
          'manager': 152.83,
          'location': 176.34,
          'status': 100.59,
          'lastUpdated': 183.52,
          'actions': 114.1,
        };
      case ComponentType.department:
        return {
          'code': 110.99,
          'name': 231.72,
          'arabicName': 156.74,
          'parent': 245.21,
          'manager': 153.59,
          'location': 182.43,
          'status': 98.78,
          'lastUpdated': 130.51,
          'actions': 136.02,
        };
      case ComponentType.section:
        return {
          'code': 110.99,
          'name': 231.72,
          'arabicName': 156.74,
          'parent': 245.21,
          'manager': 153.59,
          'location': 182.43,
          'status': 98.78,
          'lastUpdated': 130.51,
          'actions': 136.02,
        };
      default:
        return {
          'code': 156.47,
          'name': 216.37,
          'arabicName': 165.45,
          'parent': 120.4,
          'manager': 211.76,
          'location': 151.59,
          'status': 124.5,
          'lastUpdated': 174.27,
          'actions': 141.2,
        };
    }
  }

  Widget _buildTableHeader(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    Map<String, double> columnWidths,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final headerHeight = filterType == ComponentType.department
        ? (isMobile ? 64.h : (isTablet ? 60.h : 56.h))
        : (isMobile ? 48.h : (isTablet ? 44.h : 40.h));
    final headerPadding = filterType == ComponentType.department
        ? (isMobile ? 12.h : (isTablet ? 16.h : 20.h))
        : (isMobile ? 10.h : (isTablet ? 11.h : 12.h));

    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF9FAFB),
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          _buildHeaderCell(context, localizations.componentCode, columnWidths['code']!, headerPadding, isDark),
          _buildHeaderCell(context, localizations.componentName, columnWidths['name']!, headerPadding, isDark),
          _buildHeaderCell(context, localizations.arabicName, columnWidths['arabicName']!, headerPadding, isDark),
          _buildHeaderCell(
            context,
            filterType == ComponentType.company ? 'Parent Org' : localizations.parentComponent,
            columnWidths['parent']!,
            headerPadding,
            isDark,
          ),
          _buildHeaderCell(
            context,
            filterType == ComponentType.company ? 'Reg No' : localizations.manager,
            columnWidths['manager']!,
            headerPadding,
            isDark,
          ),
          _buildHeaderCell(context, localizations.location, columnWidths['location']!, headerPadding, isDark),
          _buildHeaderCell(context, localizations.status, columnWidths['status']!, headerPadding, isDark),
          _buildHeaderCell(
            context,
            localizations.lastUpdated,
            columnWidths['lastUpdated']!,
            headerPadding,
            isDark,
            isTwoLine: filterType == ComponentType.department,
          ),
          _buildHeaderCell(context, localizations.actions, columnWidths['actions']!, headerPadding, isDark),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String label,
    double width,
    double padding,
    bool isDark, {
    bool isTwoLine = false,
  }) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final horizontalPadding = isMobile ? 12.w : (isTablet ? 16.w : 24.w);
    final fontSize = isMobile ? 10.sp : (isTablet ? 11.sp : 12.sp);

    return Container(
      width: width.w,
      padding: EdgeInsetsDirectional.symmetric(horizontal: horizontalPadding, vertical: padding),
      child: isTwoLine
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.split(' ').first,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
                    height: 16 / 12,
                    letterSpacing: 0,
                  ),
                ),
                if (label.contains(' '))
                  Text(
                    label.split(' ').skip(1).join(' '),
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
                      height: 16 / 12,
                      letterSpacing: 0,
                    ),
                  ),
              ],
            )
          : Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
                height: 16 / 12,
                letterSpacing: 0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
    );
  }

  Widget _buildTableBody(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    Map<String, double> columnWidths,
  ) {
    return Column(
      children: components.asMap().entries.map((entry) {
        final index = entry.key;
        final component = entry.value;
        final isLast = index == components.length - 1;

        return _buildTableRow(context, localizations, isDark, component, columnWidths, isLast);
      }).toList(),
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    ComponentValue component,
    Map<String, double> columnWidths,
    bool isLast,
  ) {
    final parentName = _getParentName(component);

    final rowPadding = filterType == ComponentType.department ? 24.25.h : 23.75.h;

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCell(
            context,
            component.code,
            columnWidths['code']!,
            rowPadding,
            isDark,
            fontWeight: FontWeight.w500,
            fontSize: filterType == ComponentType.department ? 13.8.sp : 13.9.sp,
          ),
          _buildCell(
            context,
            _formatName(component.name),
            columnWidths['name']!,
            rowPadding,
            isDark,
            isMultiLine: filterType == ComponentType.department && component.name.contains(' '),
            fontSize: filterType == ComponentType.department ? 13.5.sp : 13.6.sp,
          ),
          _buildCell(
            context,
            _formatArabicName(component.arabicName),
            columnWidths['arabicName']!,
            rowPadding,
            isDark,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.end,
            isMultiLine: filterType == ComponentType.department && component.arabicName.contains(' '),
            fontSize: 14.sp,
          ),
          _buildCell(
            context,
            parentName,
            columnWidths['parent']!,
            rowPadding,
            isDark,
            color: const Color(0xFF4A5565),
            isMultiLine: filterType == ComponentType.department && parentName.contains('('),
            fontSize: filterType == ComponentType.department ? 13.6.sp : 13.7.sp,
          ),
          _buildCell(
            context,
            _formatManagerName(component.managerId ?? '-'),
            columnWidths['manager']!,
            rowPadding,
            isDark,
            color: const Color(0xFF4A5565),
            isMultiLine: filterType == ComponentType.department && (component.managerId?.contains(' ') ?? false),
            fontSize: filterType == ComponentType.department ? 13.6.sp : 13.7.sp,
          ),
          _buildCell(
            context,
            _formatLocation(component.location ?? '-'),
            columnWidths['location']!,
            rowPadding,
            isDark,
            color: const Color(0xFF4A5565),
            isMultiLine: filterType == ComponentType.department && (component.location?.contains('-') ?? false),
            fontSize: filterType == ComponentType.department ? 13.6.sp : 13.5.sp,
          ),
          _buildStatusCell(context, component.status, columnWidths['status']!, rowPadding, isDark, localizations),
          _buildLastUpdatedCell(context, component, columnWidths['lastUpdated']!, rowPadding, isDark, localizations),
          _buildActionsCell(context, component, columnWidths['actions']!, rowPadding, isDark, localizations),
        ],
      ),
    );
  }

  Widget _buildCell(
    BuildContext context,
    String text,
    double width,
    double padding,
    bool isDark, {
    FontWeight fontWeight = FontWeight.w400,
    double? fontSize,
    Color? color,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    bool isMultiLine = false,
  }) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final horizontalPadding = isMobile ? 12.w : (isTablet ? 16.w : 24.w);

    return Container(
      width: width.w,
      padding: EdgeInsetsDirectional.symmetric(horizontal: horizontalPadding, vertical: padding),
      child: isMultiLine
          ? Column(
              crossAxisAlignment: textAlign == TextAlign.end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: text.split('\n').map((line) {
                if (line.trim().isEmpty) return const SizedBox.shrink();
                return Text(
                  line,
                  style: TextStyle(
                    fontSize: fontSize ?? 13.6.sp,
                    fontWeight: fontWeight,
                    color: color ?? (isDark ? AppColors.textPrimaryDark : const Color(0xFF101828)),
                    height: 20 / (fontSize ?? 13.6),
                    letterSpacing: 0,
                  ),
                  textAlign: textAlign,
                  textDirection: textDirection,
                );
              }).toList(),
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: fontSize ?? 13.6.sp,
                fontWeight: fontWeight,
                color: color ?? (isDark ? AppColors.textPrimaryDark : const Color(0xFF101828)),
                height: 20 / (fontSize ?? 13.6),
                letterSpacing: 0,
              ),
              textAlign: textAlign,
              textDirection: textDirection,
            ),
    );
  }

  Widget _buildStatusCell(
    BuildContext context,
    bool isActive,
    double width,
    double padding,
    bool isDark,
    AppLocalizations localizations,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final horizontalPadding = isMobile ? 12.w : (isTablet ? 16.w : 24.w);

    final statusPadding = filterType == ComponentType.department
        ? EdgeInsetsDirectional.only(
            start: horizontalPadding,
            end: horizontalPadding,
            top: isMobile ? 20.h : (isTablet ? 26.h : 32.5.h),
            bottom: isMobile ? 18.h : (isTablet ? 24.h : 30.h),
          )
        : EdgeInsetsDirectional.symmetric(horizontal: horizontalPadding, vertical: padding);

    return Container(
      width: width.w,
      padding: statusPadding,
      child: CustomStatusCell(
        isActive: isActive,
        activeLabel: localizations.active,
        inactiveLabel: localizations.inactive,
      ),
    );
  }

  Widget _buildLastUpdatedCell(
    BuildContext context,
    ComponentValue component,
    double width,
    double padding,
    bool isDark,
    AppLocalizations localizations,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final horizontalPadding = isMobile ? 12.w : (isTablet ? 16.w : 24.w);
    final dateStr = _formatDate(component.updatedAt);
    final updatedBy = _getUpdatedBy(component);
    final isMultiLineUpdatedBy = filterType == ComponentType.department && updatedBy.contains('\n');
    final verticalPadding = filterType == ComponentType.department
        ? (isMobile ? 12.h : (isTablet ? 14.h : 16.h))
        : padding;

    return Container(
      width: width.w,
      padding: EdgeInsetsDirectional.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dateStr,
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 4.h),
          isMultiLineUpdatedBy
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: updatedBy.split('\n').map((line) {
                    return Text(
                      line,
                      style: TextStyle(
                        fontSize: 11.8.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
                        height: 16 / 11.8,
                        letterSpacing: 0,
                      ),
                    );
                  }).toList(),
                )
              : Text(
                  updatedBy,
                  style: TextStyle(
                    fontSize: 11.8.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
                    height: 16 / 11.8,
                    letterSpacing: 0,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildActionsCell(
    BuildContext context,
    ComponentValue component,
    double width,
    double padding,
    bool isDark,
    AppLocalizations localizations,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final horizontalPadding = isMobile ? 12.w : (isTablet ? 16.w : 24.w);
    final showDuplicate = filterType == ComponentType.department;
    final actionsTopPadding = filterType == ComponentType.department
        ? (isMobile ? 22.h : (isTablet ? 28.h : 34.25.h))
        : (isMobile ? 18.h : (isTablet ? 22.h : 26.25.h));

    return Container(
      width: width.w,
      padding: EdgeInsetsDirectional.only(start: horizontalPadding, end: 0, top: actionsTopPadding, bottom: padding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onView != null)
            _buildActionIconButton(
              context,
              'assets/icons/view_icon_blue.svg',
              AppColors.viewIconBlue,
              () => onView!(component),
              localizations.view,
            ),
          if (onView != null) SizedBox(width: 8.w),
          if (onEdit != null)
            _buildActionIconButton(
              context,
              'assets/icons/edit_icon_green.svg',
              AppColors.editIconGreen,
              () => onEdit!(component),
              localizations.edit,
            ),
          if (onEdit != null) SizedBox(width: 8.w),
          if (onDelete != null)
            _buildActionIconButton(
              context,
              'assets/icons/delete_icon_red.svg',
              AppColors.deleteIconRed,
              () => onDelete!(component),
              localizations.delete,
            ),
          if (showDuplicate && onDuplicate != null) ...[
            SizedBox(width: 8.w),
            _buildActionIconButton(
              context,
              'assets/icons/duplicate_icon.svg',
              isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
              () => onDuplicate!(component),
              localizations.duplicate,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionIconButton(
    BuildContext context,
    String iconPath,
    Color color,
    VoidCallback onTap,
    String tooltip,
  ) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: DigifyAsset(assetPath: iconPath, width: 16, height: 16, color: color),
        ),
      ),
    );
  }

  String _getParentName(ComponentValue component) {
    if (component.parentId == null) return '-';

    if (filterType == ComponentType.company && component.type == ComponentType.company) {
      final orgStructureId = int.tryParse(component.parentId ?? '');
      if (orgStructureId != null && orgStructures != null) {
        try {
          final structure = orgStructures!.firstWhere((s) => s.structureId == orgStructureId.toString());
          return '${structure.structureName} (${structure.structureCode})';
        } catch (e) {
          return '-';
        }
      }
      return '-';
    }

    final parent = allComponents.firstWhere(
      (c) => c.id == component.parentId,
      orElse: () => ComponentValue(
        id: '',
        code: '',
        name: '',
        arabicName: '',
        type: ComponentType.company,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    if (parent.id.isEmpty) {
      return '-';
    }

    switch (filterType) {
      case ComponentType.division:
        return '${parent.name} (${parent.code})';
      case ComponentType.businessUnit:
        return '${parent.name} (${parent.code})';
      case ComponentType.department:
        return '${parent.name}\n(${parent.code})';
      default:
        return parent.name;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getUpdatedBy(ComponentValue component) {
    switch (filterType) {
      case ComponentType.company:
        return 'by HR Admin';
      case ComponentType.division:
        return 'by HR Admin';
      case ComponentType.businessUnit:
        return 'by Finance Manager';
      case ComponentType.department:
        return 'by BU\nManager';
      default:
        return 'by HR Admin';
    }
  }

  String _formatName(String name) {
    if (filterType == ComponentType.department && name.contains(' ')) {
      final words = name.split(' ');
      if (words.length >= 2) {
        final mid = (words.length / 2).ceil();
        return '${words.take(mid).join(' ')}\n${words.skip(mid).join(' ')}';
      }
    }
    return name;
  }

  String _formatArabicName(String arabicName) {
    if (filterType == ComponentType.department && arabicName.contains(' ')) {
      final words = arabicName.split(' ');
      if (words.length >= 2) {
        final mid = (words.length / 2).ceil();
        return '${words.take(mid).join(' ')}\n${words.skip(mid).join(' ')}';
      }
    }
    return arabicName;
  }

  String _formatManagerName(String managerName) {
    if (filterType == ComponentType.company) {
      return managerName;
    }

    if (filterType == ComponentType.department && managerName.contains(' ')) {
      final words = managerName.split(' ');
      if (words.length >= 2) {
        return '${words.take(words.length - 1).join(' ')}\n${words.last}';
      }
    }
    return managerName;
  }

  String _formatLocation(String location) {
    if (filterType == ComponentType.department && location.contains(' - ')) {
      final parts = location.split(' - ');
      if (parts.length >= 2) {
        return '${parts.first} -\n${parts.skip(1).join(' - ')}';
      }
    }
    return location;
  }
}
