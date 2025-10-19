package com.example.frontend_water_quality

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "aquaminds/deeplink"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Ensure all Flutter plugins are registered (needed when overriding configureFlutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialLink" -> {
                    val data: Uri? = intent?.data
                    val uriString = data?.toString()
                    // Consume the initial link so it is not delivered again
                    intent?.data = null
                    setIntent(intent)
                    result.success(uriString)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val data: Uri? = intent.data
        data?.toString()?.let { uriString ->
            methodChannel?.invokeMethod("onDeepLink", uriString)
            // Consume the deep link so it won't be re-used unintentionally
            intent.data = null
            setIntent(intent)
        }
    }
}
