// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_user_localidad_get.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsuarioLocalidadesGet {
  @JsonKey(name: 'total_rows')
  int get totalRows;
  int get offset;
  List<RowsUserLocal> get rows;

  /// Create a copy of UsuarioLocalidadesGet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UsuarioLocalidadesGetCopyWith<UsuarioLocalidadesGet> get copyWith =>
      _$UsuarioLocalidadesGetCopyWithImpl<UsuarioLocalidadesGet>(
          this as UsuarioLocalidadesGet, _$identity);

  /// Serializes this UsuarioLocalidadesGet to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UsuarioLocalidadesGet &&
            (identical(other.totalRows, totalRows) ||
                other.totalRows == totalRows) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            const DeepCollectionEquality().equals(other.rows, rows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalRows, offset,
      const DeepCollectionEquality().hash(rows));

  @override
  String toString() {
    return 'UsuarioLocalidadesGet(totalRows: $totalRows, offset: $offset, rows: $rows)';
  }
}

/// @nodoc
abstract mixin class $UsuarioLocalidadesGetCopyWith<$Res> {
  factory $UsuarioLocalidadesGetCopyWith(UsuarioLocalidadesGet value,
          $Res Function(UsuarioLocalidadesGet) _then) =
      _$UsuarioLocalidadesGetCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_rows') int totalRows,
      int offset,
      List<RowsUserLocal> rows});
}

/// @nodoc
class _$UsuarioLocalidadesGetCopyWithImpl<$Res>
    implements $UsuarioLocalidadesGetCopyWith<$Res> {
  _$UsuarioLocalidadesGetCopyWithImpl(this._self, this._then);

  final UsuarioLocalidadesGet _self;
  final $Res Function(UsuarioLocalidadesGet) _then;

  /// Create a copy of UsuarioLocalidadesGet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRows = null,
    Object? offset = null,
    Object? rows = null,
  }) {
    return _then(_self.copyWith(
      totalRows: null == totalRows
          ? _self.totalRows
          : totalRows // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      rows: null == rows
          ? _self.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<RowsUserLocal>,
    ));
  }
}

/// Adds pattern-matching-related methods to [UsuarioLocalidadesGet].
extension UsuarioLocalidadesGetPatterns on UsuarioLocalidadesGet {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UsuarioLocalidadesGet value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidadesGet() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UsuarioLocalidadesGet value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidadesGet():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UsuarioLocalidadesGet value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidadesGet() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'total_rows') int totalRows, int offset,
            List<RowsUserLocal> rows)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidadesGet() when $default != null:
        return $default(_that.totalRows, _that.offset, _that.rows);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'total_rows') int totalRows, int offset,
            List<RowsUserLocal> rows)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidadesGet():
        return $default(_that.totalRows, _that.offset, _that.rows);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(@JsonKey(name: 'total_rows') int totalRows, int offset,
            List<RowsUserLocal> rows)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidadesGet() when $default != null:
        return $default(_that.totalRows, _that.offset, _that.rows);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UsuarioLocalidadesGet implements UsuarioLocalidadesGet {
  const _UsuarioLocalidadesGet(
      {@JsonKey(name: 'total_rows') required this.totalRows,
      required this.offset,
      required final List<RowsUserLocal> rows})
      : _rows = rows;
  factory _UsuarioLocalidadesGet.fromJson(Map<String, dynamic> json) =>
      _$UsuarioLocalidadesGetFromJson(json);

  @override
  @JsonKey(name: 'total_rows')
  final int totalRows;
  @override
  final int offset;
  final List<RowsUserLocal> _rows;
  @override
  List<RowsUserLocal> get rows {
    if (_rows is EqualUnmodifiableListView) return _rows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rows);
  }

  /// Create a copy of UsuarioLocalidadesGet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UsuarioLocalidadesGetCopyWith<_UsuarioLocalidadesGet> get copyWith =>
      __$UsuarioLocalidadesGetCopyWithImpl<_UsuarioLocalidadesGet>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UsuarioLocalidadesGetToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UsuarioLocalidadesGet &&
            (identical(other.totalRows, totalRows) ||
                other.totalRows == totalRows) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            const DeepCollectionEquality().equals(other._rows, _rows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalRows, offset,
      const DeepCollectionEquality().hash(_rows));

  @override
  String toString() {
    return 'UsuarioLocalidadesGet(totalRows: $totalRows, offset: $offset, rows: $rows)';
  }
}

/// @nodoc
abstract mixin class _$UsuarioLocalidadesGetCopyWith<$Res>
    implements $UsuarioLocalidadesGetCopyWith<$Res> {
  factory _$UsuarioLocalidadesGetCopyWith(_UsuarioLocalidadesGet value,
          $Res Function(_UsuarioLocalidadesGet) _then) =
      __$UsuarioLocalidadesGetCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_rows') int totalRows,
      int offset,
      List<RowsUserLocal> rows});
}

/// @nodoc
class __$UsuarioLocalidadesGetCopyWithImpl<$Res>
    implements _$UsuarioLocalidadesGetCopyWith<$Res> {
  __$UsuarioLocalidadesGetCopyWithImpl(this._self, this._then);

  final _UsuarioLocalidadesGet _self;
  final $Res Function(_UsuarioLocalidadesGet) _then;

  /// Create a copy of UsuarioLocalidadesGet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalRows = null,
    Object? offset = null,
    Object? rows = null,
  }) {
    return _then(_UsuarioLocalidadesGet(
      totalRows: null == totalRows
          ? _self.totalRows
          : totalRows // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      rows: null == rows
          ? _self._rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<RowsUserLocal>,
    ));
  }
}

/// @nodoc
mixin _$RowsUserLocal {
  String get id;
  String get key;
  UsuarioLocalidades get value;

  /// Create a copy of RowsUserLocal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RowsUserLocalCopyWith<RowsUserLocal> get copyWith =>
      _$RowsUserLocalCopyWithImpl<RowsUserLocal>(
          this as RowsUserLocal, _$identity);

  /// Serializes this RowsUserLocal to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RowsUserLocal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, key, value);

  @override
  String toString() {
    return 'RowsUserLocal(id: $id, key: $key, value: $value)';
  }
}

/// @nodoc
abstract mixin class $RowsUserLocalCopyWith<$Res> {
  factory $RowsUserLocalCopyWith(
          RowsUserLocal value, $Res Function(RowsUserLocal) _then) =
      _$RowsUserLocalCopyWithImpl;
  @useResult
  $Res call({String id, String key, UsuarioLocalidades value});

  $UsuarioLocalidadesCopyWith<$Res> get value;
}

/// @nodoc
class _$RowsUserLocalCopyWithImpl<$Res>
    implements $RowsUserLocalCopyWith<$Res> {
  _$RowsUserLocalCopyWithImpl(this._self, this._then);

  final RowsUserLocal _self;
  final $Res Function(RowsUserLocal) _then;

  /// Create a copy of RowsUserLocal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? value = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as UsuarioLocalidades,
    ));
  }

  /// Create a copy of RowsUserLocal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsuarioLocalidadesCopyWith<$Res> get value {
    return $UsuarioLocalidadesCopyWith<$Res>(_self.value, (value) {
      return _then(_self.copyWith(value: value));
    });
  }
}

/// Adds pattern-matching-related methods to [RowsUserLocal].
extension RowsUserLocalPatterns on RowsUserLocal {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RowsUserLocal value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowsUserLocal() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RowsUserLocal value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowsUserLocal():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RowsUserLocal value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowsUserLocal() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String key, UsuarioLocalidades value)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowsUserLocal() when $default != null:
        return $default(_that.id, _that.key, _that.value);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String key, UsuarioLocalidades value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowsUserLocal():
        return $default(_that.id, _that.key, _that.value);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String key, UsuarioLocalidades value)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowsUserLocal() when $default != null:
        return $default(_that.id, _that.key, _that.value);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RowsUserLocal implements RowsUserLocal {
  const _RowsUserLocal(
      {required this.id, required this.key, required this.value});
  factory _RowsUserLocal.fromJson(Map<String, dynamic> json) =>
      _$RowsUserLocalFromJson(json);

  @override
  final String id;
  @override
  final String key;
  @override
  final UsuarioLocalidades value;

  /// Create a copy of RowsUserLocal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RowsUserLocalCopyWith<_RowsUserLocal> get copyWith =>
      __$RowsUserLocalCopyWithImpl<_RowsUserLocal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RowsUserLocalToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RowsUserLocal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, key, value);

  @override
  String toString() {
    return 'RowsUserLocal(id: $id, key: $key, value: $value)';
  }
}

/// @nodoc
abstract mixin class _$RowsUserLocalCopyWith<$Res>
    implements $RowsUserLocalCopyWith<$Res> {
  factory _$RowsUserLocalCopyWith(
          _RowsUserLocal value, $Res Function(_RowsUserLocal) _then) =
      __$RowsUserLocalCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String key, UsuarioLocalidades value});

  @override
  $UsuarioLocalidadesCopyWith<$Res> get value;
}

/// @nodoc
class __$RowsUserLocalCopyWithImpl<$Res>
    implements _$RowsUserLocalCopyWith<$Res> {
  __$RowsUserLocalCopyWithImpl(this._self, this._then);

  final _RowsUserLocal _self;
  final $Res Function(_RowsUserLocal) _then;

  /// Create a copy of RowsUserLocal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? value = null,
  }) {
    return _then(_RowsUserLocal(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as UsuarioLocalidades,
    ));
  }

  /// Create a copy of RowsUserLocal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsuarioLocalidadesCopyWith<$Res> get value {
    return $UsuarioLocalidadesCopyWith<$Res>(_self.value, (value) {
      return _then(_self.copyWith(value: value));
    });
  }
}

// dart format on
