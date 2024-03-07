package com.ox.ox_push
import android.content.Context
import org.unifiedpush.android.foss_embedded_fcm_distributor.EmbeddedDistributorReceiver
class EmbeddedDistributor: EmbeddedDistributorReceiver() {
    override val googleProjectNumber = "871799832562"

    override fun getEndpoint(context: Context, token: String, instance: String): String {
        return "Embedded-FCM/FCM?v2&instance=$instance&token=$token"
    }

}