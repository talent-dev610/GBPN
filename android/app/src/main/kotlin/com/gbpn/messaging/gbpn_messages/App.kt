package com.gbpn.messaging.gbpn_messages

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication


class App : FlutterApplication() {
    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}