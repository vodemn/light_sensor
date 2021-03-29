import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  final LightSensor _light = LightSensor();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Plugin example app')),
            body: Center(
                child: StreamBuilder<int>(
                    stream: _light.lightSensorStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text('Running on: ${snapshot.data} LUX');
                      } else {
                        return const Text('Running on: unknown');
                      }
                    }))));
  }
}
