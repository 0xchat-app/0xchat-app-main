package com.oxchat.nostrcore

import android.content.Context
import android.content.Intent
import android.net.Uri

/**
 * Title: PackageUtils
 * Description: TODO(Fill in by oneself)
 * Copyright: Copyright (c) 2022
 * Company:  0xchat Teachnology
 * CreateTime: 2023/12/4 15:17
 *
 * @author Michael
 * @since JDK1.8
 */
object PackageUtils {
    fun isPackageInstalled(context: Context, target: String): Boolean {
        return context.packageManager.getInstalledApplications(0).find { info -> info.packageName == target } != null
    }
    
    /**
     * Check if a package is installed without requiring QUERY_ALL_PACKAGES permission
     * by attempting to resolve an intent for the package
     */
    fun isPackageInstalledWithoutPermission(context: Context, packageName: String): Boolean {
        return try {
            val intent = Intent().setPackage(packageName)
            val resolveInfo = context.packageManager.resolveActivity(intent, 0)
            resolveInfo != null
        } catch (e: Exception) {
            false
        }
    }
    
    /**
     * Check if nostrsigner scheme is supported by any installed app
     */
    fun isNostrSignerSupported(context: Context): Boolean {
        return try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("nostrsigner:test"))
            val resolveInfo = context.packageManager.resolveActivity(intent, 0)
            resolveInfo != null
        } catch (e: Exception) {
            false
        }
    }
    
    /**
     * Get all installed apps that support nostrsigner:// scheme
     * Returns a list of maps containing packageName and appName
     * Reference: NIP-55 https://github.com/nostr-protocol/nips/blob/master/55.md
     */
    fun getInstalledExternalSigners(context: Context): List<Map<String, String>> {
        return try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("nostrsigner:"))
            val resolveInfoList = context.packageManager.queryIntentActivities(intent, 0)
            resolveInfoList.map { info ->
                mapOf(
                    "packageName" to info.activityInfo.packageName,
                    "appName" to info.loadLabel(context.packageManager).toString()
                )
            }
        } catch (e: Exception) {
            emptyList()
        }
    }
}