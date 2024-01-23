package com.ox.ox_common.utils;

import java.lang.reflect.Method;
import java.util.Arrays;
/**
 * Title: ReflectHelper
 * Description: TODO(Fill in by oneself)
 *
 * @author john
 * @CheckItem Fill in by oneself
 * @since JDK1.8
 */
class ReflectHelper {
    public ReflectHelper() {
    }

    public static Object invokeStaticMethod(String var0, String var1, Class[] var2, Object[] var3) {
        return invokeStaticMethod(getClass(var0), var1, var2, var3);
    }

    public static Object invokeStaticMethod(Class var0, String var1, Class[] var2, Object[] var3) {
        return invokeStaticMethod(var0, var1, var2, var3, false);
    }

    public static Object invokeStaticMethod(Class var0, String var1, Class[] var2, Object[] var3, boolean var4) {
        return invokeMethod((Class)var0, var0, var1, var2, var3, var4);
    }

    public static Object invokeMethod(String var0, Object var1, String var2, Class[] var3, Object[] var4) {
        return invokeMethod(var0, var1, var2, var3, var4, false);
    }

    public static Object invokeMethod(String var0, Object var1, String var2, Class[] var3, Object[] var4, boolean var5) {
        Class var6 = getClass(var0);
        return invokeMethod(var6, var1, var2, var3, var4, var5);
    }

    public static Object invokeMethod(Class var0, Object var1, String var2, Class[] var3, Object[] var4) {
        return invokeMethod(var0, var1, var2, var3, var4, false);
    }

    public static Object invokeMethod(Class var0, Object var1, String var2, Class[] var3, Object[] var4, boolean var5) {
        Object var6 = null;
        if (var0 != null) {
            try {
                Method var7 = null;
                if (var5) {
                    var7 = var0.getDeclaredMethod(var2, var3);
                    var7.setAccessible(true);
                } else {
                    var7 = var0.getMethod(var2, var3);
                }

                if (var7 != null) {
                    var6 = var7.invoke(var1, var4);
                    System.out.println("@Calling method through reflection " + var0.getName() + "." + var2 + "(" + Arrays.toString(var3) + ") succeeded.");
                }
            } catch (Exception var8) {
                System.out.println("Failed to call method through reflection " + var0.getName() + "." + var2 + "(" + Arrays.toString(var3) + "), your Java version may need updating, " + var8.getMessage());
            }
        }

        return var6;
    }

    public static Class getClass(String var0) {
        try {
            return Class.forName(var0);
        } catch (Exception var2) {
            System.out.println("Failed to obtain Class object for " + var0 + " through reflection, your Java version may need updating, " + var2.getMessage());
            return null;
        }
    }
}
