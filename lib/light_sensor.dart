import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

class LightSensor {
  static Future<bool?> get hasSensor {
    return const MethodChannel('system_feature').invokeMethod<bool?>('sensor');
  }

  /// Getter for light stream, throws an exception if device isn't on Android platform
  static Stream<int> get lightSensorStream {
    if (Platform.isAndroid) {
      return const EventChannel("light.eventChannel").receiveBroadcastStream().map<int>((lux) {
        return lux as int;
      });
    }
    throw Exception('Light sensor API exclusively available on Android!');
  }
}
