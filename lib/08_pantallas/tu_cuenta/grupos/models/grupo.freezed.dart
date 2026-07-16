// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grupo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MiembroGrupo {
  String get usuarioId;
  RolGrupo get rol;
  DateTime get fechaIngreso;

  /// Create a copy of MiembroGrupo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MiembroGrupoCopyWith<MiembroGrupo> get copyWith =>
      _$MiembroGrupoCopyWithImpl<MiembroGrupo>(
          this as MiembroGrupo, _$identity);

  /// Serializes this MiembroGrupo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MiembroGrupo &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.rol, rol) || other.rol == rol) &&
            (identical(other.fechaIngreso, fechaIngreso) ||
                other.fechaIngreso == fechaIngreso));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, usuarioId, rol, fechaIngreso);

  @override
  String toString() {
    return 'MiembroGrupo(usuarioId: $usuarioId, rol: $rol, fechaIngreso: $fechaIngreso)';
  }
}

/// @nodoc
abstract mixin class $MiembroGrupoCopyWith<$Res> {
  factory $MiembroGrupoCopyWith(
          MiembroGrupo value, $Res Function(MiembroGrupo) _then) =
      _$MiembroGrupoCopyWithImpl;
  @useResult
  $Res call({String usuarioId, RolGrupo rol, DateTime fechaIngreso});
}

/// @nodoc
class _$MiembroGrupoCopyWithImpl<$Res> implements $MiembroGrupoCopyWith<$Res> {
  _$MiembroGrupoCopyWithImpl(this._self, this._then);

  final MiembroGrupo _self;
  final $Res Function(MiembroGrupo) _then;

  /// Create a copy of MiembroGrupo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usuarioId = null,
    Object? rol = null,
    Object? fechaIngreso = null,
  }) {
    return _then(_self.copyWith(
      usuarioId: null == usuarioId
          ? _self.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as String,
      rol: null == rol
          ? _self.rol
          : rol // ignore: cast_nullable_to_non_nullable
              as RolGrupo,
      fechaIngreso: null == fechaIngreso
          ? _self.fechaIngreso
          : fechaIngreso // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [MiembroGrupo].
extension MiembroGrupoPatterns on MiembroGrupo {
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
    TResult Function(_MiembroGrupo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MiembroGrupo() when $default != null:
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
    TResult Function(_MiembroGrupo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MiembroGrupo():
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
    TResult? Function(_MiembroGrupo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MiembroGrupo() when $default != null:
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
    TResult Function(String usuarioId, RolGrupo rol, DateTime fechaIngreso)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MiembroGrupo() when $default != null:
        return $default(_that.usuarioId, _that.rol, _that.fechaIngreso);
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
    TResult Function(String usuarioId, RolGrupo rol, DateTime fechaIngreso)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MiembroGrupo():
        return $default(_that.usuarioId, _that.rol, _that.fechaIngreso);
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
    TResult? Function(String usuarioId, RolGrupo rol, DateTime fechaIngreso)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MiembroGrupo() when $default != null:
        return $default(_that.usuarioId, _that.rol, _that.fechaIngreso);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MiembroGrupo implements MiembroGrupo {
  const _MiembroGrupo(
      {required this.usuarioId,
      this.rol = RolGrupo.miembro,
      required this.fechaIngreso});
  factory _MiembroGrupo.fromJson(Map<String, dynamic> json) =>
      _$MiembroGrupoFromJson(json);

  @override
  final String usuarioId;
  @override
  @JsonKey()
  final RolGrupo rol;
  @override
  final DateTime fechaIngreso;

  /// Create a copy of MiembroGrupo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MiembroGrupoCopyWith<_MiembroGrupo> get copyWith =>
      __$MiembroGrupoCopyWithImpl<_MiembroGrupo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MiembroGrupoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MiembroGrupo &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.rol, rol) || other.rol == rol) &&
            (identical(other.fechaIngreso, fechaIngreso) ||
                other.fechaIngreso == fechaIngreso));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, usuarioId, rol, fechaIngreso);

  @override
  String toString() {
    return 'MiembroGrupo(usuarioId: $usuarioId, rol: $rol, fechaIngreso: $fechaIngreso)';
  }
}

/// @nodoc
abstract mixin class _$MiembroGrupoCopyWith<$Res>
    implements $MiembroGrupoCopyWith<$Res> {
  factory _$MiembroGrupoCopyWith(
          _MiembroGrupo value, $Res Function(_MiembroGrupo) _then) =
      __$MiembroGrupoCopyWithImpl;
  @override
  @useResult
  $Res call({String usuarioId, RolGrupo rol, DateTime fechaIngreso});
}

/// @nodoc
class __$MiembroGrupoCopyWithImpl<$Res>
    implements _$MiembroGrupoCopyWith<$Res> {
  __$MiembroGrupoCopyWithImpl(this._self, this._then);

  final _MiembroGrupo _self;
  final $Res Function(_MiembroGrupo) _then;

  /// Create a copy of MiembroGrupo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? usuarioId = null,
    Object? rol = null,
    Object? fechaIngreso = null,
  }) {
    return _then(_MiembroGrupo(
      usuarioId: null == usuarioId
          ? _self.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as String,
      rol: null == rol
          ? _self.rol
          : rol // ignore: cast_nullable_to_non_nullable
              as RolGrupo,
      fechaIngreso: null == fechaIngreso
          ? _self.fechaIngreso
          : fechaIngreso // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$Grupo {
  String get id;
  String get nombre;
  String get descripcion;
  String get creadorId;
  List<MiembroGrupo> get miembros;
  DateTime get fechaCreacion;

  /// Create a copy of Grupo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GrupoCopyWith<Grupo> get copyWith =>
      _$GrupoCopyWithImpl<Grupo>(this as Grupo, _$identity);

  /// Serializes this Grupo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Grupo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.creadorId, creadorId) ||
                other.creadorId == creadorId) &&
            const DeepCollectionEquality().equals(other.miembros, miembros) &&
            (identical(other.fechaCreacion, fechaCreacion) ||
                other.fechaCreacion == fechaCreacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, descripcion,
      creadorId, const DeepCollectionEquality().hash(miembros), fechaCreacion);

  @override
  String toString() {
    return 'Grupo(id: $id, nombre: $nombre, descripcion: $descripcion, creadorId: $creadorId, miembros: $miembros, fechaCreacion: $fechaCreacion)';
  }
}

/// @nodoc
abstract mixin class $GrupoCopyWith<$Res> {
  factory $GrupoCopyWith(Grupo value, $Res Function(Grupo) _then) =
      _$GrupoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String nombre,
      String descripcion,
      String creadorId,
      List<MiembroGrupo> miembros,
      DateTime fechaCreacion});
}

/// @nodoc
class _$GrupoCopyWithImpl<$Res> implements $GrupoCopyWith<$Res> {
  _$GrupoCopyWithImpl(this._self, this._then);

  final Grupo _self;
  final $Res Function(Grupo) _then;

  /// Create a copy of Grupo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? descripcion = null,
    Object? creadorId = null,
    Object? miembros = null,
    Object? fechaCreacion = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _self.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      descripcion: null == descripcion
          ? _self.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String,
      creadorId: null == creadorId
          ? _self.creadorId
          : creadorId // ignore: cast_nullable_to_non_nullable
              as String,
      miembros: null == miembros
          ? _self.miembros
          : miembros // ignore: cast_nullable_to_non_nullable
              as List<MiembroGrupo>,
      fechaCreacion: null == fechaCreacion
          ? _self.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [Grupo].
extension GrupoPatterns on Grupo {
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
    TResult Function(_Grupo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Grupo() when $default != null:
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
    TResult Function(_Grupo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Grupo():
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
    TResult? Function(_Grupo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Grupo() when $default != null:
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
            String nombre,
            String descripcion,
            String creadorId,
            List<MiembroGrupo> miembros,
            DateTime fechaCreacion)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Grupo() when $default != null:
        return $default(_that.id, _that.nombre, _that.descripcion,
            _that.creadorId, _that.miembros, _that.fechaCreacion);
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
            String nombre,
            String descripcion,
            String creadorId,
            List<MiembroGrupo> miembros,
            DateTime fechaCreacion)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Grupo():
        return $default(_that.id, _that.nombre, _that.descripcion,
            _that.creadorId, _that.miembros, _that.fechaCreacion);
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
            String nombre,
            String descripcion,
            String creadorId,
            List<MiembroGrupo> miembros,
            DateTime fechaCreacion)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Grupo() when $default != null:
        return $default(_that.id, _that.nombre, _that.descripcion,
            _that.creadorId, _that.miembros, _that.fechaCreacion);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Grupo implements Grupo {
  const _Grupo(
      {required this.id,
      required this.nombre,
      required this.descripcion,
      required this.creadorId,
      required final List<MiembroGrupo> miembros,
      required this.fechaCreacion})
      : _miembros = miembros;
  factory _Grupo.fromJson(Map<String, dynamic> json) => _$GrupoFromJson(json);

  @override
  final String id;
  @override
  final String nombre;
  @override
  final String descripcion;
  @override
  final String creadorId;
  final List<MiembroGrupo> _miembros;
  @override
  List<MiembroGrupo> get miembros {
    if (_miembros is EqualUnmodifiableListView) return _miembros;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_miembros);
  }

  @override
  final DateTime fechaCreacion;

  /// Create a copy of Grupo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GrupoCopyWith<_Grupo> get copyWith =>
      __$GrupoCopyWithImpl<_Grupo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GrupoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Grupo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.creadorId, creadorId) ||
                other.creadorId == creadorId) &&
            const DeepCollectionEquality().equals(other._miembros, _miembros) &&
            (identical(other.fechaCreacion, fechaCreacion) ||
                other.fechaCreacion == fechaCreacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, descripcion,
      creadorId, const DeepCollectionEquality().hash(_miembros), fechaCreacion);

  @override
  String toString() {
    return 'Grupo(id: $id, nombre: $nombre, descripcion: $descripcion, creadorId: $creadorId, miembros: $miembros, fechaCreacion: $fechaCreacion)';
  }
}

/// @nodoc
abstract mixin class _$GrupoCopyWith<$Res> implements $GrupoCopyWith<$Res> {
  factory _$GrupoCopyWith(_Grupo value, $Res Function(_Grupo) _then) =
      __$GrupoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String nombre,
      String descripcion,
      String creadorId,
      List<MiembroGrupo> miembros,
      DateTime fechaCreacion});
}

/// @nodoc
class __$GrupoCopyWithImpl<$Res> implements _$GrupoCopyWith<$Res> {
  __$GrupoCopyWithImpl(this._self, this._then);

  final _Grupo _self;
  final $Res Function(_Grupo) _then;

  /// Create a copy of Grupo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? descripcion = null,
    Object? creadorId = null,
    Object? miembros = null,
    Object? fechaCreacion = null,
  }) {
    return _then(_Grupo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _self.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      descripcion: null == descripcion
          ? _self.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String,
      creadorId: null == creadorId
          ? _self.creadorId
          : creadorId // ignore: cast_nullable_to_non_nullable
              as String,
      miembros: null == miembros
          ? _self._miembros
          : miembros // ignore: cast_nullable_to_non_nullable
              as List<MiembroGrupo>,
      fechaCreacion: null == fechaCreacion
          ? _self.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
