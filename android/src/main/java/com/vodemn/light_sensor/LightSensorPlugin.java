package com.vodemn.light_sensor;

import androidx.annotation.NonNull;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.io.InvalidObjectException;

/** LightSensorPlugin */
public class LightSensorPlugin implements FlutterPlugin, EventChannel.StreamHandler, MethodChannel.MethodCallHandler {
  private SensorEventListener sensorEventListener = null;
  private SensorManager sensorManager = null;
  private Sensor sensor = null;
  private EventChannel eventChannel = null;
  private MethodChannel sensorChannel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
      /// Init sensor manager
      Context context = flutterPluginBinding.getApplicationContext();
      sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
      sensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);
      BinaryMessenger binaryMessenger = flutterPluginBinding.getBinaryMessenger();

      /// Init event channel
      eventChannel = new EventChannel(binaryMessenger, "light.eventChannel");
      eventChannel.setStreamHandler(this);

      sensorChannel = new MethodChannel(binaryMessenger, "system_feature");
      sensorChannel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
      /// Cancel the handling of stream data
      eventChannel.setStreamHandler(null);
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
      /// Set up the event sensor for the light sensor
      sensorEventListener = createSensorEventListener(events);
      sensorManager.registerListener(sensorEventListener, sensor, SensorManager.SENSOR_DELAY_NORMAL);
  }

  @Override
  public void onCancel(Object arguments) {
      /// Finish listening to events
      sensorManager.unregisterListener(sensorEventListener);
  }

  SensorEventListener createSensorEventListener(final EventChannel.EventSink events) {
      return new SensorEventListener() {
          @Override
          public void onAccuracyChanged(Sensor sensor, int accuracy) {
              /// Do nothing
          }

          @Override
          public void onSensorChanged(SensorEvent event) {
              /// Extract lux value and send it to Flutter via the event sink
              int lux = (int) event.values[0];
              events.success(lux);
          }
      };
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    if (call.method.equals("sensor")) {
        result.success(sensor != null);
    } else {
        result.notImplemented();
    }
  }
}
