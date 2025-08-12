import 'package:equatable/equatable.dart';

abstract class LoadMoreState<T> extends Equatable {
  const LoadMoreState();

  @override
  List<Object?> get props => [];
}

class LoadMoreInitial<T> extends LoadMoreState<T> {}

class LoadMoreLoading<T> extends LoadMoreState<T> {}

class LoadMoreLoaded<T> extends LoadMoreState<T> {
  final List<T> items;
  final bool hasReachedMax;

  const LoadMoreLoaded({required this.items, required this.hasReachedMax});

  LoadMoreLoaded<T> copyWith({List<T>? items, bool? hasReachedMax}) {
    return LoadMoreLoaded<T>(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [items, hasReachedMax];
}

class LoadMoreError<T> extends LoadMoreState<T> {
  final String message;

  const LoadMoreError(this.message);

  @override
  List<Object?> get props => [message];
}
