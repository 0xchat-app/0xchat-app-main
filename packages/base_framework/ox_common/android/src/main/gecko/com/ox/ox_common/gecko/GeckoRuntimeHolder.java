package com.ox.ox_common.gecko;

import android.content.Context;
import android.util.Log;

import org.mozilla.geckoview.GeckoRuntime;
import org.mozilla.geckoview.GeckoRuntimeSettings;

/**
 * Singleton holder for GeckoRuntime. Gecko allows only one runtime per process.
 * Proxy (SOCKS) is applied at creation time; first caller's proxy params are used until process ends.
 */
public final class GeckoRuntimeHolder {
    private static final String TAG = "GeckoRuntimeHolder";

    private static volatile GeckoRuntime sRuntime;

    /**
     * Get or create the single GeckoRuntime. If socksHost and socksPort are non-null,
     * configures SOCKS proxy (e.g. for Tor). Otherwise uses direct connection.
     */
    public static synchronized GeckoRuntime getRuntime(Context context, String socksHost, Integer socksPort) {
        if (sRuntime == null) {
            GeckoRuntimeSettings.Builder builder = new GeckoRuntimeSettings.Builder();
            if (socksHost != null && !socksHost.isEmpty() && socksPort != null && socksPort > 0) {
                String proxyArg = "socks://" + socksHost + ":" + socksPort;
                builder.arguments(new String[]{proxyArg});
                Log.d(TAG, "GeckoRuntime with SOCKS proxy: " + proxyArg);
            }
            sRuntime = GeckoRuntime.create(context, builder.build());
        }
        return sRuntime;
    }
}
