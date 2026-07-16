// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inicio_propiedades_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Maneja el estado del 'skip' (paginación)

@ProviderFor(PaginacionBusqueda)
final paginacionBusquedaProvider = PaginacionBusquedaProvider._();

/// Maneja el estado del 'skip' (paginación)
final class PaginacionBusquedaProvider
    extends $NotifierProvider<PaginacionBusqueda, int> {
  /// Maneja el estado del 'skip' (paginación)
  PaginacionBusquedaProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'paginacionBusquedaProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$paginacionBusquedaHash();

  @$internal
  @override
  PaginacionBusqueda create() => PaginacionBusqueda();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$paginacionBusquedaHash() =>
    r'5c47b123cbb3b7ae0e1618de3cebdcf60804c87f';

/// Maneja el estado del 'skip' (paginación)

abstract class _$PaginacionBusqueda extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider que consolida los valores de los menús en un objeto VariablesViewQuery

@ProviderFor(currentQuery)
final currentQueryProvider = CurrentQueryProvider._();

/// Provider que consolida los valores de los menús en un objeto VariablesViewQuery

final class CurrentQueryProvider extends $FunctionalProvider<VariablesViewQuery,
    VariablesViewQuery, VariablesViewQuery> with $Provider<VariablesViewQuery> {
  /// Provider que consolida los valores de los menús en un objeto VariablesViewQuery
  CurrentQueryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentQueryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentQueryHash();

  @$internal
  @override
  $ProviderElement<VariablesViewQuery> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VariablesViewQuery create(Ref ref) {
    return currentQuery(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VariablesViewQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VariablesViewQuery>(value),
    );
  }
}

String _$currentQueryHash() => r'39da6f71e10d5c1328beb540d7ad787848eca647';
