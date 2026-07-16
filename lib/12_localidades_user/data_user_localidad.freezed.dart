// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_user_localidad.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsuarioLocalidades {
  @JsonKey(name: 'id_codigopostal')
  String get idCodigopostal;
  @JsonKey(name: 'id_usuario')
  String get idUsuario;
  String get pais;
  @JsonKey(name: 'localidadesCp')
  LocalidadCp get localidadCp;
  String get calle;
  String get seccionine;
  String get latitud;
  String get longitud;
  String get latDecimal;
  String get lonDecimal;
  String get timestamp;

  /// Create a copy of UsuarioLocalidades
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UsuarioLocalidadesCopyWith<UsuarioLocalidades> get copyWith =>
      _$UsuarioLocalidadesCopyWithImpl<UsuarioLocalidades>(
          this as UsuarioLocalidades, _$identity);

  /// Serializes this UsuarioLocalidades to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UsuarioLocalidades &&
            (identical(other.idCodigopostal, idCodigopostal) ||
                other.idCodigopostal == idCodigopostal) &&
            (identical(other.idUsuario, idUsuario) ||
                other.idUsuario == idUsuario) &&
            (identical(other.pais, pais) || other.pais == pais) &&
            (identical(other.localidadCp, localidadCp) ||
                other.localidadCp == localidadCp) &&
            (identical(other.calle, calle) || other.calle == calle) &&
            (identical(other.seccionine, seccionine) ||
                other.seccionine == seccionine) &&
            (identical(other.latitud, latitud) || other.latitud == latitud) &&
            (identical(other.longitud, longitud) ||
                other.longitud == longitud) &&
            (identical(other.latDecimal, latDecimal) ||
                other.latDecimal == latDecimal) &&
            (identical(other.lonDecimal, lonDecimal) ||
                other.lonDecimal == lonDecimal) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      idCodigopostal,
      idUsuario,
      pais,
      localidadCp,
      calle,
      seccionine,
      latitud,
      longitud,
      latDecimal,
      lonDecimal,
      timestamp);

  @override
  String toString() {
    return 'UsuarioLocalidades(idCodigopostal: $idCodigopostal, idUsuario: $idUsuario, pais: $pais, localidadCp: $localidadCp, calle: $calle, seccionine: $seccionine, latitud: $latitud, longitud: $longitud, latDecimal: $latDecimal, lonDecimal: $lonDecimal, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class $UsuarioLocalidadesCopyWith<$Res> {
  factory $UsuarioLocalidadesCopyWith(
          UsuarioLocalidades value, $Res Function(UsuarioLocalidades) _then) =
      _$UsuarioLocalidadesCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id_codigopostal') String idCodigopostal,
      @JsonKey(name: 'id_usuario') String idUsuario,
      String pais,
      @JsonKey(name: 'localidadesCp') LocalidadCp localidadCp,
      String calle,
      String seccionine,
      String latitud,
      String longitud,
      String latDecimal,
      String lonDecimal,
      String timestamp});

  $LocalidadCpCopyWith<$Res> get localidadCp;
}

/// @nodoc
class _$UsuarioLocalidadesCopyWithImpl<$Res>
    implements $UsuarioLocalidadesCopyWith<$Res> {
  _$UsuarioLocalidadesCopyWithImpl(this._self, this._then);

  final UsuarioLocalidades _self;
  final $Res Function(UsuarioLocalidades) _then;

  /// Create a copy of UsuarioLocalidades
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idCodigopostal = null,
    Object? idUsuario = null,
    Object? pais = null,
    Object? localidadCp = null,
    Object? calle = null,
    Object? seccionine = null,
    Object? latitud = null,
    Object? longitud = null,
    Object? latDecimal = null,
    Object? lonDecimal = null,
    Object? timestamp = null,
  }) {
    return _then(_self.copyWith(
      idCodigopostal: null == idCodigopostal
          ? _self.idCodigopostal
          : idCodigopostal // ignore: cast_nullable_to_non_nullable
              as String,
      idUsuario: null == idUsuario
          ? _self.idUsuario
          : idUsuario // ignore: cast_nullable_to_non_nullable
              as String,
      pais: null == pais
          ? _self.pais
          : pais // ignore: cast_nullable_to_non_nullable
              as String,
      localidadCp: null == localidadCp
          ? _self.localidadCp
          : localidadCp // ignore: cast_nullable_to_non_nullable
              as LocalidadCp,
      calle: null == calle
          ? _self.calle
          : calle // ignore: cast_nullable_to_non_nullable
              as String,
      seccionine: null == seccionine
          ? _self.seccionine
          : seccionine // ignore: cast_nullable_to_non_nullable
              as String,
      latitud: null == latitud
          ? _self.latitud
          : latitud // ignore: cast_nullable_to_non_nullable
              as String,
      longitud: null == longitud
          ? _self.longitud
          : longitud // ignore: cast_nullable_to_non_nullable
              as String,
      latDecimal: null == latDecimal
          ? _self.latDecimal
          : latDecimal // ignore: cast_nullable_to_non_nullable
              as String,
      lonDecimal: null == lonDecimal
          ? _self.lonDecimal
          : lonDecimal // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of UsuarioLocalidades
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocalidadCpCopyWith<$Res> get localidadCp {
    return $LocalidadCpCopyWith<$Res>(_self.localidadCp, (value) {
      return _then(_self.copyWith(localidadCp: value));
    });
  }
}

/// Adds pattern-matching-related methods to [UsuarioLocalidades].
extension UsuarioLocalidadesPatterns on UsuarioLocalidades {
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
    TResult Function(_UsuarioLocalidades value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidades() when $default != null:
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
    TResult Function(_UsuarioLocalidades value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidades():
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
    TResult? Function(_UsuarioLocalidades value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidades() when $default != null:
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
            @JsonKey(name: 'id_codigopostal') String idCodigopostal,
            @JsonKey(name: 'id_usuario') String idUsuario,
            String pais,
            @JsonKey(name: 'localidadesCp') LocalidadCp localidadCp,
            String calle,
            String seccionine,
            String latitud,
            String longitud,
            String latDecimal,
            String lonDecimal,
            String timestamp)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidades() when $default != null:
        return $default(
            _that.idCodigopostal,
            _that.idUsuario,
            _that.pais,
            _that.localidadCp,
            _that.calle,
            _that.seccionine,
            _that.latitud,
            _that.longitud,
            _that.latDecimal,
            _that.lonDecimal,
            _that.timestamp);
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
            @JsonKey(name: 'id_codigopostal') String idCodigopostal,
            @JsonKey(name: 'id_usuario') String idUsuario,
            String pais,
            @JsonKey(name: 'localidadesCp') LocalidadCp localidadCp,
            String calle,
            String seccionine,
            String latitud,
            String longitud,
            String latDecimal,
            String lonDecimal,
            String timestamp)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidades():
        return $default(
            _that.idCodigopostal,
            _that.idUsuario,
            _that.pais,
            _that.localidadCp,
            _that.calle,
            _that.seccionine,
            _that.latitud,
            _that.longitud,
            _that.latDecimal,
            _that.lonDecimal,
            _that.timestamp);
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
            @JsonKey(name: 'id_codigopostal') String idCodigopostal,
            @JsonKey(name: 'id_usuario') String idUsuario,
            String pais,
            @JsonKey(name: 'localidadesCp') LocalidadCp localidadCp,
            String calle,
            String seccionine,
            String latitud,
            String longitud,
            String latDecimal,
            String lonDecimal,
            String timestamp)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioLocalidades() when $default != null:
        return $default(
            _that.idCodigopostal,
            _that.idUsuario,
            _that.pais,
            _that.localidadCp,
            _that.calle,
            _that.seccionine,
            _that.latitud,
            _that.longitud,
            _that.latDecimal,
            _that.lonDecimal,
            _that.timestamp);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UsuarioLocalidades implements UsuarioLocalidades {
  const _UsuarioLocalidades(
      {@JsonKey(name: 'id_codigopostal') required this.idCodigopostal,
      @JsonKey(name: 'id_usuario') required this.idUsuario,
      this.pais = 'México',
      @JsonKey(name: 'localidadesCp') required this.localidadCp,
      this.calle = '',
      this.seccionine = '',
      this.latitud = '',
      this.longitud = '',
      this.latDecimal = '',
      this.lonDecimal = '',
      this.timestamp = ''});
  factory _UsuarioLocalidades.fromJson(Map<String, dynamic> json) =>
      _$UsuarioLocalidadesFromJson(json);

  @override
  @JsonKey(name: 'id_codigopostal')
  final String idCodigopostal;
  @override
  @JsonKey(name: 'id_usuario')
  final String idUsuario;
  @override
  @JsonKey()
  final String pais;
  @override
  @JsonKey(name: 'localidadesCp')
  final LocalidadCp localidadCp;
  @override
  @JsonKey()
  final String calle;
  @override
  @JsonKey()
  final String seccionine;
  @override
  @JsonKey()
  final String latitud;
  @override
  @JsonKey()
  final String longitud;
  @override
  @JsonKey()
  final String latDecimal;
  @override
  @JsonKey()
  final String lonDecimal;
  @override
  @JsonKey()
  final String timestamp;

  /// Create a copy of UsuarioLocalidades
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UsuarioLocalidadesCopyWith<_UsuarioLocalidades> get copyWith =>
      __$UsuarioLocalidadesCopyWithImpl<_UsuarioLocalidades>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UsuarioLocalidadesToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UsuarioLocalidades &&
            (identical(other.idCodigopostal, idCodigopostal) ||
                other.idCodigopostal == idCodigopostal) &&
            (identical(other.idUsuario, idUsuario) ||
                other.idUsuario == idUsuario) &&
            (identical(other.pais, pais) || other.pais == pais) &&
            (identical(other.localidadCp, localidadCp) ||
                other.localidadCp == localidadCp) &&
            (identical(other.calle, calle) || other.calle == calle) &&
            (identical(other.seccionine, seccionine) ||
                other.seccionine == seccionine) &&
            (identical(other.latitud, latitud) || other.latitud == latitud) &&
            (identical(other.longitud, longitud) ||
                other.longitud == longitud) &&
            (identical(other.latDecimal, latDecimal) ||
                other.latDecimal == latDecimal) &&
            (identical(other.lonDecimal, lonDecimal) ||
                other.lonDecimal == lonDecimal) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      idCodigopostal,
      idUsuario,
      pais,
      localidadCp,
      calle,
      seccionine,
      latitud,
      longitud,
      latDecimal,
      lonDecimal,
      timestamp);

  @override
  String toString() {
    return 'UsuarioLocalidades(idCodigopostal: $idCodigopostal, idUsuario: $idUsuario, pais: $pais, localidadCp: $localidadCp, calle: $calle, seccionine: $seccionine, latitud: $latitud, longitud: $longitud, latDecimal: $latDecimal, lonDecimal: $lonDecimal, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class _$UsuarioLocalidadesCopyWith<$Res>
    implements $UsuarioLocalidadesCopyWith<$Res> {
  factory _$UsuarioLocalidadesCopyWith(
          _UsuarioLocalidades value, $Res Function(_UsuarioLocalidades) _then) =
      __$UsuarioLocalidadesCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id_codigopostal') String idCodigopostal,
      @JsonKey(name: 'id_usuario') String idUsuario,
      String pais,
      @JsonKey(name: 'localidadesCp') LocalidadCp localidadCp,
      String calle,
      String seccionine,
      String latitud,
      String longitud,
      String latDecimal,
      String lonDecimal,
      String timestamp});

  @override
  $LocalidadCpCopyWith<$Res> get localidadCp;
}

/// @nodoc
class __$UsuarioLocalidadesCopyWithImpl<$Res>
    implements _$UsuarioLocalidadesCopyWith<$Res> {
  __$UsuarioLocalidadesCopyWithImpl(this._self, this._then);

  final _UsuarioLocalidades _self;
  final $Res Function(_UsuarioLocalidades) _then;

  /// Create a copy of UsuarioLocalidades
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? idCodigopostal = null,
    Object? idUsuario = null,
    Object? pais = null,
    Object? localidadCp = null,
    Object? calle = null,
    Object? seccionine = null,
    Object? latitud = null,
    Object? longitud = null,
    Object? latDecimal = null,
    Object? lonDecimal = null,
    Object? timestamp = null,
  }) {
    return _then(_UsuarioLocalidades(
      idCodigopostal: null == idCodigopostal
          ? _self.idCodigopostal
          : idCodigopostal // ignore: cast_nullable_to_non_nullable
              as String,
      idUsuario: null == idUsuario
          ? _self.idUsuario
          : idUsuario // ignore: cast_nullable_to_non_nullable
              as String,
      pais: null == pais
          ? _self.pais
          : pais // ignore: cast_nullable_to_non_nullable
              as String,
      localidadCp: null == localidadCp
          ? _self.localidadCp
          : localidadCp // ignore: cast_nullable_to_non_nullable
              as LocalidadCp,
      calle: null == calle
          ? _self.calle
          : calle // ignore: cast_nullable_to_non_nullable
              as String,
      seccionine: null == seccionine
          ? _self.seccionine
          : seccionine // ignore: cast_nullable_to_non_nullable
              as String,
      latitud: null == latitud
          ? _self.latitud
          : latitud // ignore: cast_nullable_to_non_nullable
              as String,
      longitud: null == longitud
          ? _self.longitud
          : longitud // ignore: cast_nullable_to_non_nullable
              as String,
      latDecimal: null == latDecimal
          ? _self.latDecimal
          : latDecimal // ignore: cast_nullable_to_non_nullable
              as String,
      lonDecimal: null == lonDecimal
          ? _self.lonDecimal
          : lonDecimal // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of UsuarioLocalidades
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocalidadCpCopyWith<$Res> get localidadCp {
    return $LocalidadCpCopyWith<$Res>(_self.localidadCp, (value) {
      return _then(_self.copyWith(localidadCp: value));
    });
  }
}

// dart format on
