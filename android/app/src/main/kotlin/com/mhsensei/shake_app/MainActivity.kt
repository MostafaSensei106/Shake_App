package com.mhsensei.shake_app

import io.flutter.embedding.android.FlutterActivity

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlin.math.sqrt

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL = "com.mhsensei.shake_quote/method"
    private val EVENT_CHANNEL = "com.mhsensei.shake_quote/shake"

    private var sensorManager: SensorManager? = null
    private var accelerometer: Sensor? = null
    private var shakeDetector: ShakeDetector? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startShakeDetection" -> {
                        startShakeDetection()
                        result.success("Shake detection started")
                    }
                    "stopShakeDetection" -> {
                        stopShakeDetection()
                        result.success("Shake detection stopped")
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })
    }

    private fun startShakeDetection() {
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)

        shakeDetector = ShakeDetector {
            eventSink?.success("onShakeDetected")
        }

        accelerometer?.let { sensor ->
            sensorManager?.registerListener(
                shakeDetector,
                sensor,
                SensorManager.SENSOR_DELAY_UI
            )
        }
    }

    private fun stopShakeDetection() {
        sensorManager?.unregisterListener(shakeDetector)
        shakeDetector = null
    }

    override fun onDestroy() {
        super.onDestroy()
        stopShakeDetection()
    }
}

