import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide RefreshCallback;
import 'package:pickle_app/core/base/blocs/loadmore/base_loadmore_state.dart';
import 'package:pickle_app/core/widget/loading/list_loading.dart';

class LoadMoreListView<T> extends StatefulWidget {
  final LoadMoreState<T> state;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;
  final RefreshCallback? onRefresh;
  final String? emptyText;
  final Widget? loadingWidgetBuilder;

  const LoadMoreListView({
    super.key,
    required this.state,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.onRetry,
    this.emptyText,
    this.onRefresh,
    this.loadingWidgetBuilder,
  });

  @override
  State<LoadMoreListView<T>> createState() => _LoadMoreListViewState<T>();
}

class _LoadMoreListViewState<T> extends State<LoadMoreListView<T>> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_onScroll);
  }

  // Scroll listener
  // to load more data when the user reaches the bottom of the list
  // is the threshold
  // to ensure that the user has reached the bottom of the list
  // before loading more data
  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 300) {
      if (widget.state is LoadMoreLoaded<T> &&
          !(widget.state as LoadMoreLoaded<T>).hasReachedMax) {
        widget.onLoadMore();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state is LoadMoreInitial<T> ||
        widget.state is LoadMoreLoading<T>) {
      return widget.loadingWidgetBuilder ?? ListLoading();
    }
    if (widget.state is LoadMoreError<T>) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text((widget.state as LoadMoreError<T>).message),
            ElevatedButton(
              onPressed: widget.onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (widget.state is LoadMoreLoaded<T>) {
      final loadedState = widget.state as LoadMoreLoaded<T>;
      final items = loadedState.items;
      if (items.isEmpty) {
        return _buildEmptyState();
      }
      return widget.onRefresh == null
          ? _listViewBuilder(items, loadedState.hasReachedMax)
          : RefreshIndicator.adaptive(
              onRefresh: widget.onRefresh!,
              child: _listViewBuilder(items, loadedState.hasReachedMax),
            );
    }
    return const SizedBox.shrink();
  }

  Widget _listViewBuilder(List<T> items, bool hasReachedMax) {
    return ListView.builder(
      controller: _controller,
      itemCount: items.length + 1,
      addAutomaticKeepAlives: false,
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemBuilder: (context, index) {
        if (index == items.length) {
          if (hasReachedMax) {
            return SizedBox.shrink();
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        }
        return widget.itemBuilder(context, items[index], index);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Color(0xFFD0E4FF)),
          Text('No data found'),
          Text(widget.emptyText ?? 'No global account list available'),
        ],
      ),
    );
  }
}
