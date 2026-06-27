import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/enums/overtime_status.dart';
import 'overtime_record.dart';

enum OvertimeCategory {
  all('All Staff'),
  myOvertime('My Overtime'),
  myTeam("My Team");

  final String name;
  const OvertimeCategory(this.name);
}

class OvertimeStat {
  final String title;
  final String subTitle;
  final String value;
  final String icon;
  final Color? iconBackground;
  final Color? iconColor;

  OvertimeStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.subTitle,
    this.iconBackground = AppColors.infoBg,
    this.iconColor = AppColors.statIconBlue,
  });

  OvertimeStat copyWith({
    String? title,
    String? subTitle,
    String? value,
    String? icon,
    Color? iconBackground,
    Color? iconColor,
  }) {
    return OvertimeStat(
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      value: value ?? this.value,
      icon: icon ?? this.icon,
      iconBackground: iconBackground ?? this.iconBackground,
      iconColor: iconColor ?? this.iconColor,
    );
  }
}

class OvertimeManagement {
  OvertimeCategory? selectedCategory;
  List<OvertimeCategory>? categories;
  List<OvertimeStat>? stats;
  List<OvertimeRecord>? records;
  String? expandedRecord;
  OvertimeStatus? selectedStatus;
  String? companyId;
  String? orgUnitId;
  String? orgLevelCode;
  bool isLoading;
  bool clearError;
  String? error;
  int currentPage;
  int pageSize;
  int totalItems;
  bool hasMore;
  String? searchQuery;
  String? approvingOvertimeGuid;
  String? rejectingOvertimeGuid;
  String? cancelingOvertimeGuid;

  OvertimeManagement({
    this.selectedCategory,
    this.categories,
    this.stats,
    this.records,
    this.selectedStatus,
    this.companyId,
    this.orgUnitId,
    this.orgLevelCode,
    this.isLoading = false,
    this.clearError = true,
    this.error,
    this.expandedRecord,
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
    this.hasMore = false,
    this.searchQuery,
    this.approvingOvertimeGuid,
    this.rejectingOvertimeGuid,
    this.cancelingOvertimeGuid,
  });

  OvertimeManagement copyWith({
    OvertimeCategory? selectedCategory,
    List<OvertimeCategory>? categories,
    List<OvertimeStat>? stats,
    List<OvertimeRecord>? records,
    OvertimeStatus? selectedStatus,
    bool clearStatus = false,
    String? companyId,
    String? orgUnitId,
    String? orgLevelCode,
    bool clearOrgFilter = false,
    bool? isLoading,
    bool? clearError,
    String? error,
    String? expandedRecord,
    bool clearExpandedRecord = false,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    bool? hasMore,
    String? searchQuery,
    bool clearSearchQuery = false,
    String? approvingOvertimeGuid,
    String? rejectingOvertimeGuid,
    String? cancelingOvertimeGuid,
    bool clearApprovingOvertimeGuid = false,
    bool clearRejectingOvertimeGuid = false,
    bool clearCancelingOvertimeGuid = false,
  }) {
    return OvertimeManagement(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      stats: stats ?? this.stats,
      records: records ?? this.records,
      selectedStatus: clearStatus ? null : (selectedStatus ?? this.selectedStatus),
      companyId: companyId ?? this.companyId,
      orgUnitId: clearOrgFilter ? null : (orgUnitId ?? this.orgUnitId),
      orgLevelCode: clearOrgFilter ? null : (orgLevelCode ?? this.orgLevelCode),
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      error: error ?? this.error,
      expandedRecord: clearExpandedRecord ? null : (expandedRecord ?? this.expandedRecord),
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      approvingOvertimeGuid: clearApprovingOvertimeGuid ? null : (approvingOvertimeGuid ?? this.approvingOvertimeGuid),
      rejectingOvertimeGuid: clearRejectingOvertimeGuid ? null : (rejectingOvertimeGuid ?? this.rejectingOvertimeGuid),
      cancelingOvertimeGuid: clearCancelingOvertimeGuid ? null : (cancelingOvertimeGuid ?? this.cancelingOvertimeGuid),
    );
  }
}
