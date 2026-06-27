import 'package:flutter/material.dart';
import 'package:grc/core/services/pagination_service.dart';

class PaginatedListView<T> extends StatefulWidget {
  final PaginationState<T> paginationState;
  final PaginationController<T> controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final double loadMoreThreshold;

  const PaginatedListView({
    super.key,
    required this.paginationState,
    required this.controller,
    required this.itemBuilder,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.loadMoreThreshold = 200.0,
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late ScrollController _scrollController;
  late PaginationScrollListener _scrollListener;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollListener = PaginationScrollListener(
      scrollController: _scrollController,
      onLoadMore: _loadMore,
      threshold: widget.loadMoreThreshold,
    );
  }

  @override
  void dispose() {
    _scrollListener.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() {
    if (widget.paginationState.hasNextPage &&
        !widget.paginationState.isLoadingMore) {
      widget.controller.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.paginationState;

    // Show loading for first page
    if (state.isLoading && state.items.isEmpty) {
      return widget.loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    // Show error if no items and has error
    if (state.hasError && state.items.isEmpty) {
      return widget.errorWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.errorMessage}'),
                ElevatedButton(
                  onPressed: () => widget.controller.refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
    }

    // Show empty state
    if (state.isEmpty) {
      return widget.emptyWidget ?? const Center(child: Text('No items found'));
    }

    // Show list with items
    return RefreshIndicator(
      onRefresh: () => widget.controller.refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: widget.padding,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        itemCount: state.items.length + (state.hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end
          if (index >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return widget.itemBuilder(context, state.items[index], index);
        },
      ),
    );
  }
}
