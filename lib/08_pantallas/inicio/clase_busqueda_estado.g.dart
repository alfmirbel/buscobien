// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clase_busqueda_estado.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BusquedaPaginacion)
final busquedaPaginacionProvider = BusquedaPaginacionProvider._();

final class BusquedaPaginacionProvider
    extends $NotifierProvider<BusquedaPaginacion, int> {
  BusquedaPaginacionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'busquedaPaginacionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$busquedaPaginacionHash();

  @$internal
  @override
  BusquedaPaginacion create() => BusquedaPaginacion();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$busquedaPaginacionHash() =>
    r'606d974d774c4f459fc669746ce85d0e0f374d21';

abstract class _$BusquedaPaginacion extends $Notifier<int> {
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

@ProviderFor(SearchTerm)
final searchTermProvider = SearchTermProvider._();

final class SearchTermProvider extends $NotifierProvider<SearchTerm, String> {
  SearchTermProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchTermProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchTermHash();

  @$internal
  @override
  SearchTerm create() => SearchTerm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchTermHash() => r'86a12128d5dcabf45b58ed3281bd604d1b69175c';

abstract class _$SearchTerm extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
