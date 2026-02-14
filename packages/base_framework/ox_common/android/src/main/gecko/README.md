# GeckoView (Android)

GeckoView is always included on Android so that in-app web content (NAPPS) can use the app's configured proxy/Tor. The default Android WebView does not respect app-level proxy.

## First-time setup: generate no-WebRTC AAR

GeckoView’s official AAR includes WebRTC, which conflicts with `flutter_webrtc` (ox_calling). We use a **local AAR with `org.webrtc` stripped**.

Run once (from repo root or this package):

```bash
cd packages/base_framework/ox_common/android && ./strip_webrtc_from_geckoview.sh
```

This downloads the official GeckoView nightly AAR, removes the `org.webrtc` classes, and writes `libs/geckoview-nightly-no-webrtc.aar`. After that, normal builds (`flutter build apk` or `./gradlew :app:assembleDebug`) include GeckoView; when proxy/Tor is enabled, NAPPS load in GeckoView and traffic goes through the app proxy.
