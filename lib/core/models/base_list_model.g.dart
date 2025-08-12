// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$BaseListModelToJson<T>(
  BaseListModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items?.map(toJsonT).toList(),
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
};

_$BaseListModelImpl<T> _$$BaseListModelImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _$BaseListModelImpl<T>(
  items: (json['items'] as List<dynamic>?)?.map(fromJsonT).toList(),
  page: (json['page'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  totalCount: (json['totalCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$$BaseListModelImplToJson<T>(
  _$BaseListModelImpl<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items?.map(toJsonT).toList(),
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
};
