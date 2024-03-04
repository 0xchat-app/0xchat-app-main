package com.ox.ox_push
import android.content.Context
import org.unifiedpush.android.foss_embedded_fcm_distributor.EmbeddedDistributorReceiver
class EmbeddedDistributor: EmbeddedDistributorReceiver() {
    override val googleProjectNumber = "871799832562" // This value comes from the google-services.json

    override fun getEndpoint(context: Context, token: String, instance: String): String {
        // This returns the endpoint of your FCM Rewrite-Proxy
        return "https://www.0xchat.com/FCM?v2&instance=$instance&token=$token"
    }

}