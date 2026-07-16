// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_view_count_filter_propiedades.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(viewCountFilterPropiedades)
final viewCountFilterPropiedadesProvider = ViewCountFilterPropiedadesFamily._();

final class ViewCountFilterPropiedadesProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  ViewCountFilterPropiedadesProvider._(
      {required ViewCountFilterPropiedadesFamily super.from,
      required VariablesViewQuery super.argument})
      : super(
          retry: null,
          name: r'viewCountFilterPropiedadesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$viewCountFilterPropiedadesHash();

  @override
  String toString() {
    return r'viewCountFilterPropiedadesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as VariablesViewQuery;
    return viewCountFilterPropiedades(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ViewCountFilterPropiedadesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$viewCountFilterPropiedadesHash() =>
    r'1a922e049c24c2c56ba98ecc2a1764a98331ce26';

final class ViewCountFilterPropiedadesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, VariablesViewQuery> {
  ViewCountFilterPropiedadesFamily._()
      : super(
          retry: null,
          name: r'viewCountFilterPropiedadesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ViewCountFilterPropiedadesProvider call(
    VariablesViewQuery valueQry,
  ) =>
      ViewCountFilterPropiedadesProvider._(argument: valueQry, from: this);

  @override
  String toString() => r'viewCountFilterPropiedadesProvider';
}
