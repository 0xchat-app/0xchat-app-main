package com.oxchat.nostrcore

import android.app.Activity
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import fr.acinq.secp256k1.Secp256k1

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import java.util.*
import java.util.concurrent.ConcurrentHashMap
import kotlin.collections.HashMap


/** ChatcorePlugin */
class ChatcorePlugin : FlutterPlugin, MethodCallHandler, ActivityAware, ActivityResultListener {
    companion object {
        private const val OX_CORE_CHANNEL = "com.oxchat.nostrcore"
    }

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var mContext: Context
    private lateinit var mActivity: Activity
    private var mMethodChannelResultMap: HashMap<Int, Result?> = HashMap<Int, Result?>()
    private var mSignatureRequestCodeList: MutableSet<Int> = mutableSetOf()
    private val mDefaultSignerPackageName: String = "com.greenart7c3.nostrsigner"
    private val secp256k1 = Secp256k1.get()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        mContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, OX_CORE_CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
    override fun onDetachedFromActivity() {}

    override fun onMethodCall(call: MethodCall, result: Result) {
        var paramsMap: HashMap<*, *>? = null
        if (call.arguments != null && call.arguments is HashMap<*, *>) {
            paramsMap = call.arguments as HashMap<*, *>
        }
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
                return
            }
            "verifySignature" -> {
                if (paramsMap != null) verifySignature(call, result)
                return
            }
            "signSchnorr" -> {
                if (paramsMap != null) signSchnorr(call, result)
                return
            }
            "isAppInstalled" -> {
                paramsMap?.let { map ->
                    val packageName: String? = map["packageName"] as? String
                    if (packageName != null) {
                        Log.d("ChatcorePlugin", "Checking if app is installed: $packageName")
                        // Use the new method that doesn't require QUERY_ALL_PACKAGES permission
                        val isInstalled: Boolean = PackageUtils.isPackageInstalledWithoutPermission(mContext, packageName)
                        Log.d("ChatcorePlugin", "App installation result: $isInstalled")
                        result.success(isInstalled)
                    }
                }
                return
            }
            "isNostrSignerSupported" -> {
                Log.d("ChatcorePlugin", "Checking if nostrsigner scheme is supported")
                val isSupported: Boolean = PackageUtils.isNostrSignerSupported(mContext)
                Log.d("ChatcorePlugin", "NostrSigner support result: $isSupported")
                result.success(isSupported)
                return
            }
            "getInstalledExternalSigners" -> {
                Log.d("ChatcorePlugin", "Getting installed external signers")
                val signers = PackageUtils.getInstalledExternalSigners(mContext)
                Log.d("ChatcorePlugin", "Found ${signers.size} external signers")
                result.success(signers)
                return
            }
            "nostrsigner" -> {
                if (paramsMap != null) nostrsigner(paramsMap, result)
                return
            }
            "nostrsigner_content_provider" -> {
                if (paramsMap != null) nostrsignerContentProvider(paramsMap, result)
                return
            }
            else -> {
                result.notImplemented()
                return
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, result: Intent?): Boolean {
        if (mSignatureRequestCodeList.contains(requestCode)) {
            val resultCallback = mMethodChannelResultMap[requestCode]
            if (resultCode == Activity.RESULT_OK && result != null) {
                val dataMap: HashMap<String, String?> = HashMap()

                if (result.extras != null){
                    Log.e("Michael", "${result.extras!!.keySet()}")
                }
                if (result.hasExtra("result")) {
                    val resultValue = result.getStringExtra("result")
                    dataMap["result"] = resultValue
                }
                if (result.hasExtra("signature")) {
                    val signature = result.getStringExtra("signature")
                    dataMap["signature"] = signature
                }
                if (result.hasExtra("id")) {
                    val id = result.getStringExtra("id")
                    dataMap["id"] = id
                }
                if (result.hasExtra("event")) {
                    val event = result.getStringExtra("event")
                    dataMap["event"] = event
                }
                resultCallback?.success(dataMap)
            } else {
                // Request was rejected (resultCode != RESULT_OK)
                // Try to extract kind from the stored request params
                val rejectedMap: HashMap<String, String?> = HashMap()
                rejectedMap["rejected"] = "true"
                // Note: We can't easily get the kind here without storing request params
                // The Flutter side will extract kind from eventJson if needed
                resultCallback?.success(rejectedMap)
            }
            mMethodChannelResultMap.remove(requestCode)
            mSignatureRequestCodeList.remove(requestCode)
            return true
        }
        return false
    }

    private fun nostrsigner (paramsMap: HashMap<*, *>, result: Result){
        // Check if we should use Content Provider first
        val useContentProvider = paramsMap["useContentProvider"] as? Boolean ?: false
        val callMethod = paramsMap["callMethod"] as? String ?: "intent"
        val type = paramsMap["type"] as? String ?: "get_public_key"
        val packageName = paramsMap["packageName"] as? String ?: mDefaultSignerPackageName
        
        // For auto mode, try Content Provider first
        if (callMethod == "auto" || useContentProvider) {
            val resultFromCR: HashMap<String, String?>? = getDataContentResolver(paramsMap)
            if (!resultFromCR.isNullOrEmpty()) {
                result.success(resultFromCR)
                return
            }
        }
        
        // Use Intent method
        val requestCode = result.hashCode()
        mSignatureRequestCodeList.add(requestCode)
        mMethodChannelResultMap[requestCode] = result
        var extendParse: String? = paramsMap["extendParse"] as? String
        val intent = Intent(
            Intent.ACTION_VIEW, Uri.parse(
                "nostrsigner:$extendParse"
            )
        )
        intent.`package` = packageName
        paramsMap["permissions"]?.let { permissions ->
            if (permissions is String) intent.putExtra("permissions", permissions)
        }

        intent.putExtra("type", type)

        paramsMap["id"]?.let { id ->
            if (id is String) intent.putExtra("id", id)
        }
        paramsMap["current_user"]?.let { currentUser ->
            if (currentUser is String) intent.putExtra("current_user", currentUser)
        }
        paramsMap["pubKey"]?.let { pubKey ->
            if (pubKey is String) intent.putExtra("pubKey", pubKey)
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        try {
            mActivity.startActivityForResult(intent, requestCode)
        } catch (e: Exception) {
            Log.e("ChatcorePlugin", "[nostrsigner] Failed to start Activity: ${e.message}")
            mMethodChannelResultMap.remove(requestCode)
            mSignatureRequestCodeList.remove(requestCode)
            result.error("ActivityStartError", "Failed to start amber sign", null)
        }
    }

    fun getDataContentResolver(paramsMap: HashMap<*, *>): HashMap<String, String?>? {
        var type: String = paramsMap["type"] as? String ?: "get_public_key"
        var extendParse: String = paramsMap["extendParse"] as? String ?: ""
        var data = arrayOf(extendParse)
        paramsMap["pubKey"]?.let { pubKey ->
            if (pubKey is String) data += pubKey
        }
        paramsMap["current_user"]?.let { currentUser ->
            if (currentUser is String) data += currentUser
        }
        val packageName = paramsMap["packageName"] as? String ?: mDefaultSignerPackageName
        return getDataFromResolver(type, data, mContext.contentResolver, packageName);
    }

    fun getDataFromResolver(
        signerType: String, data: Array<out String>, contentResolver: ContentResolver, packageName: String = mDefaultSignerPackageName
    ): HashMap<String, String?>? {
        val uri = "content://${packageName}.${signerType.uppercase()}"
        try {
            contentResolver.query(
                Uri.parse(uri),
                data,
                null,
                null,
                null
            ).use {
                if (it == null) {
                    return null
                }
                if (it.moveToFirst()) {
                    // Check for rejection first (NIP-55: if user chose to always reject, signer returns "rejected" column)
                    val rejectedIndex = it.getColumnIndex("rejected")
                    if (rejectedIndex >= 0) {
                        // Extract kind from eventJson if available (for sign_event type)
                        val kind = extractKindFromData(data, signerType)
                        val rejectedMap: HashMap<String, String?> = HashMap()
                        rejectedMap["rejected"] = "true"
                        if (kind != null) {
                            rejectedMap["rejected_kind"] = kind.toString()
                        }
                        return rejectedMap
                    }
                    
                    val dataMap: HashMap<String, String?> = HashMap()
                    
                    // Try to get 'result' field first (preferred by Aegis)
                    val resultIndex = it.getColumnIndex("result")
                    if (resultIndex >= 0) {
                        val result = it.getString(resultIndex)
                        dataMap["result"] = result
                    }
                    
                    // Try to get 'signature' field (fallback)
                    val signatureIndex = it.getColumnIndex("signature")
                    if (signatureIndex >= 0) {
                        val signature = it.getString(signatureIndex)
                        dataMap["signature"] = signature
                    }
                    
                    // Try to get 'event' field
                    val eventIndex = it.getColumnIndex("event")
                    if (eventIndex >= 0) {
                        val eventJson = it.getString(eventIndex)
                        dataMap["event"] = eventJson
                    }
                    
                    return dataMap;
                }
            }
        } catch (e: Exception) {
            Log.e("ChatcorePlugin", "[getDataFromResolver] Failed to query the Signer app: ${e.message}")
            return null
        }

        return null
    }
    
    // Extract kind from eventJson for sign_event type
    private fun extractKindFromData(data: Array<out String>, signerType: String): Int? {
        if (signerType != "sign_event" || data.isEmpty()) {
            return null
        }
        try {
            // For sign_event, the first element is the eventJson
            val eventJson = data[0]
            if (eventJson.isNotEmpty()) {
                // Parse JSON to extract kind
                val jsonObject = org.json.JSONObject(eventJson)
                if (jsonObject.has("kind")) {
                    return jsonObject.getInt("kind")
                }
            }
        } catch (e: Exception) {
            Log.e("ChatcorePlugin", "[extractKindFromData] Failed to extract kind: ${e.message}")
        }
        return null
    }

    fun nostrsignerContentProvider(paramsMap: HashMap<*, *>, result: Result) {
        try {
            val packageName = paramsMap["packageName"] as? String ?: mDefaultSignerPackageName
            val contentProviderUri = paramsMap["contentProviderUri"] as? String
            val data = paramsMap["data"] as? List<*> ?: emptyList<Any>()
            val type = paramsMap["type"] as? String ?: "get_public_key"

            if (contentProviderUri == null) {
                result.error("InvalidConfig", "Content Provider URI is required", null)
                return
            }

            val dataArray = data.mapNotNull { it as? String }.toTypedArray()
            val resultMap = getDataFromResolverWithUri(contentProviderUri, dataArray, mContext.contentResolver)

            if (resultMap != null) {
                // Check if this is a rejection response
                if (resultMap["rejected"] == "true") {
                    // Pass through the rejection info including rejected_kind
                    result.success(resultMap)
                } else {
                    // Convert signature to result for consistency, but prioritize result field
                    val convertedMap = HashMap<String, String?>()
                    // Prioritize 'result' field, fallback to 'signature'
                    val resultValue = resultMap["result"] ?: resultMap["signature"]
                    resultValue?.let { convertedMap["result"] = it }
                    resultMap["event"]?.let { convertedMap["event"] = it }
                    resultMap["id"]?.let { convertedMap["id"] = it }
                    result.success(convertedMap)
                }
            } else {
                result.success(null)
            }
        } catch (e: Exception) {
            Log.e("ChatcorePlugin", "[nostrsignerContentProvider] Failed to query Content Provider: ${e.message}")
            result.error("ContentProviderError", "Failed to query Content Provider: ${e.message}", null)
        }
    }

    fun getDataFromResolverWithUri(
        contentProviderUri: String, data: Array<out String>, contentResolver: ContentResolver
    ): HashMap<String, String?>? {
        try {
            contentResolver.query(
                Uri.parse(contentProviderUri),
                data,
                null,
                null,
                null
            ).use { cursor ->
                if (cursor == null) {
                    return null
                }
                
                // Check for rejection (NIP-55: if user chose to always reject, signer returns "rejected" column)
                val rejectedIndex = cursor.getColumnIndex("rejected")
                if (rejectedIndex >= 0) {
                    // Extract kind from data if available (for sign_event type)
                    val kind = extractKindFromDataForUri(data, contentProviderUri)
                    val rejectedMap: HashMap<String, String?> = HashMap()
                    rejectedMap["rejected"] = "true"
                    if (kind != null) {
                        rejectedMap["rejected_kind"] = kind.toString()
                    }
                    return rejectedMap
                }
                
                if (cursor.moveToFirst()) {
                    val dataMap: HashMap<String, String?> = HashMap()
                    
                    // Get result column
                    val resultIndex = cursor.getColumnIndex("result")
                    if (resultIndex >= 0) {
                        val resultValue = cursor.getString(resultIndex)
                        dataMap["result"] = resultValue
                    }
                    
                    // Get signature column (for backward compatibility)
                    val signatureIndex = cursor.getColumnIndex("signature")
                    if (signatureIndex >= 0) {
                        val signature = cursor.getString(signatureIndex)
                        dataMap["signature"] = signature
                    }
                    
                    // Get event column
                    val eventIndex = cursor.getColumnIndex("event")
                    if (eventIndex >= 0) {
                        val eventJson = cursor.getString(eventIndex)
                        dataMap["event"] = eventJson
                    }
                    
                    return dataMap
                }
            }
        } catch (e: Exception) {
            Log.e("ChatcorePlugin", "[getDataFromResolverWithUri] Failed to query Content Provider: ${e.message}")
            return null
        }

        return null
    }
    
    // Extract kind from data for Content Provider URI method
    private fun extractKindFromDataForUri(data: Array<out String>, contentProviderUri: String): Int? {
        // Check if this is a sign_event request
        if (!contentProviderUri.contains("SIGN_EVENT", ignoreCase = true) || data.isEmpty()) {
            return null
        }
        try {
            // For sign_event, the first element is the eventJson
            val eventJson = data[0]
            if (eventJson.isNotEmpty()) {
                // Parse JSON to extract kind
                val jsonObject = org.json.JSONObject(eventJson)
                if (jsonObject.has("kind")) {
                    return jsonObject.getInt("kind")
                }
            }
        } catch (e: Exception) {
            Log.e("ChatcorePlugin", "[extractKindFromDataForUri] Failed to extract kind: ${e.message}")
        }
        return null
    }

    fun verifySignature(call: MethodCall, result: Result) {
        val sig: ByteArray? = call.argument<ByteArray>("signature");
        val hash: ByteArray? = call.argument<ByteArray>("hash");
        val pubKey: ByteArray? = call.argument<ByteArray>("pubKey");

        if (sig != null && hash != null && pubKey != null) {
            result.success(secp256k1.verifySchnorr(sig, hash, pubKey))
        } else {
            // Handle the case where any of the arguments is null
            result.success(false)
        }
    }

    fun signSchnorr(call: MethodCall, result: Result) {
        val data: ByteArray? = call.argument<ByteArray>("data");
        val privKey: ByteArray? = call.argument<ByteArray>("privKey");

        if (data != null && privKey != null) {
            result.success(secp256k1.signSchnorr(data, privKey, null))
        } else {
            // Handle the case where any of the arguments is null
            result.success(false)
        }
    }

}