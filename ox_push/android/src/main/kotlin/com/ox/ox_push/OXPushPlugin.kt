package com.ox.ox_push

import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import org.json.JSONArray
import java.util.concurrent.atomic.AtomicBoolean
import org.unifiedpush.android.connector.UnifiedPush as up

private const val TAG = "Plugin"

class OXPushPlugin : FlutterPlugin, MethodCallHandler {
    private var mContext : Context? = null

    private fun getDistributors(context: Context,
                                args: ArrayList<String>?,
                                result: MethodChannel.Result){
        val features = parseFeatures(args?.get(0))
        val distributors = up.getDistributors(context, features = features)
        result.success(distributors)
    }

    private fun getDistributor(context: Context,
                               result: MethodChannel.Result) {
        result.success(up.getAckDistributor(context))
    }

    private fun saveDistributor(context: Context,
                                args: ArrayList<String>?,
                                result: MethodChannel.Result) {
        val distributor = args?.get(0) ?: run {
            result.success(false)
            return
        }
        up.saveDistributor(context, distributor)
        result.success(true)
    }

    private fun registerApp(context: Context,
                            args: ArrayList<String>?,
                            result: MethodChannel.Result) {
        val instance = args?.get(0)
        val features = parseFeatures(args?.get(1))
        Log.d(TAG, "registerApp: instance=$instance")
        if (instance.isNullOrBlank()) {
            up.registerApp(context, features = features)
        } else {
            up.registerApp(context, instance, features = features)
        }
        result.success(true)
    }

    private fun unregister(context: Context,
                           args: ArrayList<String>?,
                           result: MethodChannel.Result) {
        val instance = args?.get(0)
        Log.d(TAG, "unregisterApp: instance=$instance")
        if (instance.isNullOrEmpty()) {
            up.unregisterApp(context)
        } else {
            up.unregisterApp(context, instance)
        }
        result.success(true)
    }

    private fun parseFeatures(arg: String?): ArrayList<String> {
        val jsonArray = JSONArray(arg ?: "[]")
        val knownFeatures = arrayOf(up.FEATURE_BYTES_MESSAGE)
        return (0 until jsonArray.length()).mapNotNull {
            val feature = jsonArray.getString(it)
            if (knownFeatures.contains(feature)) {
                feature
            } else {
                null
            }
        } as ArrayList<String>
    }

    private fun onInitialized(result: MethodChannel.Result) {
        UnifiedPushReceiver.initChannel?.let {
            CoroutineScope(Dispatchers.IO + SupervisorJob()).launch {
                it.send(Any())
            }
        }
        isInit.set(true)
        result.success(true)
    }

    fun getChannel(): MethodChannel? {
        return pluginChannel
    }

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
            PLUGIN_EVENT_GET_DISTRIBUTORS -> getDistributors(mContext!!, args, result)
            PLUGIN_EVENT_GET_DISTRIBUTOR -> getDistributor(mContext!!, result)
            PLUGIN_EVENT_SAVE_DISTRIBUTOR -> saveDistributor(mContext!!, args, result)
            PLUGIN_EVENT_REGISTER_APP -> registerApp(mContext!!, args, result)
            PLUGIN_EVENT_UNREGISTER -> unregister(mContext!!, args, result)
            PLUGIN_EVENT_INITIALIZED -> onInitialized(result)
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
