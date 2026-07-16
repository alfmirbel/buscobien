// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_sepomex_localidades.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocalidadCp {
  int get idEstado;
  String get estado;
  int get idMunicipio;
  String get municipio;
  String get ciudad;
  String get zona;
  int get cp;
  String get asentamiento;
  String get tipo;

  /// Create a copy of LocalidadCp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocalidadCpCopyWith<LocalidadCp> get copyWith =>
      _$LocalidadCpCopyWithImpl<LocalidadCp>(this as LocalidadCp, _$identity);

  /// Serializes this LocalidadCp to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocalidadCp &&
            (identical(other.idEstado, idEstado) ||
                other.idEstado == idEstado) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.idMunicipio, idMunicipio) ||
                other.idMunicipio == idMunicipio) &&
            (identical(other.municipio, municipio) ||
                other.municipio == municipio) &&
            (identical(other.ciudad, ciudad) || other.ciudad == ciudad) &&
            (identical(other.zona, zona) || other.zona == zona) &&
            (identical(other.cp, cp) || other.cp == cp) &&
            (identical(other.asentamiento, asentamiento) ||
                other.asentamiento == asentamiento) &&
            (identical(other.tipo, tipo) || other.tipo == tipo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idEstado, estado, idMunicipio,
      municipio, ciudad, zona, cp, asentamiento, tipo);

  @override
  String toString() {
    return 'LocalidadCp(idEstado: $idEstado, estado: $estado, idMunicipio: $idMunicipio, municipio: $municipio, ciudad: $ciudad, zona: $zona, cp: $cp, asentamiento: $asentamiento, tipo: $tipo)';
  }
}

/// @nodoc
abstract mixin class $LocalidadCpCopyWith<$Res> {
  factory $LocalidadCpCopyWith(
          LocalidadCp value, $Res Function(LocalidadCp) _then) =
      _$LocalidadCpCopyWithImpl;
  @useResult
  $Res call(
      {int idEstado,
      String estado,
      int idMunicipio,
      String municipio,
      String ciudad,
      String zona,
      int cp,
      String asentamiento,
      String tipo});
}

/// @nodoc
class _$LocalidadCpCopyWithImpl<$Res> implements $LocalidadCpCopyWith<$Res> {
  _$LocalidadCpCopyWithImpl(this._self, this._then);

  final LocalidadCp _self;
  final $Res Function(LocalidadCp) _then;

  /// Create a copy of LocalidadCp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idEstado = null,
    Object? estado = null,
    Object? idMunicipio = null,
    Object? municipio = null,
    Object? ciudad = null,
    Object? zona = null,
    Object? cp = null,
    Object? asentamiento = null,
    Object? tipo = null,
  }) {
    return _then(_self.copyWith(
      idEstado: null == idEstado
          ? _self.idEstado
          : idEstado // ignore: cast_nullable_to_non_nullable
              as int,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      idMunicipio: null == idMunicipio
          ? _self.idMunicipio
          : idMunicipio // ignore: cast_nullable_to_non_nullable
              as int,
      municipio: null == municipio
          ? _self.municipio
          : municipio // ignore: cast_nullable_to_non_nullable
              as String,
      ciudad: null == ciudad
          ? _self.ciudad
          : ciudad // ignore: cast_nullable_to_non_nullable
              as String,
      zona: null == zona
          ? _self.zona
          : zona // ignore: cast_nullable_to_non_nullable
              as String,
      cp: null == cp
          ? _self.cp
          : cp // ignore: cast_nullable_to_non_nullable
              as int,
      asentamiento: null == asentamiento
          ? _self.asentamiento
          : asentamiento // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _self.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [LocalidadCp].
extension LocalidadCpPatterns on LocalidadCp {
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
    TResult Function(_LocalidadCp value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocalidadCp() when $default != null:
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
    TResult Function(_LocalidadCp value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalidadCp():
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
    TResult? Function(_LocalidadCp value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalidadCp() when $default != null:
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
            int idEstado,
            String estado,
            int idMunicipio,
            String municipio,
            String ciudad,
            String zona,
            int cp,
            String asentamiento,
            String tipo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocalidadCp() when $default != null:
        return $default(
            _that.idEstado,
            _that.estado,
            _that.idMunicipio,
            _that.municipio,
            _that.ciudad,
            _that.zona,
            _that.cp,
            _that.asentamiento,
            _that.tipo);
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
            int idEstado,
            String estado,
            int idMunicipio,
            String municipio,
            String ciudad,
            String zona,
            int cp,
            String asentamiento,
            String tipo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalidadCp():
        return $default(
            _that.idEstado,
            _that.estado,
            _that.idMunicipio,
            _that.municipio,
            _that.ciudad,
            _that.zona,
            _that.cp,
            _that.asentamiento,
            _that.tipo);
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
            int idEstado,
            String estado,
            int idMunicipio,
            String municipio,
            String ciudad,
            String zona,
            int cp,
            String asentamiento,
            String tipo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalidadCp() when $default != null:
        return $default(
            _that.idEstado,
            _that.estado,
            _that.idMunicipio,
            _that.municipio,
            _that.ciudad,
            _that.zona,
            _that.cp,
            _that.asentamiento,
            _that.tipo);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LocalidadCp implements LocalidadCp {
  const _LocalidadCp(
      {required this.idEstado,
      required this.estado,
      required this.idMunicipio,
      required this.municipio,
      required this.ciudad,
      required this.zona,
      required this.cp,
      required this.asentamiento,
      required this.tipo});
  factory _LocalidadCp.fromJson(Map<String, dynamic> json) =>
      _$LocalidadCpFromJson(json);

  @override
  final int idEstado;
  @override
  final String estado;
  @override
  final int idMunicipio;
  @override
  final String municipio;
  @override
  final String ciudad;
  @override
  final String zona;
  @override
  final int cp;
  @override
  final String asentamiento;
  @override
  final String tipo;

  /// Create a copy of LocalidadCp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LocalidadCpCopyWith<_LocalidadCp> get copyWith =>
      __$LocalidadCpCopyWithImpl<_LocalidadCp>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LocalidadCpToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalidadCp &&
            (identical(other.idEstado, idEstado) ||
                other.idEstado == idEstado) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.idMunicipio, idMunicipio) ||
                other.idMunicipio == idMunicipio) &&
            (identical(other.municipio, municipio) ||
                other.municipio == municipio) &&
            (identical(other.ciudad, ciudad) || other.ciudad == ciudad) &&
            (identical(other.zona, zona) || other.zona == zona) &&
            (identical(other.cp, cp) || other.cp == cp) &&
            (identical(other.asentamiento, asentamiento) ||
                other.asentamiento == asentamiento) &&
            (identical(other.tipo, tipo) || other.tipo == tipo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idEstado, estado, idMunicipio,
      municipio, ciudad, zona, cp, asentamiento, tipo);

  @override
  String toString() {
    return 'LocalidadCp(idEstado: $idEstado, estado: $estado, idMunicipio: $idMunicipio, municipio: $municipio, ciudad: $ciudad, zona: $zona, cp: $cp, asentamiento: $asentamiento, tipo: $tipo)';
  }
}

/// @nodoc
abstract mixin class _$LocalidadCpCopyWith<$Res>
    implements $LocalidadCpCopyWith<$Res> {
  factory _$LocalidadCpCopyWith(
          _LocalidadCp value, $Res Function(_LocalidadCp) _then) =
      __$LocalidadCpCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int idEstado,
      String estado,
      int idMunicipio,
      String municipio,
      String ciudad,
      String zona,
      int cp,
      String asentamiento,
      String tipo});
}

/// @nodoc
class __$LocalidadCpCopyWithImpl<$Res> implements _$LocalidadCpCopyWith<$Res> {
  __$LocalidadCpCopyWithImpl(this._self, this._then);

  final _LocalidadCp _self;
  final $Res Function(_LocalidadCp) _then;

  /// Create a copy of LocalidadCp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? idEstado = null,
    Object? estado = null,
    Object? idMunicipio = null,
    Object? municipio = null,
    Object? ciudad = null,
    Object? zona = null,
    Object? cp = null,
    Object? asentamiento = null,
    Object? tipo = null,
  }) {
    return _then(_LocalidadCp(
      idEstado: null == idEstado
          ? _self.idEstado
          : idEstado // ignore: cast_nullable_to_non_nullable
              as int,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      idMunicipio: null == idMunicipio
          ? _self.idMunicipio
          : idMunicipio // ignore: cast_nullable_to_non_nullable
              as int,
      municipio: null == municipio
          ? _self.municipio
          : municipio // ignore: cast_nullable_to_non_nullable
              as String,
      ciudad: null == ciudad
          ? _self.ciudad
          : ciudad // ignore: cast_nullable_to_non_nullable
              as String,
      zona: null == zona
          ? _self.zona
          : zona // ignore: cast_nullable_to_non_nullable
              as String,
      cp: null == cp
          ? _self.cp
          : cp // ignore: cast_nullable_to_non_nullable
              as int,
      asentamiento: null == asentamiento
          ? _self.asentamiento
          : asentamiento // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _self.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
