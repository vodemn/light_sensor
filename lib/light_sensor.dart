import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

/// Custom Exception for the plugin,
/// thrown whenever the plugin is used on platforms other than Android
class LightException implements Exception {
  final String _cause;

  LightException(this._cause);

  @override
  String toString() {
    return _cause;
  }
}

class LightSensor {
  static const EventChannel _eventChannel = EventChannel("light.eventChannel");

  Stream<int>? _lightSensorStream;

  /// Getter for light stream, throws an exception if device isn't on Android platform
  Stream<int> get lightSensorStream {
    if (Platform.isAndroid) {
      return _lightSensorStream ??= _eventChannel.receiveBroadcastStream().map<int>((lux) {
        return lux as int;
      });
    }
    throw LightException('Light sensor API exclusively available on Android!');
  }
}
