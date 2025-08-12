class LoadMoreParams {
  final int perPage;
  final int page;
  final Map<String, dynamic> filters;

  LoadMoreParams({
    required this.page,
    required this.perPage,
    this.filters = const {},
  });

  LoadMoreParams copyWith({
    int? page,
    int? perPage,
    Map<String, dynamic>? filters,
  }) {
    return LoadMoreParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      filters: filters ?? this.filters,
    );
  }
}
