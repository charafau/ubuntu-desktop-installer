// Mocks generated by Mockito 5.3.2 from annotations
// in ubuntu_desktop_installer/test/not_enough_disk_space/not_enough_disk_space_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:ubuntu_desktop_installer/pages/not_enough_disk_space/not_enough_disk_space_model.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [NotEnoughDiskSpaceModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockNotEnoughDiskSpaceModel extends _i1.Mock
    implements _i2.NotEnoughDiskSpaceModel {
  MockNotEnoughDiskSpaceModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get largestDiskSize => (super.noSuchMethod(
        Invocation.getter(#largestDiskSize),
        returnValue: 0,
      ) as int);
  @override
  bool get hasMultipleDisks => (super.noSuchMethod(
        Invocation.getter(#hasMultipleDisks),
        returnValue: false,
      ) as bool);
  @override
  int get installMinimumSize => (super.noSuchMethod(
        Invocation.getter(#installMinimumSize),
        returnValue: 0,
      ) as int);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  bool get isDisposed => (super.noSuchMethod(
        Invocation.getter(#isDisposed),
        returnValue: false,
      ) as bool);
  @override
  void quit() => super.noSuchMethod(
        Invocation.method(
          #quit,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addListener(_i3.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i3.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
