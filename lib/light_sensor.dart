import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LightSensor {
  @visibleForTesting
  static const methodChannel = MethodChannel('com.vodemn.light_sensor');

  @visibleForTesting
  static const eventChannel = EventChannel("com.vodemn.light_sensor.stream");

  static Future<bool> hasSensor() async {
    return (await methodChannel.invokeMethod<bool?>('sensor')) ?? false;
  }

  static Stream<int> luxStream() {
    return eventChannel.receiveBroadcastStream().map<int>((lux) => lux as int);
  }
}
