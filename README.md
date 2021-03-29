# Light sensor

A Flutter plugin for Android allowing access to the device light sensor.

## Usage

To use this plugin, add `light_sensor` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Example

```dart
// Import package
import 'package:light_sensor/light_sensor.dart';

// Init plugin:
final LightSensor _light = LightSensor();

// Subscribe on updates:
_light.lightSensorStream.listen((lux) {...});
```

## Origin

Originally, this plugin was based on [`light`](https://pub.dev/packages/light).  
Functionality was extracted into this plugin due to lack of maintenance
by the author of the `light` plugin.

Today, the `light_sensor` plugin has been completely refreshed.
