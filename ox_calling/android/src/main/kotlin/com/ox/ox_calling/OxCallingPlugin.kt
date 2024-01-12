package com.ox.ox_calling

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothProfile
import android.content.Context
import android.media.AudioManager
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.getSystemService
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** OxCallingPlugin */
class OxCallingPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var mContext: Context
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    mContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ox_calling")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "setSpeakerStatus") {
      var userSetValue = call.argument<Boolean>("isSpeakerOn")!!
      val audioManager = mContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
      audioManager.setMode(AudioManager.MODE_IN_COMMUNICATION);
      audioManager.setSpeakerphoneOn(userSetValue);
    } else if (call.method == "switchAudioOutput") {
      val output: Int = call.argument("output") !!
      switchAudioOutput(output)
      result.success(null)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun switchAudioOutput(output: Int) {
    val audioManager = mContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager?
      ?: return
    when (output) {

      OutputType.speaker.ordinal -> {
        audioManager.isSpeakerphoneOn = true
      }

      OutputType.handset.ordinal -> {
        audioManager.isSpeakerphoneOn = false
      }

      OutputType.bluetoothHeadset.ordinal  -> {
        connectToBluetoothHeadset(audioManager)
      }

      else -> {}
    }
  }

  private fun connectToBluetoothHeadset(audioManager: AudioManager) {
    val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
    if (bluetoothAdapter != null) {
      if (!bluetoothAdapter.isEnabled) {
        // Bluetooth is not enabled, the user can be prompted or enabled automatically
        return
      }
      bluetoothAdapter.getProfileProxy(mContext, object : BluetoothProfile.ServiceListener {
        override fun onServiceConnected(profile: Int, proxy: BluetoothProfile) {
          if (profile == BluetoothProfile.HEADSET) {
            audioManager.isBluetoothScoOn = true
            audioManager.startBluetoothSco()
          }
        }

        override fun onServiceDisconnected(profile: Int) {
          // Handle Bluetooth service disconnections
        }
      }, BluetoothProfile.HEADSET)
    }
  }
}

enum class OutputType{
  speaker,
  handset,
  bluetoothHeadset,
}