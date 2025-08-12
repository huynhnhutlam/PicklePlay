// core/base/loadmore/loadmore_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/base/blocs/loadmore/base_loadmore_state.dart';
import 'package:pickle_app/core/base/blocs/loadmore/loadmore_params.dart';
import 'package:pickle_app/core/error/failures.dart';

abstract class LoadMoreCubit<T> extends Cubit<LoadMoreState<T>> {
  final int pageSize;

  LoadMoreParams _params;
  bool _isFetching = false;
  bool _hasReachedMax = false;
  bool _isLoading = true;
  List<T> _items = [];

  LoadMoreCubit({this.pageSize = 20})
    : _params = LoadMoreParams(page: 1, perPage: pageSize),
      super(LoadMoreInitial<T>());

  // Fetches the page of items from the data source.
  Future<Either<Failure, List<T>>> fetchPage(LoadMoreParams params);

  // Fetches the first page of items from the data source.
  void fetchFirstPage({Map<String, dynamic>? filters}) async {
    if (_isFetching) return;
    if (_isLoading) emit(LoadMoreLoading<T>());
    _params = LoadMoreParams(
      page: 1,
      perPage: pageSize,
      filters: filters ?? {},
    );
    _hasReachedMax = false;
    _items = [];
    await _fetch();
  }

  // Fetches the next page of items from the data source.
  // This method should be called from the fetchNextPage method.
  void fetchNextPage() async {
    if (_isFetching || _hasReachedMax) return;
    _params = _params.copyWith(page: _params.page + 1);
    await _fetch();
  }

  // Fetches data and emits the result.
  // This method should be called from the fetchPage method.
  // If the result is a failure, it emits the error state.
  // If the result is a success, it emits the loaded state.
  Future<void> _fetch() async {
    _isFetching = true;
    final result = await fetchPage(_params);
    if (isClosed) return;
    result.fold((failure) => emit(LoadMoreError<T>(failure.message)), (items) {
      if (_params.page == 1) _items = [];
      _items.addAll(items);
      _hasReachedMax = items.length < pageSize;
      emit(
        LoadMoreLoaded<T>(
          items: List<T>.from(_items),
          hasReachedMax: _hasReachedMax,
        ),
      );
    });
    _isFetching = false;
  }

  // Refreshes the data by fetching the first page again.
  // This method should be called when the user refreshes the data.
  void refresh() {
    fetchFirstPage(filters: _params.filters);
  }

  // Applies a filter to the data and fetches the first page again.
  // This method should be called when the user applies a filter.
  void applyFilter(Map<String, dynamic> filters, {bool isLoading = true}) {
    _isLoading = isLoading;
    fetchFirstPage(filters: filters);
  }
}
