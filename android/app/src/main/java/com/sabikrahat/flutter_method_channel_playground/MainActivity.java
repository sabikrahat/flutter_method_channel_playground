package com.sabikrahat.flutter_method_channel_playground;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    static final String BATTERY_METHOD_CHANNEL = "com.sabikrahat.flutter_method_channel_playground/battery";
    private MethodChannel channel;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
        super.configureFlutterEngine(flutterEngine);

        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        channel = new MethodChannel(messenger, BATTERY_METHOD_CHANNEL);

        /// Receive data from Flutter
        channel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("getBatteryLevel")) {
                Map<String, String> arguments = call.arguments();
                String name = arguments.get("name");
                ///
                int batteryLevel = getBatteryLevel(getContext());
                result.success("Hello, " + name + "! Battery level is " + batteryLevel + "%.");
            } else {
                result.notImplemented();
            }
        });
    }

    private int getBatteryLevel(Context context) {
        int batteryLevel;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) context.getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(context).registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }
        return batteryLevel;
    }
}
