package com.mhsensei.shake_app

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import kotlin.math.sqrt

class ShakeDetector(private val onShake: () -> Unit) : SensorEventListener {

    private val SHAKE_THRESHOLD = 15.0f
    private val SHAKE_TIME_WINDOW = 500L
    private val SHAKE_COUNT_THRESHOLD = 2

    private var lastShakeTime = 0L
    private var shakeCount = 0

    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            if (it.sensor.type == Sensor.TYPE_ACCELEROMETER) {
                val x = it.values[0]
                val y = it.values[1]
                val z = it.values[2]

                val acceleration = sqrt((x * x + y * y + z * z).toDouble()).toFloat()
                val accelerationExcludingGravity = acceleration - SensorManager.GRAVITY_EARTH

                if (accelerationExcludingGravity > SHAKE_THRESHOLD) {
                    val currentTime = System.currentTimeMillis()

                    if (currentTime - lastShakeTime < SHAKE_TIME_WINDOW) {
                        shakeCount++

                        if (shakeCount >= SHAKE_COUNT_THRESHOLD) {
                            onShake()
                            shakeCount = 0
                            lastShakeTime = currentTime
                        }
                    } else {
                        shakeCount = 1
                        lastShakeTime = currentTime
                    }
                }
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
    }
}
