package com.ox.ox_network

import android.content.Context
import android.net.Proxy
import android.os.Build
import android.text.TextUtils
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception

/** OXNetworkPlugin */
class OXNetworkPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var mContext: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        mContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ox_network")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "getProxyAddress") {
            //Get proxy address
            val IS_ICS_OR_LATER = Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH
            var proxyAddress: String
            var proxyPort: Int
            try {
                if (IS_ICS_OR_LATER) {
                    proxyAddress = System.getProperty("http.proxyHost")
                    val portStr = System.getProperty("http.proxyPort")
                    proxyPort = (portStr ?: "-1").toInt()
                } else {
                    proxyAddress = Proxy.getHost(mContext)
                    proxyPort = Proxy.getPort(mContext)
                }
            } catch (e: Exception) {
                proxyAddress = "";
                proxyPort = -1;
            }
            if (TextUtils.isEmpty(proxyAddress)) {
                result.success("")
            } else {
                result.success("$proxyAddress:$proxyPort")
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
