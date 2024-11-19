package com.example.wallpapers

import android.os.Bundle
import com.applovin.sdk.AppLovinSdk
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppLovinSdk.getInstance(this).initializeSdk()
        AppLovinSdk.getInstance(this).setMediationProvider("max")
    }
}
