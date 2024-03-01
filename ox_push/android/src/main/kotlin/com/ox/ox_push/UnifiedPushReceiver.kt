package com.ox.ox_push

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.PowerManager
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import java.util.concurrent.locks.ReentrantLock

/**
 * This receiver has to be declared on the application side
 * and getEngine has to be overriden to get the FlutterEngine
 */

private const val TAG = "UnifiedPushReceiver"

open class UnifiedPushReceiver : BroadcastReceiver() {
    private val handler = Handler()
    private var pluginChannel : MethodChannel? = null

    open fun getEngine(context: Context): FlutterEngine {
        return FlutterEngine(context).apply {
            localizationPlugin.sendLocalesToFlutter(
                context.resources.configuration
            )
            dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
        }
    }

    private fun getPlugin(context: Context): OXPushPlugin {
        val registry = getEngine(context).plugins
        return (registry.get(OXPushPlugin::class.java) as? OXPushPlugin)
            ?: (OXPushPlugin().apply {
              registry.add(this)
            })
    }

    private fun onMessage(message: ByteArray, instance: String) {
        Log.d(TAG, "OnMessage")
        val data = mapOf("instance" to instance,
            "message" to message)
        handler.post {
            pluginChannel?.invokeMethod("onMessage",  data)
        }
    }

    private fun onNewEndpoint(endpoint: String, instance: String) {
        Log.d(TAG, "OnNewEndpoint")
        val data = mapOf("instance" to instance,
            "endpoint" to endpoint)
        handler.post {
            pluginChannel?.invokeMethod("onNewEndpoint", data)
        }
    }

    private fun onRegistrationFailed(instance: String) {
        Log.d(TAG, "OnRegistrationFailed")
        val data = mapOf("instance" to instance)
        handler.post {
            pluginChannel?.invokeMethod("onRegistrationFailed", data)
        }
    }

    private fun onUnregistered(instance: String) {
        Log.d(TAG, "OnUnregistered")
        val data = mapOf("instance" to instance)
        handler.post {
            pluginChannel?.invokeMethod("onUnregistered", data)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        CoroutineScope(Dispatchers.IO + SupervisorJob()).launch {
            // Locking if it is not yet initialized
            if(!OXPushPlugin.isInit.get()) {
                rLock.lock()
                // If initialization has not been done on another thread
                if (!OXPushPlugin.isInit.get()) {
                    Log.d(TAG, "Initializing")
                    initChannel = Channel()
                    handleIntent(context, intent)
                    initChannel?.receive()
                    initChannel?.cancel()
                    initChannel = null
                } else {
                    handleIntent(context, intent)
                }
                if (rLock.isHeldByCurrentThread()) {
                    rLock.unlock()
                }
            } else {
                handleIntent(context, intent)
            }
        }
    }

    private suspend fun handleIntent(context: Context, intent: Intent) {
        val wakeLock = (context.getSystemService(Context.POWER_SERVICE) as PowerManager).run {
            newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, WAKE_LOCK_TAG).apply {
                acquire(60000L /*1min*/)
            }
        }
        withContext(Dispatchers.Main) {
            pluginChannel = OXPushPlugin.pluginChannel ?: getPlugin(context).getChannel()
        }
        val instance = intent.getStringExtra(INT_EXTRA_INSTANCE)!!
        when (intent.action) {
            INT_ACTION_NEW_ENDPOINT -> {
                val endpoint = intent.getStringExtra(INT_EXTRA_ENDPOINT)!!
                onNewEndpoint(endpoint, instance)
            }
            INT_ACTION_REGISTRATION_FAILED -> {
                onRegistrationFailed(instance)
            }
            INT_ACTION_UNREGISTERED -> {
                onUnregistered(instance)
            }
            INT_ACTION_MESSAGE -> {
                val message = intent.getByteArrayExtra(INT_EXTRA_MESSAGE)!!
                onMessage(message, instance)
            }
        }
        wakeLock?.let {
            if (it.isHeld) {
                it.release()
            }
        }
    }

    companion object {
        private val rLock = ReentrantLock()
        var initChannel: Channel<Any>? = null
    }
}
