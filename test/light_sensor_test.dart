import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:light_sensor/light_sensor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'hasSensor()',
    () {
      tearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          LightSensor.methodChannel,
          null,
        );
      });

      test('true', () async {
        mockHasSensor(hasSensor: true);
        expectLater(LightSensor.hasSensor(), completion(true));
      });

      test('false', () async {
        mockHasSensor(hasSensor: false);
        expectLater(LightSensor.hasSensor(), completion(false));
      });

      test('null', () async {
        mockHasSensor(hasSensor: null);
        expectLater(LightSensor.hasSensor(), completion(false));
      });
    },
  );

  test('luxStream', () async {
    final stream = LightSensor.luxStream();
    final List<int> result = [];
    final subscription = stream.listen(result.add);
    await sendMockVolumeAction(LightSensor.eventChannel.name, 100);
    await sendMockVolumeAction(LightSensor.eventChannel.name, 150);
    await sendMockVolumeAction(LightSensor.eventChannel.name, 150);
    await sendMockVolumeAction(LightSensor.eventChannel.name, 200);
    expect(result, [100, 150, 150, 200]);
    subscription.cancel();
  });
}

void mockHasSensor({required bool? hasSensor}) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    LightSensor.methodChannel,
    (methodCall) async {
      switch (methodCall.method) {
        case "sensor":
          return hasSensor;
        default:
          return null;
      }
    },
  );
}

Future<void> sendMockVolumeAction(String channelName, int keyCode) async {
  await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
    channelName,
    const StandardMethodCodec().encodeSuccessEnvelope(keyCode),
    (ByteData? data) {},
  );
}
