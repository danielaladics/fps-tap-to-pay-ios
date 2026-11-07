import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

/// Apple's built-in Tap to Pay on iPhone merchant education.
///
/// On iOS 18 and later this presents the system "How to Tap" sheet
/// (ProximityReaderDiscovery), which Apple keeps up to date and localized,
/// including PIN entry guidance. On older iOS versions and on other platforms
/// it does nothing and returns `false`, so the app can show its own screens.
class FpsTapToPayIos {
  FpsTapToPayIos._();

  static const MethodChannel _channel = MethodChannel('fps_tap_to_pay_ios');

  static bool get _isIos => !kIsWeb && Platform.isIOS;

  /// Whether the Apple education sheet can be shown on this device.
  static Future<bool> isEducationAvailable() async {
    if (!_isIos) return false;
    try {
      return await _channel.invokeMethod<bool>('isEducationAvailable') ?? false;
    } on MissingPluginException {
      return false;
    }
  }

  /// Presents the "How to Tap" education sheet.
  ///
  /// Returns `true` when the sheet was shown, `false` when it is not available
  /// on this device. Throws a [PlatformException] if iOS reports an error.
  static Future<bool> showEducation() async {
    if (!_isIos) return false;
    try {
      return await _channel.invokeMethod<bool>('showEducation') ?? false;
    } on MissingPluginException {
      return false;
    }
  }
}
