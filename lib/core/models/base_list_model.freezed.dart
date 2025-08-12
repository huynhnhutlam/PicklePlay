// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BaseListModel<T> _$BaseListModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object?) fromJsonT,
) {
  return _BaseListModel<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$BaseListModel<T> {
  List<T>? get items => throw _privateConstructorUsedError;
  int? get page => throw _privateConstructorUsedError;
  int? get pageSize => throw _privateConstructorUsedError;
  int? get totalCount => throw _privateConstructorUsedError;

  /// Serializes this BaseListModel to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of BaseListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseListModelCopyWith<T, BaseListModel<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseListModelCopyWith<T, $Res> {
  factory $BaseListModelCopyWith(
    BaseListModel<T> value,
    $Res Function(BaseListModel<T>) then,
  ) = _$BaseListModelCopyWithImpl<T, $Res, BaseListModel<T>>;
  @useResult
  $Res call({List<T>? items, int? page, int? pageSize, int? totalCount});
}

/// @nodoc
class _$BaseListModelCopyWithImpl<T, $Res, $Val extends BaseListModel<T>>
    implements $BaseListModelCopyWith<T, $Res> {
  _$BaseListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = freezed,
    Object? page = freezed,
    Object? pageSize = freezed,
    Object? totalCount = freezed,
  }) {
    return _then(
      _value.copyWith(
            items: freezed == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<T>?,
            page: freezed == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int?,
            pageSize: freezed == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalCount: freezed == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BaseListModelImplCopyWith<T, $Res>
    implements $BaseListModelCopyWith<T, $Res> {
  factory _$$BaseListModelImplCopyWith(
    _$BaseListModelImpl<T> value,
    $Res Function(_$BaseListModelImpl<T>) then,
  ) = __$$BaseListModelImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T>? items, int? page, int? pageSize, int? totalCount});
}

/// @nodoc
class __$$BaseListModelImplCopyWithImpl<T, $Res>
    extends _$BaseListModelCopyWithImpl<T, $Res, _$BaseListModelImpl<T>>
    implements _$$BaseListModelImplCopyWith<T, $Res> {
  __$$BaseListModelImplCopyWithImpl(
    _$BaseListModelImpl<T> _value,
    $Res Function(_$BaseListModelImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of BaseListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = freezed,
    Object? page = freezed,
    Object? pageSize = freezed,
    Object? totalCount = freezed,
  }) {
    return _then(
      _$BaseListModelImpl<T>(
        items: freezed == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<T>?,
        page: freezed == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int?,
        pageSize: freezed == pageSize
            ? _value.pageSize
            : pageSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalCount: freezed == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$BaseListModelImpl<T> implements _BaseListModel<T> {
  const _$BaseListModelImpl({
    final List<T>? items,
    this.page,
    this.pageSize,
    this.totalCount,
  }) : _items = items;

  factory _$BaseListModelImpl.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$$BaseListModelImplFromJson(json, fromJsonT);

  final List<T>? _items;
  @override
  List<T>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? page;
  @override
  final int? pageSize;
  @override
  final int? totalCount;

  @override
  String toString() {
    return 'BaseListModel<$T>(items: $items, page: $page, pageSize: $pageSize, totalCount: $totalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaseListModelImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    page,
    pageSize,
    totalCount,
  );

  /// Create a copy of BaseListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseListModelImplCopyWith<T, _$BaseListModelImpl<T>> get copyWith =>
      __$$BaseListModelImplCopyWithImpl<T, _$BaseListModelImpl<T>>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$BaseListModelImplToJson<T>(this, toJsonT);
  }
}

abstract class _BaseListModel<T> implements BaseListModel<T> {
  const factory _BaseListModel({
    final List<T>? items,
    final int? page,
    final int? pageSize,
    final int? totalCount,
  }) = _$BaseListModelImpl<T>;

  factory _BaseListModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) = _$BaseListModelImpl<T>.fromJson;

  @override
  List<T>? get items;
  @override
  int? get page;
  @override
  int? get pageSize;
  @override
  int? get totalCount;

  /// Create a copy of BaseListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseListModelImplCopyWith<T, _$BaseListModelImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
