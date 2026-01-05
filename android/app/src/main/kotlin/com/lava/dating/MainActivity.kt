package com.lava.dating

import android.content.pm.ActivityInfo
import android.os.Build
import android.view.View
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        try {
            super.onCreate(savedInstanceState)
            // Force portrait orientation
            requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onPostResume() {
        try {
            super.onPostResume()
            // Enable edge-to-edge display for transparent navigation bar
            if (window != null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    window.setDecorFitsSystemWindows(false)
                } else {
                    @Suppress("DEPRECATION")
                    window.decorView.systemUiVisibility = (
                        View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    )
                }
                WindowCompat.setDecorFitsSystemWindows(window, false)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
