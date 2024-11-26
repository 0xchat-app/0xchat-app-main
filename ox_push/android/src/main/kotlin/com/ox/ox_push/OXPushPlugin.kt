package com.ox.ox_push

import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONArray
import java.util.concurrent.atomic.AtomicBoolean

private const val TAG = "Plugin"

class OXPushPlugin : FlutterPlugin, MethodCallHandler {
  private var mContext : Context? = null


  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "onAttachedToEngine")
    mContext = binding.applicationContext
    pluginChannel = MethodChannel(binding.binaryMessenger, PLUGIN_CHANNEL).apply {
      setMethodCallHandler(this@OXPushPlugin)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "onDetachedFromEngine")
    pluginChannel?.setMethodCallHandler(null)
    pluginChannel = null
    mContext = null
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    Log.d(TAG, "Method: ${call.method}")
    val args = call.arguments<ArrayList<String>>()
    when(call.method) {
//      PLUGIN_EVENT_GET_DISTRIBUTORS -> getDistributors(mContext!!, args, result)
//      PLUGIN_EVENT_GET_DISTRIBUTOR -> getDistributor(mContext!!, result)
//      PLUGIN_EVENT_SAVE_DISTRIBUTOR -> saveDistributor(mContext!!, args, result)
//      PLUGIN_EVENT_REGISTER_APP -> registerApp(mContext!!, args, result)
//      PLUGIN_EVENT_UNREGISTER -> unregister(mContext!!, args, result)
//      PLUGIN_EVENT_INITIALIZED -> onInitialized(result)
      else -> result.notImplemented()
    }
  }

  companion object {
    var pluginChannel: MethodChannel? = null
      private set
    var isInit = AtomicBoolean(false)
      private set
  }
}
