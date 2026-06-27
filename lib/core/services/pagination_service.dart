import 'package:grc/core/enums/position_status.dart';
import 'package:flutter/material.dart';

/// Generic pagination state
class PaginationState<T> {
  final List<T> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String? errorMessage;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? searchQuery;
  final PositionStatus? status;

  const PaginationState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage,
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
    this.totalPages = 0,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.searchQuery,
    this.status,
  });

  PaginationState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    String? errorMessage,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    String? searchQuery,
    PositionStatus? status,
    bool clearStatus = false,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      searchQuery: searchQuery ?? this.searchQuery,
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  bool get isEmpty => items.isEmpty && !isLoading;
  bool get isNotEmpty => items.isNotEmpty;
}

/// Pagination scroll listener service
class PaginationScrollListener {
  final ScrollController scrollController;
  final VoidCallback onLoadMore;
  final double threshold;

  PaginationScrollListener({
    required this.scrollController,
    required this.onLoadMore,
    this.threshold = 200.0, // Trigger when 200px from bottom
  }) {
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - threshold) {
      onLoadMore();
    }
  }

  void dispose() {
    scrollController.removeListener(_scrollListener);
  }
}

/// Generic pagination controller
abstract class PaginationController<T> {
  PaginationState<T> get state;

  Future<void> loadFirstPage();
  Future<void> loadNextPage();
  Future<void> refresh();
  void reset();
}

/// Pagination helper mixin
mixin PaginationMixin<T> {
  PaginationState<T> handleLoadingState(PaginationState<T> currentState, bool isFirstPage) {
    return currentState.copyWith(
      isLoading: isFirstPage,
      isLoadingMore: !isFirstPage,
      hasError: false,
      errorMessage: null,
    );
  }

  PaginationState<T> handleSuccessState<R>({
    required PaginationState<T> currentState,
    required List<T> newItems,
    required int currentPage,
    required int pageSize,
    required int totalItems,
    required int totalPages,
    required bool hasNextPage,
    required bool hasPreviousPage,
    required bool isFirstPage,
  }) {
    final updatedItems = isFirstPage ? newItems : [...currentState.items, ...newItems];

    return currentState.copyWith(
      items: updatedItems,
      isLoading: false,
      isLoadingMore: false,
      hasError: false,
      errorMessage: null,
      currentPage: currentPage,
      pageSize: pageSize,
      totalItems: totalItems,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
      hasPreviousPage: hasPreviousPage,
    );
  }

  PaginationState<T> handleErrorState(PaginationState<T> currentState, String error) {
    return currentState.copyWith(isLoading: false, isLoadingMore: false, hasError: true, errorMessage: error);
  }
}
