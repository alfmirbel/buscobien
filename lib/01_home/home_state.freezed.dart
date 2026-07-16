// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeState {
  int get indiceInicial;
  int get indicePrincipal;
  int get indiceNivelGobierno;
  int get indiceTipoEspacio;
  int get indiceTipoTransaccion;
  int get indiceMiCuenta;
  int get indiceMiCuentaUsuario;
  int get version;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeStateCopyWith<HomeState> get copyWith =>
      _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeState &&
            (identical(other.indiceInicial, indiceInicial) ||
                other.indiceInicial == indiceInicial) &&
            (identical(other.indicePrincipal, indicePrincipal) ||
                other.indicePrincipal == indicePrincipal) &&
            (identical(other.indiceNivelGobierno, indiceNivelGobierno) ||
                other.indiceNivelGobierno == indiceNivelGobierno) &&
            (identical(other.indiceTipoEspacio, indiceTipoEspacio) ||
                other.indiceTipoEspacio == indiceTipoEspacio) &&
            (identical(other.indiceTipoTransaccion, indiceTipoTransaccion) ||
                other.indiceTipoTransaccion == indiceTipoTransaccion) &&
            (identical(other.indiceMiCuenta, indiceMiCuenta) ||
                other.indiceMiCuenta == indiceMiCuenta) &&
            (identical(other.indiceMiCuentaUsuario, indiceMiCuentaUsuario) ||
                other.indiceMiCuentaUsuario == indiceMiCuentaUsuario) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      indiceInicial,
      indicePrincipal,
      indiceNivelGobierno,
      indiceTipoEspacio,
      indiceTipoTransaccion,
      indiceMiCuenta,
      indiceMiCuentaUsuario,
      version);

  @override
  String toString() {
    return 'HomeState(indiceInicial: $indiceInicial, indicePrincipal: $indicePrincipal, indiceNivelGobierno: $indiceNivelGobierno, indiceTipoEspacio: $indiceTipoEspacio, indiceTipoTransaccion: $indiceTipoTransaccion, indiceMiCuenta: $indiceMiCuenta, indiceMiCuentaUsuario: $indiceMiCuentaUsuario, version: $version)';
  }
}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) =
      _$HomeStateCopyWithImpl;
  @useResult
  $Res call(
      {int indiceInicial,
      int indicePrincipal,
      int indiceNivelGobierno,
      int indiceTipoEspacio,
      int indiceTipoTransaccion,
      int indiceMiCuenta,
      int indiceMiCuentaUsuario,
      int version});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res> implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? indiceInicial = null,
    Object? indicePrincipal = null,
    Object? indiceNivelGobierno = null,
    Object? indiceTipoEspacio = null,
    Object? indiceTipoTransaccion = null,
    Object? indiceMiCuenta = null,
    Object? indiceMiCuentaUsuario = null,
    Object? version = null,
  }) {
    return _then(_self.copyWith(
      indiceInicial: null == indiceInicial
          ? _self.indiceInicial
          : indiceInicial // ignore: cast_nullable_to_non_nullable
              as int,
      indicePrincipal: null == indicePrincipal
          ? _self.indicePrincipal
          : indicePrincipal // ignore: cast_nullable_to_non_nullable
              as int,
      indiceNivelGobierno: null == indiceNivelGobierno
          ? _self.indiceNivelGobierno
          : indiceNivelGobierno // ignore: cast_nullable_to_non_nullable
              as int,
      indiceTipoEspacio: null == indiceTipoEspacio
          ? _self.indiceTipoEspacio
          : indiceTipoEspacio // ignore: cast_nullable_to_non_nullable
              as int,
      indiceTipoTransaccion: null == indiceTipoTransaccion
          ? _self.indiceTipoTransaccion
          : indiceTipoTransaccion // ignore: cast_nullable_to_non_nullable
              as int,
      indiceMiCuenta: null == indiceMiCuenta
          ? _self.indiceMiCuenta
          : indiceMiCuenta // ignore: cast_nullable_to_non_nullable
              as int,
      indiceMiCuentaUsuario: null == indiceMiCuentaUsuario
          ? _self.indiceMiCuentaUsuario
          : indiceMiCuentaUsuario // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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
    TResult Function(_HomeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
    TResult Function(_HomeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
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
    TResult? Function(_HomeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
            int indiceInicial,
            int indicePrincipal,
            int indiceNivelGobierno,
            int indiceTipoEspacio,
            int indiceTipoTransaccion,
            int indiceMiCuenta,
            int indiceMiCuentaUsuario,
            int version)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(
            _that.indiceInicial,
            _that.indicePrincipal,
            _that.indiceNivelGobierno,
            _that.indiceTipoEspacio,
            _that.indiceTipoTransaccion,
            _that.indiceMiCuenta,
            _that.indiceMiCuentaUsuario,
            _that.version);
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
            int indiceInicial,
            int indicePrincipal,
            int indiceNivelGobierno,
            int indiceTipoEspacio,
            int indiceTipoTransaccion,
            int indiceMiCuenta,
            int indiceMiCuentaUsuario,
            int version)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
        return $default(
            _that.indiceInicial,
            _that.indicePrincipal,
            _that.indiceNivelGobierno,
            _that.indiceTipoEspacio,
            _that.indiceTipoTransaccion,
            _that.indiceMiCuenta,
            _that.indiceMiCuentaUsuario,
            _that.version);
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
            int indiceInicial,
            int indicePrincipal,
            int indiceNivelGobierno,
            int indiceTipoEspacio,
            int indiceTipoTransaccion,
            int indiceMiCuenta,
            int indiceMiCuentaUsuario,
            int version)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(
            _that.indiceInicial,
            _that.indicePrincipal,
            _that.indiceNivelGobierno,
            _that.indiceTipoEspacio,
            _that.indiceTipoTransaccion,
            _that.indiceMiCuenta,
            _that.indiceMiCuentaUsuario,
            _that.version);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HomeState extends HomeState {
  const _HomeState(
      {this.indiceInicial = 0,
      this.indicePrincipal = 0,
      this.indiceNivelGobierno = 0,
      this.indiceTipoEspacio = 0,
      this.indiceTipoTransaccion = 0,
      this.indiceMiCuenta = 0,
      this.indiceMiCuentaUsuario = 0,
      this.version = 0})
      : super._();

  @override
  @JsonKey()
  final int indiceInicial;
  @override
  @JsonKey()
  final int indicePrincipal;
  @override
  @JsonKey()
  final int indiceNivelGobierno;
  @override
  @JsonKey()
  final int indiceTipoEspacio;
  @override
  @JsonKey()
  final int indiceTipoTransaccion;
  @override
  @JsonKey()
  final int indiceMiCuenta;
  @override
  @JsonKey()
  final int indiceMiCuentaUsuario;
  @override
  @JsonKey()
  final int version;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeStateCopyWith<_HomeState> get copyWith =>
      __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeState &&
            (identical(other.indiceInicial, indiceInicial) ||
                other.indiceInicial == indiceInicial) &&
            (identical(other.indicePrincipal, indicePrincipal) ||
                other.indicePrincipal == indicePrincipal) &&
            (identical(other.indiceNivelGobierno, indiceNivelGobierno) ||
                other.indiceNivelGobierno == indiceNivelGobierno) &&
            (identical(other.indiceTipoEspacio, indiceTipoEspacio) ||
                other.indiceTipoEspacio == indiceTipoEspacio) &&
            (identical(other.indiceTipoTransaccion, indiceTipoTransaccion) ||
                other.indiceTipoTransaccion == indiceTipoTransaccion) &&
            (identical(other.indiceMiCuenta, indiceMiCuenta) ||
                other.indiceMiCuenta == indiceMiCuenta) &&
            (identical(other.indiceMiCuentaUsuario, indiceMiCuentaUsuario) ||
                other.indiceMiCuentaUsuario == indiceMiCuentaUsuario) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      indiceInicial,
      indicePrincipal,
      indiceNivelGobierno,
      indiceTipoEspacio,
      indiceTipoTransaccion,
      indiceMiCuenta,
      indiceMiCuentaUsuario,
      version);

  @override
  String toString() {
    return 'HomeState(indiceInicial: $indiceInicial, indicePrincipal: $indicePrincipal, indiceNivelGobierno: $indiceNivelGobierno, indiceTipoEspacio: $indiceTipoEspacio, indiceTipoTransaccion: $indiceTipoTransaccion, indiceMiCuenta: $indiceMiCuenta, indiceMiCuentaUsuario: $indiceMiCuentaUsuario, version: $version)';
  }
}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(
          _HomeState value, $Res Function(_HomeState) _then) =
      __$HomeStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int indiceInicial,
      int indicePrincipal,
      int indiceNivelGobierno,
      int indiceTipoEspacio,
      int indiceTipoTransaccion,
      int indiceMiCuenta,
      int indiceMiCuentaUsuario,
      int version});
}

/// @nodoc
class __$HomeStateCopyWithImpl<$Res> implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? indiceInicial = null,
    Object? indicePrincipal = null,
    Object? indiceNivelGobierno = null,
    Object? indiceTipoEspacio = null,
    Object? indiceTipoTransaccion = null,
    Object? indiceMiCuenta = null,
    Object? indiceMiCuentaUsuario = null,
    Object? version = null,
  }) {
    return _then(_HomeState(
      indiceInicial: null == indiceInicial
          ? _self.indiceInicial
          : indiceInicial // ignore: cast_nullable_to_non_nullable
              as int,
      indicePrincipal: null == indicePrincipal
          ? _self.indicePrincipal
          : indicePrincipal // ignore: cast_nullable_to_non_nullable
              as int,
      indiceNivelGobierno: null == indiceNivelGobierno
          ? _self.indiceNivelGobierno
          : indiceNivelGobierno // ignore: cast_nullable_to_non_nullable
              as int,
      indiceTipoEspacio: null == indiceTipoEspacio
          ? _self.indiceTipoEspacio
          : indiceTipoEspacio // ignore: cast_nullable_to_non_nullable
              as int,
      indiceTipoTransaccion: null == indiceTipoTransaccion
          ? _self.indiceTipoTransaccion
          : indiceTipoTransaccion // ignore: cast_nullable_to_non_nullable
              as int,
      indiceMiCuenta: null == indiceMiCuenta
          ? _self.indiceMiCuenta
          : indiceMiCuenta // ignore: cast_nullable_to_non_nullable
              as int,
      indiceMiCuentaUsuario: null == indiceMiCuentaUsuario
          ? _self.indiceMiCuentaUsuario
          : indiceMiCuentaUsuario // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
