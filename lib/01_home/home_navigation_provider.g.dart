// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_navigation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeNavigation)
final homeNavigationProvider = HomeNavigationProvider._();

final class HomeNavigationProvider
    extends $NotifierProvider<HomeNavigation, HomeState> {
  HomeNavigationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeNavigationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeNavigationHash();

  @$internal
  @override
  HomeNavigation create() => HomeNavigation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeState>(value),
    );
  }
}

String _$homeNavigationHash() => r'4ebf12a031783d50ac7c2ea49df786d8c03ffc61';

abstract class _$HomeNavigation extends $Notifier<HomeState> {
  HomeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HomeState, HomeState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<HomeState, HomeState>, HomeState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
