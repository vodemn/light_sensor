import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LightSensor {
  @visibleForTesting
  static const methodChannel = MethodChannel('com.vodemn.light_sensor');

  @visibleForTesting
  static const eventChannel = EventChannel("com.vodemn.light_sensor.stream");

  static Future<bool?> get hasSensor {
    return methodChannel.invokeMethod<bool?>('sensor');
  }

  static Stream<int> get lightSensorStream {
    return eventChannel.receiveBroadcastStream().map<int>((lux) => lux as int);
  }
}
