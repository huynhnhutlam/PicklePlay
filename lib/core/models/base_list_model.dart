import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_list_model.freezed.dart';
part 'base_list_model.g.dart';

@Freezed(genericArgumentFactories: true)
@JsonSerializable(genericArgumentFactories: true)
class BaseListModel<T> with _$BaseListModel<T> {
  const factory BaseListModel({
    List<T>? items,
    int? page,
    int? pageSize,
    int? totalCount,
  }) = _BaseListModel<T>;

  factory BaseListModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => BaseListModel<T>(
    items: (json['items'] as List<dynamic>)
        .map((item) => fromJsonT(item))
        .toList(),
    page: json['page'] as int,
    pageSize: json['pageSize'] as int,
    totalCount: json['totalCount'] as int,
  );

  // toJson is not supported for generic types by default
}
