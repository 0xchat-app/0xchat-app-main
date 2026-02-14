package com.ox.ox_common.gecko;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * Creates GeckoWebView instances for the Flutter side (AndroidView with viewType "ox_geckoview").
 */
public final class GeckoWebViewFactory extends PlatformViewFactory {

    private final Context context;

    public GeckoWebViewFactory(@NonNull Context context) {
        super(StandardMessageCodec.INSTANCE);
        this.context = context.getApplicationContext();
    }

    @Override
    @NonNull
    public PlatformView create(@NonNull Context context, int viewId, @Nullable Object args) {
        return new GeckoWebView(context, viewId, args);
    }
}
