// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_get_avatar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClassUserAvatarNotifier)
final classUserAvatarProvider = ClassUserAvatarNotifierProvider._();

final class ClassUserAvatarNotifierProvider
    extends $NotifierProvider<ClassUserAvatarNotifier, GetUserAvatar> {
  ClassUserAvatarNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'classUserAvatarProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$classUserAvatarNotifierHash();

  @$internal
  @override
  ClassUserAvatarNotifier create() => ClassUserAvatarNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetUserAvatar value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetUserAvatar>(value),
    );
  }
}

String _$classUserAvatarNotifierHash() =>
    r'378f49360598483d7d7df71a212a8da1ea49e72f';

abstract class _$ClassUserAvatarNotifier extends $Notifier<GetUserAvatar> {
  GetUserAvatar build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GetUserAvatar, GetUserAvatar>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<GetUserAvatar, GetUserAvatar>,
        GetUserAvatar,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(getAvatarImage)
final getAvatarImageProvider = GetAvatarImageFamily._();

final class GetAvatarImageProvider extends $FunctionalProvider<
        AsyncValue<Uint8List>, Uint8List, FutureOr<Uint8List>>
    with $FutureModifier<Uint8List>, $FutureProvider<Uint8List> {
  GetAvatarImageProvider._(
      {required GetAvatarImageFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'getAvatarImageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getAvatarImageHash();

  @override
  String toString() {
    return r'getAvatarImageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List> create(Ref ref) {
    final argument = this.argument as String;
    return getAvatarImage(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetAvatarImageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getAvatarImageHash() => r'12736dc5fd57fa5c8c1e2a801f372833e0efff83';

final class GetAvatarImageFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List>, String> {
  GetAvatarImageFamily._()
      : super(
          retry: null,
          name: r'getAvatarImageProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GetAvatarImageProvider call(
    String idUsuario,
  ) =>
      GetAvatarImageProvider._(argument: idUsuario, from: this);

  @override
  String toString() => r'getAvatarImageProvider';
}
