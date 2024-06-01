# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

-optimizationpasses 5

-dontusemixedcaseclassnames

-dontskipnonpubliclibraryclasses

-verbose
-ignorewarnings

-dontoptimize

-dontpreverify


-keepattributes *Annotation*


 -keep public class com.oxchat.nostr.R$*{
    public static final int *;
 }


-dontwarn org.apache.commons.codec_a.**
-keep class org.apache.commons.codec_a.**{*;}
-dontwarn com.eva.epc.common.**
-keep class com.eva.epc.common.**{*;}
-dontwarn com.alibaba.fastjson
-keep class com.alibaba.fastjson.**{*;}
-dontwarn com.google.**
-keep class com.google.**{*;}
-dontwarn org.apache.http.**
-keep class org.apache.http.**{*;}
-dontwarn org.apache.http.entity.mime.**
-keep class org.apache.http.entity.mime.**{*;}
-dontwarn net.openmob.mobileimsdk.android.**
-keep class net.openmob.mobileimsdk.android.**{*;}
-dontwarn net.openmob.mobileimsdk.server.protocal.**
-keep class net.openmob.mobileimsdk.server.protocal.**{*;}
-dontwarn okhttp3.**
-keep class okhttp3.**{*;}
-dontwarn okio.**
-keep class okio.**{*;}
-dontwarn com.paypal.android.sdk.**
-keep class com.paypal.android.sdk.**{*;}
-dontwarn io.card.payment.**
-keep class io.card.payment.**{*;}
-dontwarn com.hp.hpl.sparta.**
-keep class com.hp.hpl.sparta.**{*;}
-dontwarn net.sourceforge.pinyin4j.**
-keep class net.sourceforge.pinyin4j.**{*;}
-dontwarn net.x52im.rainbowav.sdk.**
-keep class net.x52im.rainbowav.sdk.**{*;}
-dontwarn com.vc.**
-keep class com.vc.**{*;}


-dontwarn com.geetest.captcha.**
-keep class com.geetest.captcha.**{*;}

# google.zxing
-dontwarn com.google.zxing.**
-keep class com.google.zxing.**{*;}

-keepclasseswithmembernames class * { native <methods>; }
-keep class com.android.internal.telephony.** {*;}

#sqflite_sqlcipher
-keep class net.sqlcipher.** { *; }
#secp256k1
-keep class fr.acinq.secp256k1.** { *; }