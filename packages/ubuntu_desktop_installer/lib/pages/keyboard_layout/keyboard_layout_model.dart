import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:diacritic/diacritic.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:ubuntu_logger/ubuntu_logger.dart';

/// @internal
final log = Logger('keyboard_layout');

/// Implements the business logic of the Keyboard Layout page.
class KeyboardLayoutModel extends SafeChangeNotifier {
  /// Creates a model with the specified client.
  KeyboardLayoutModel(this._client);

  final SubiquityClient _client;
  List<KeyboardLayout> _layouts = [];

  /// The number of available keyboard layouts.
  int get layoutCount => _layouts.length;

  /// Returns the name of the keyboard layout at [index].
  ///
  /// Note: the index must be valid.
  String layoutName(int index) {
    assert(index >= 0 && index < layoutCount);
    return _layouts[index].name;
  }

  /// The index of the currently selected layout.
  int get selectedLayoutIndex => _selectedLayoutIndex;
  int _selectedLayoutIndex = -1;

  KeyboardLayout? get _selectedLayout =>
      (_selectedLayoutIndex > -1) ? _layouts[_selectedLayoutIndex] : null;

  /// Emits keyboard layout selection changes.
  Stream<int> get onLayoutSelected => _onLayoutSelected.stream;
  final _onLayoutSelected = StreamController<int>();

  /// Emits keyboard layout variant selection changes.
  Stream<int> get onVariantSelected => _onVariantSelected.stream;
  final _onVariantSelected = StreamController<int>();

  /// Selects the keyboard layout at [index].
  Future<void> selectLayout(int index, [int variant = 0]) async {
    assert(index > -1 && index < layoutCount);
    if (_selectedLayoutIndex == index) return;
    _selectedLayoutIndex = index;
    _selectedVariantIndex = _selectedLayout!.variants.isNotEmpty ? variant : -1;
    log.info(
        'Selected ${_selectedLayout?.code} (${_selectedVariant?.code}) keyboard layout');
    await updateInputSource();
    notifyListeners();
  }

  /// Tries to find and select a keyboard layout and variant.
  Future<void> trySelectLayoutVariant(String? layout, String? variant) async {
    final layoutIndex = _layouts.indexWhere((l) => l.code == layout);
    if (layoutIndex != -1) {
      final variantIndex =
          _layouts[layoutIndex].variants.indexWhere((v) => v.code == variant);
      await selectLayout(layoutIndex, variantIndex);
      _onLayoutSelected.add(layoutIndex);
      _onVariantSelected.add(variantIndex);
    }
  }

  /// The number of available layout variants.
  int get variantCount => _selectedLayout?.variants.length ?? 0;

  /// Returns the name of the layout variant at [index].
  ///
  /// Note: the index must be valid.
  String variantName(int index) {
    assert(index >= 0 && index < variantCount);
    return _selectedLayout!.variants[index].name;
  }

  /// The index of the currently selected layout variant.
  int get selectedVariantIndex => _selectedVariantIndex;
  int _selectedVariantIndex = -1;

  KeyboardVariant? get _selectedVariant =>
      _selectedLayout?.variants.elementAtOrNull(_selectedVariantIndex);

  /// Selects the keyboard layout variant at [index].
  Future<void> selectVariant(int index) async {
    assert(index > -1 && index < variantCount);
    if (_selectedVariantIndex == index) return;
    _selectedVariantIndex = index;
    log.info(
        'Selected ${_selectedLayout?.code} (${_selectedVariant?.code}) keyboard layout');
    await updateInputSource();
    notifyListeners();
  }

  /// Whether the layout and variant selections are valid.
  bool get isValid => _selectedLayoutIndex > -1 && _selectedVariantIndex > -1;

  /// Initializes the model and detects the current system keyboard layout and
  /// variant.
  Future<void> init() async {
    _layouts = await _client.keyboard().then((keyboard) {
      return keyboard.layouts.sortedBy((a) => removeDiacritics(a.name));
    });
    log.info('Loaded ${_layouts.length} keyboard layouts');
    final keyboard = await _client.keyboard();
    _selectedLayoutIndex = _layouts.indexWhere((layout) {
      return layout.code == keyboard.setting.layout;
    });
    if (_selectedLayoutIndex > -1) {
      _selectedVariantIndex = _selectedLayout!.variants.indexWhere((variant) {
        return (variant.code) == (keyboard.setting.variant);
      });
    }
    log.info(
        'Initialized ${_selectedLayout?.code} (${_selectedVariant?.code}) keyboard layout');
    notifyListeners();
  }

  /// Updates the system's input source to match the selected keyboard layout
  /// and variant.
  Future<void> updateInputSource() async {
    if (_selectedLayout == null) return;
    final layout = _selectedLayout!.code;
    final variant = _selectedVariant?.code;
    final keyboard = KeyboardSetting(layout: layout, variant: variant ?? '');
    log.info('Updated $layout ($variant) input source');
    return _client.setInputSource(keyboard);
  }

  /// Saves the selected keyboard layout and variant.
  Future<void> save() {
    final layout = _selectedLayout!.code;
    final variant = _selectedVariant?.code;
    final keyboard = KeyboardSetting(layout: layout, variant: variant ?? '');
    log.info('Saved $layout ($variant) keyboard layout');
    return _client.setKeyboard(keyboard);
  }
}
