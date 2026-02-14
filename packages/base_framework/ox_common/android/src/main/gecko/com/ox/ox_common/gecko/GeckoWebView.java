package com.ox.ox_common.gecko;

import android.content.Context;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.mozilla.geckoview.GeckoRuntime;
import org.mozilla.geckoview.GeckoSession;
import org.mozilla.geckoview.GeckoView;

import io.flutter.plugin.platform.PlatformView;

/**
 * Flutter Platform View that embeds GeckoView for web content with optional SOCKS proxy (e.g. Tor).
 */
public class GeckoWebView implements PlatformView {
    private final FrameLayout container;
    private final GeckoView geckoView;
    private final GeckoSession session;

    public GeckoWebView(@NonNull Context context, int viewId, @Nullable Object args) {
        container = new FrameLayout(context);
        container.setLayoutParams(new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT));

        String url = null;
        String socksHost = null;
        Integer socksPort = null;
        if (args instanceof java.util.Map) {
            @SuppressWarnings("unchecked")
            java.util.Map<String, Object> params = (java.util.Map<String, Object>) args;
            if (params.get("url") != null) {
                url = params.get("url").toString();
            }
            if (params.get("socksHost") != null) {
                socksHost = params.get("socksHost").toString();
            }
            if (params.get("socksPort") != null) {
                Object p = params.get("socksPort");
                if (p instanceof Number) {
                    socksPort = ((Number) p).intValue();
                }
            }
        }

        GeckoRuntime runtime = GeckoRuntimeHolder.getRuntime(context, socksHost, socksPort);
        session = new GeckoSession();
        session.setContentDelegate(new GeckoSession.ContentDelegate() {});
        session.open(runtime);

        geckoView = new GeckoView(context);
        geckoView.setLayoutParams(new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT));
        geckoView.setSession(session);
        container.addView(geckoView);

        if (url != null && !url.isEmpty()) {
            session.loadUri(url);
        }
    }

    @Override
    @NonNull
    public View getView() {
        return container;
    }

    @Override
    public void dispose() {
        session.close();
    }

    public GeckoSession getSession() {
        return session;
    }
}
