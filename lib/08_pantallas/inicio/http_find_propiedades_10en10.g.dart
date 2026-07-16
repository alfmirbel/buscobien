// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_find_propiedades_10en10.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(findPropiedadesEstadosde10en10)
final findPropiedadesEstadosde10en10Provider =
    FindPropiedadesEstadosde10en10Family._();

final class FindPropiedadesEstadosde10en10Provider extends $FunctionalProvider<
        AsyncValue<EspaciosCasaGet>, EspaciosCasaGet, FutureOr<EspaciosCasaGet>>
    with $FutureModifier<EspaciosCasaGet>, $FutureProvider<EspaciosCasaGet> {
  FindPropiedadesEstadosde10en10Provider._(
      {required FindPropiedadesEstadosde10en10Family super.from,
      required ({
        int paramSkipFind,
        int paramLimitFind,
        VariablesViewQuery valueQry,
      })
          super.argument})
      : super(
          retry: null,
          name: r'findPropiedadesEstadosde10en10Provider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$findPropiedadesEstadosde10en10Hash();

  @override
  String toString() {
    return r'findPropiedadesEstadosde10en10Provider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<EspaciosCasaGet> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<EspaciosCasaGet> create(Ref ref) {
    final argument = this.argument as ({
      int paramSkipFind,
      int paramLimitFind,
      VariablesViewQuery valueQry,
    });
    return findPropiedadesEstadosde10en10(
      ref,
      paramSkipFind: argument.paramSkipFind,
      paramLimitFind: argument.paramLimitFind,
      valueQry: argument.valueQry,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FindPropiedadesEstadosde10en10Provider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$findPropiedadesEstadosde10en10Hash() =>
    r'c50d20b75ed8c8016f0fa808c84245812cd9f5e3';

final class FindPropiedadesEstadosde10en10Family extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<EspaciosCasaGet>,
            ({
              int paramSkipFind,
              int paramLimitFind,
              VariablesViewQuery valueQry,
            })> {
  FindPropiedadesEstadosde10en10Family._()
      : super(
          retry: null,
          name: r'findPropiedadesEstadosde10en10Provider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FindPropiedadesEstadosde10en10Provider call({
    required int paramSkipFind,
    required int paramLimitFind,
    required VariablesViewQuery valueQry,
  }) =>
      FindPropiedadesEstadosde10en10Provider._(argument: (
        paramSkipFind: paramSkipFind,
        paramLimitFind: paramLimitFind,
        valueQry: valueQry,
      ), from: this);

  @override
  String toString() => r'findPropiedadesEstadosde10en10Provider';
}
