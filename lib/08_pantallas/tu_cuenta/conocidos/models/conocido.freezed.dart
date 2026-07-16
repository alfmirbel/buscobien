// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conocido.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Conocido {
  String get id;
  String get solicitanteId;
  String get solicitanteNombre;
  String get receptorId;
  String get receptorNombre;
  InvitacionEstado get estado;
  DateTime get fechaActualizacion;

  /// Create a copy of Conocido
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConocidoCopyWith<Conocido> get copyWith =>
      _$ConocidoCopyWithImpl<Conocido>(this as Conocido, _$identity);

  /// Serializes this Conocido to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Conocido &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.solicitanteId, solicitanteId) ||
                other.solicitanteId == solicitanteId) &&
            (identical(other.solicitanteNombre, solicitanteNombre) ||
                other.solicitanteNombre == solicitanteNombre) &&
            (identical(other.receptorId, receptorId) ||
                other.receptorId == receptorId) &&
            (identical(other.receptorNombre, receptorNombre) ||
                other.receptorNombre == receptorNombre) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.fechaActualizacion, fechaActualizacion) ||
                other.fechaActualizacion == fechaActualizacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      solicitanteId,
      solicitanteNombre,
      receptorId,
      receptorNombre,
      estado,
      fechaActualizacion);

  @override
  String toString() {
    return 'Conocido(id: $id, solicitanteId: $solicitanteId, solicitanteNombre: $solicitanteNombre, receptorId: $receptorId, receptorNombre: $receptorNombre, estado: $estado, fechaActualizacion: $fechaActualizacion)';
  }
}

/// @nodoc
abstract mixin class $ConocidoCopyWith<$Res> {
  factory $ConocidoCopyWith(Conocido value, $Res Function(Conocido) _then) =
      _$ConocidoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String solicitanteId,
      String solicitanteNombre,
      String receptorId,
      String receptorNombre,
      InvitacionEstado estado,
      DateTime fechaActualizacion});
}

/// @nodoc
class _$ConocidoCopyWithImpl<$Res> implements $ConocidoCopyWith<$Res> {
  _$ConocidoCopyWithImpl(this._self, this._then);

  final Conocido _self;
  final $Res Function(Conocido) _then;

  /// Create a copy of Conocido
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? solicitanteId = null,
    Object? solicitanteNombre = null,
    Object? receptorId = null,
    Object? receptorNombre = null,
    Object? estado = null,
    Object? fechaActualizacion = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      solicitanteId: null == solicitanteId
          ? _self.solicitanteId
          : solicitanteId // ignore: cast_nullable_to_non_nullable
              as String,
      solicitanteNombre: null == solicitanteNombre
          ? _self.solicitanteNombre
          : solicitanteNombre // ignore: cast_nullable_to_non_nullable
              as String,
      receptorId: null == receptorId
          ? _self.receptorId
          : receptorId // ignore: cast_nullable_to_non_nullable
              as String,
      receptorNombre: null == receptorNombre
          ? _self.receptorNombre
          : receptorNombre // ignore: cast_nullable_to_non_nullable
              as String,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as InvitacionEstado,
      fechaActualizacion: null == fechaActualizacion
          ? _self.fechaActualizacion
          : fechaActualizacion // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [Conocido].
extension ConocidoPatterns on Conocido {
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
    TResult Function(_Conocido value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Conocido() when $default != null:
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
    TResult Function(_Conocido value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conocido():
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
    TResult? Function(_Conocido value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conocido() when $default != null:
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
    TResult Function(
            String id,
            String solicitanteId,
            String solicitanteNombre,
            String receptorId,
            String receptorNombre,
            InvitacionEstado estado,
            DateTime fechaActualizacion)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Conocido() when $default != null:
        return $default(
            _that.id,
            _that.solicitanteId,
            _that.solicitanteNombre,
            _that.receptorId,
            _that.receptorNombre,
            _that.estado,
            _that.fechaActualizacion);
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
    TResult Function(
            String id,
            String solicitanteId,
            String solicitanteNombre,
            String receptorId,
            String receptorNombre,
            InvitacionEstado estado,
            DateTime fechaActualizacion)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conocido():
        return $default(
            _that.id,
            _that.solicitanteId,
            _that.solicitanteNombre,
            _that.receptorId,
            _that.receptorNombre,
            _that.estado,
            _that.fechaActualizacion);
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
    TResult? Function(
            String id,
            String solicitanteId,
            String solicitanteNombre,
            String receptorId,
            String receptorNombre,
            InvitacionEstado estado,
            DateTime fechaActualizacion)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conocido() when $default != null:
        return $default(
            _that.id,
            _that.solicitanteId,
            _that.solicitanteNombre,
            _that.receptorId,
            _that.receptorNombre,
            _that.estado,
            _that.fechaActualizacion);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Conocido implements Conocido {
  const _Conocido(
      {required this.id,
      required this.solicitanteId,
      this.solicitanteNombre = '',
      required this.receptorId,
      this.receptorNombre = '',
      this.estado = InvitacionEstado.pendiente,
      required this.fechaActualizacion});
  factory _Conocido.fromJson(Map<String, dynamic> json) =>
      _$ConocidoFromJson(json);

  @override
  final String id;
  @override
  final String solicitanteId;
  @override
  @JsonKey()
  final String solicitanteNombre;
  @override
  final String receptorId;
  @override
  @JsonKey()
  final String receptorNombre;
  @override
  @JsonKey()
  final InvitacionEstado estado;
  @override
  final DateTime fechaActualizacion;

  /// Create a copy of Conocido
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConocidoCopyWith<_Conocido> get copyWith =>
      __$ConocidoCopyWithImpl<_Conocido>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConocidoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Conocido &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.solicitanteId, solicitanteId) ||
                other.solicitanteId == solicitanteId) &&
            (identical(other.solicitanteNombre, solicitanteNombre) ||
                other.solicitanteNombre == solicitanteNombre) &&
            (identical(other.receptorId, receptorId) ||
                other.receptorId == receptorId) &&
            (identical(other.receptorNombre, receptorNombre) ||
                other.receptorNombre == receptorNombre) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.fechaActualizacion, fechaActualizacion) ||
                other.fechaActualizacion == fechaActualizacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      solicitanteId,
      solicitanteNombre,
      receptorId,
      receptorNombre,
      estado,
      fechaActualizacion);

  @override
  String toString() {
    return 'Conocido(id: $id, solicitanteId: $solicitanteId, solicitanteNombre: $solicitanteNombre, receptorId: $receptorId, receptorNombre: $receptorNombre, estado: $estado, fechaActualizacion: $fechaActualizacion)';
  }
}

/// @nodoc
abstract mixin class _$ConocidoCopyWith<$Res>
    implements $ConocidoCopyWith<$Res> {
  factory _$ConocidoCopyWith(_Conocido value, $Res Function(_Conocido) _then) =
      __$ConocidoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String solicitanteId,
      String solicitanteNombre,
      String receptorId,
      String receptorNombre,
      InvitacionEstado estado,
      DateTime fechaActualizacion});
}

/// @nodoc
class __$ConocidoCopyWithImpl<$Res> implements _$ConocidoCopyWith<$Res> {
  __$ConocidoCopyWithImpl(this._self, this._then);

  final _Conocido _self;
  final $Res Function(_Conocido) _then;

  /// Create a copy of Conocido
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? solicitanteId = null,
    Object? solicitanteNombre = null,
    Object? receptorId = null,
    Object? receptorNombre = null,
    Object? estado = null,
    Object? fechaActualizacion = null,
  }) {
    return _then(_Conocido(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      solicitanteId: null == solicitanteId
          ? _self.solicitanteId
          : solicitanteId // ignore: cast_nullable_to_non_nullable
              as String,
      solicitanteNombre: null == solicitanteNombre
          ? _self.solicitanteNombre
          : solicitanteNombre // ignore: cast_nullable_to_non_nullable
              as String,
      receptorId: null == receptorId
          ? _self.receptorId
          : receptorId // ignore: cast_nullable_to_non_nullable
              as String,
      receptorNombre: null == receptorNombre
          ? _self.receptorNombre
          : receptorNombre // ignore: cast_nullable_to_non_nullable
              as String,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as InvitacionEstado,
      fechaActualizacion: null == fechaActualizacion
          ? _self.fechaActualizacion
          : fechaActualizacion // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
