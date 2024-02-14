package com.example.my_map

import io.flutter.embedding.android.FlutterActivity
import com.yandex.mapkit.MapKitFactory
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant;


class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("e57033e8-ce9f-4410-9bb6-729ef8327d76")
        super.configureFlutterEngine(flutterEngine)
    }
}
