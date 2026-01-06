package com.ox.ox_common.utils;

import android.annotation.SuppressLint;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FormatUtil {
    private static final String TAG = "FormatUtil";
    private static DecimalFormat sDecimalFormat = new DecimalFormat();

    /**
     * Method to check if a string consists only of digits.
     *
     * @param
     * @return
     */
    public static boolean isNumeric(String str) {
        Pattern pattern = Pattern.compile("[0-9]*");
        Matcher isNum = pattern.matcher(str);
        if (!isNum.matches() || str.isEmpty()) {
            return false;
        }
        return true;
    }

    public static double parseDouble(String value) {
        double result = 0.0;
        try {
            result = Double.parseDouble(value);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        return result;

    }

    public static int parseInt(String value) {
        int result = 0;
        try {
            result = Integer.parseInt(value);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        return result;

    }

    public static String parseDoubleMax8(double number) {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        sDecimalFormat.setDecimalFormatSymbols(symbols);
        sDecimalFormat.applyPattern("#.00000000");
        return BigDecimal.valueOf(parseDouble(sDecimalFormat.format(number))).stripTrailingZeros().toPlainString();
    }

    public static String parseDoubleMax8(String number) {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        sDecimalFormat.setDecimalFormatSymbols(symbols);
        sDecimalFormat.applyPattern("#.00000000");
        return BigDecimal.valueOf(parseDouble(sDecimalFormat.format(parseDouble(number)))).stripTrailingZeros().toPlainString();
    }

    public static String parseDoubleMax3(double number) {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        sDecimalFormat.setDecimalFormatSymbols(symbols);
        sDecimalFormat.applyPattern("#.000");
        return BigDecimal.valueOf(parseDouble(sDecimalFormat.format(number))).stripTrailingZeros().toPlainString();
    }

    public static String parseDoubleMax3(String number) {
//        Log.i("parseDoubleMax3_1",System.currentTimeMillis()+"");
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        sDecimalFormat.setDecimalFormatSymbols(symbols);
        sDecimalFormat.applyPattern("#.000");
        String s = BigDecimal.valueOf(parseDouble(sDecimalFormat.format(parseDouble(number)))).stripTrailingZeros().toPlainString();
//        Log.i("parseDoubleMax3_2",System.currentTimeMillis()+"");
        return s;
    }

    public static String parseDouble2(double num) {
        DecimalFormat decimalFormat = new DecimalFormat("0.00");
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        decimalFormat.setDecimalFormatSymbols(symbols);
        return decimalFormat.format(num);
    }

    public static String parseDouble2(String num) {
        DecimalFormat decimalFormat = new DecimalFormat("0.00");
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        decimalFormat.setDecimalFormatSymbols(symbols);
        return decimalFormat.format(parseDouble(num));
    }

    public static String parseDouble8(String num) {
        DecimalFormat decimalFormat = new DecimalFormat("0.00000000");
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        decimalFormat.setDecimalFormatSymbols(symbols);
        return decimalFormat.format(parseDouble(num));
    }

    public static String parseDouble0(String num) {
        DecimalFormat decimalFormat = new DecimalFormat("#");
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        decimalFormat.setDecimalFormatSymbols(symbols);
        return decimalFormat.format(parseDouble(num));
    }

    public static String parseDoubleMax2(double number) {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        sDecimalFormat.setDecimalFormatSymbols(symbols);
        sDecimalFormat.applyPattern("#.00");
        return BigDecimal.valueOf(parseDouble(sDecimalFormat.format(number))).stripTrailingZeros().toPlainString();
    }

    public static String parseDoubleMax4(double number) {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        sDecimalFormat.setDecimalFormatSymbols(symbols);
        sDecimalFormat.applyPattern("#.0000");
        return BigDecimal.valueOf(parseDouble(sDecimalFormat.format(number))).stripTrailingZeros().toPlainString();
    }

    public static String parseDoubleMax2(String number) {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        sDecimalFormat.setDecimalFormatSymbols(symbols);
        sDecimalFormat.applyPattern("#.00");
        return BigDecimal.valueOf(parseDouble(sDecimalFormat.format(parseDouble(number)))).stripTrailingZeros().toPlainString();
    }

    public static String parseTime(long t) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
        return df.format(new Date(t));
    }

    public static String parseTime2(long t) {
        SimpleDateFormat df = new SimpleDateFormat("MM-dd HH:mm:ss", Locale.getDefault());
        return df.format(new Date(t));
    }

    public static String parseTimeDate(long t) {
        SimpleDateFormat df = new SimpleDateFormat("HH:mm:ss", Locale.getDefault());
        return df.format(new Date(t));
    }
    @SuppressLint("SimpleDateFormat")
    public static String timeFormat_M_D(String dateString) {
        Date date;
        try {
            date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString);
            @SuppressLint("SimpleDateFormat") SimpleDateFormat format = new SimpleDateFormat("MM-dd");
            return format.format(date);

        } catch (ParseException e) {
            e.printStackTrace();

        }
        return dateString;
    }

    @SuppressLint("SimpleDateFormat")
    public static String timeFormat_H_S(String dateString) {
        Date date;
        try {
            date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString);
            @SuppressLint("SimpleDateFormat") SimpleDateFormat format = new SimpleDateFormat("HH:mm");
            return format.format(date);

        } catch (ParseException e) {
            e.printStackTrace();

        }
        return dateString;
    }

    @SuppressLint("SimpleDateFormat")
    public static String timeFormat(String dateString) {
        Date date;
        try {
            date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString);
            @SuppressLint("SimpleDateFormat") SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            return format.format(date);

        } catch (ParseException e) {
            e.printStackTrace();

        }
        return dateString;
    }

    public static String parseBigDecimal(String value) {
        if(value == null){
            value = "0";
        }
        BigDecimal bd = new BigDecimal(value);
        return bd.toPlainString();
    }

    public static BigDecimal bigDecimal(String value) {
        BigDecimal bigDecimal = new BigDecimal(value);
        return bigDecimal;
    }

    public static String parseDoubleMaxFillingZero_X(double number, int x) {
        String type;
        switch (x) {
            case 0:
                type = "0";
                break;
            case 1:
                type = "0.0";
                break;
            case 2:
                type = "0.00";
                break;
            case 3:
                type = "0.000";
                break;
            case 4:
                type = "0.0000";
                break;
            case 5:
                type = "0.00000";
                break;
            case 6:
                type = "0.000000";
                break;
            case 7:
                type = "0.0000000";
                break;
            case 8:
                type = "0.00000000";
                break;
            case 9:
                type = "0.000000000";
                break;
            case 10:
                type = "0.0000000000";
                break;
            case 11:
                type = "0.00000000000";
                break;
            case 12:
                type = "0.000000000000";
                break;
            case 13:
                type = "0.0000000000000";
                break;
            case 14:
                type = "0.00000000000000";
                break;
            case 15:
                type = "0.000000000000000";
                break;
            default:
                type = "0.00000000";
                break;
        }
        DecimalFormat decimalFormat = new DecimalFormat(type);
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        decimalFormat.setDecimalFormatSymbols(symbols);

        return decimalFormat.format(number);
    }

    public static String parseBitmapMaxFillingZero_X(BigDecimal number, int x) {
        String type;
        switch (x) {
            case 0:
                type = "0";
                break;
            case 1:
                type = "0.0";
                break;
            case 2:
                type = "0.00";
                break;
            case 3:
                type = "0.000";
                break;
            case 4:
                type = "0.0000";
                break;
            case 5:
                type = "0.00000";
                break;
            case 6:
                type = "0.000000";
                break;
            case 7:
                type = "0.0000000";
                break;
            case 8:
                type = "0.00000000";
                break;
            case 9:
                type = "0.000000000";
                break;
            case 10:
                type = "0.0000000000";
                break;
            case 11:
                type = "0.00000000000";
                break;
            case 12:
                type = "0.000000000000";
                break;
            case 13:
                type = "0.0000000000000";
                break;
            case 14:
                type = "0.00000000000000";
                break;
            case 15:
                type = "0.000000000000000";
                break;
            default:
                type = "0.00000000";
                break;
        }
        DecimalFormat decimalFormat = new DecimalFormat(type);
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        decimalFormat.setDecimalFormatSymbols(symbols);

//        if(EditTextUtil.isNumeric(decimalFormat.format(number.doubleValue()))){
//            return decimalFormat.format(number);
//        }else{
//            String value = decimalFormat.format(number);
//            if(value.contains(",")){
//                value = value.replace(",",".");
//            }else if(value.contains("，")){
//                value = value.replace(",",".");
//            }else{
//                value = "0";
//            }
//            return value;
//        }
        return decimalFormat.format(number);
    }

    public static String parseDoubleMax_X(String number, int x) {
        DecimalFormat sDecimalFormat = new DecimalFormat();
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        sDecimalFormat.setDecimalFormatSymbols(symbols);
        switch (x) {
            case 0:
                sDecimalFormat.applyPattern("#");
                break;
            case 1:
                sDecimalFormat.applyPattern("#.0");
                break;
            case 2:
                sDecimalFormat.applyPattern("#.00");
                break;
            case 3:
                sDecimalFormat.applyPattern("#.000");
                break;
            case 4:
                sDecimalFormat.applyPattern("#.0000");
                break;
            case 5:
                sDecimalFormat.applyPattern("#.00000");
                break;
            case 6:
                sDecimalFormat.applyPattern("#.000000");
                break;
            case 7:
                sDecimalFormat.applyPattern("#.0000000");
                break;
            case 8:
                sDecimalFormat.applyPattern("#.00000000");
                break;
            case 9:
                sDecimalFormat.applyPattern("#.000000000");
                break;
            case 10:
                sDecimalFormat.applyPattern("#.0000000000");
                break;
            default:
                sDecimalFormat.applyPattern("#.000000");
                break;
        }
        BigDecimal value = BigDecimal.valueOf(parseDouble(sDecimalFormat.format(parseDouble(number))));
        if(value.compareTo(BigDecimal.ZERO) != 0){
            return value.stripTrailingZeros().toPlainString();
        }else{
            value = BigDecimal.ZERO;
            return value.stripTrailingZeros().toPlainString();
        }

    }


    public static String parseDoubleMax_X(double number, int x) {
        DecimalFormat sDecimalFormat = new DecimalFormat();
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        sDecimalFormat.setDecimalFormatSymbols(symbols);
        switch (x) {
            case 0:
                sDecimalFormat.applyPattern("#");
                break;
            case 1:
                sDecimalFormat.applyPattern("#.0");
                break;
            case 2:
                sDecimalFormat.applyPattern("#.00");
                break;
            case 3:
                sDecimalFormat.applyPattern("#.000");
                break;
            case 4:
                sDecimalFormat.applyPattern("#.0000");
                break;
            case 5:
                sDecimalFormat.applyPattern("#.00000");
                break;
            case 6:
                sDecimalFormat.applyPattern("#.000000");
                break;
            case 7:
                sDecimalFormat.applyPattern("#.0000000");
                break;
            case 8:
                sDecimalFormat.applyPattern("#.00000000");
                break;
            case 9:
                sDecimalFormat.applyPattern("#.000000000");
                break;
            case 10:
                sDecimalFormat.applyPattern("#.0000000000");
                break;
            default:
                sDecimalFormat.applyPattern("#.000000");
                break;
        }
        BigDecimal value = BigDecimal.valueOf(parseDouble(sDecimalFormat.format(number)));
        if(value.compareTo(BigDecimal.ZERO) != 0){
            return value.stripTrailingZeros().toPlainString();
        }else{
            value = BigDecimal.ZERO;
            return value.stripTrailingZeros().toPlainString();
        }

    }


    public static String subZeroAndDot(String s){
        if(s.indexOf(".") > 0){
            s = s.replaceAll("0+?$", "");
            s = s.replaceAll("[.]$", "");
        }
        return s;
    }






    public static String parseDoubleMaxFillingZero_X_ConversionPercentage(double number,int digit) {
        String type;
        switch (digit) {
            case 0:
                type = "0";
                break;
            case 1:
                type = "0.0";
                break;
            case 2:
                type = "0.00";
                break;
            case 3:
                type = "0.000";
                break;
            case 4:
                type = "0.0000";
                break;
            case 5:
                type = "0.00000";
                break;
            case 6:
                type = "0.000000";
                break;
            case 7:
                type = "0.0000000";
                break;
            case 8:
                type = "0.00000000";
                break;
            default:
                type = "0.00000000";
                break;
        }
        DecimalFormat sDecimalFormat = new DecimalFormat(type);
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        sDecimalFormat.setDecimalFormatSymbols(symbols);
        return sDecimalFormat.format(number) + "%";
    }


    public static String conversionPercentageFillingZero(double number,int digit) {
        DecimalFormat decimalFormat;
        switch (digit) {
            case 0:
                decimalFormat = new DecimalFormat("0%");
                break;
            case 1:
                decimalFormat = new DecimalFormat("0.0%");
                break;
            case 2:
                decimalFormat = new DecimalFormat("0.00%");
                break;
            case 3:
                decimalFormat = new DecimalFormat("0.000%");
                break;
            case 4:
                decimalFormat = new DecimalFormat("0.0000%");
                break;
            case 5:
                decimalFormat = new DecimalFormat("0.00000%");
                break;
            case 6:
                decimalFormat = new DecimalFormat("0.000000%");
                break;
            case 7:
                decimalFormat = new DecimalFormat("0.0000000%");
                break;
            case 8:
                decimalFormat = new DecimalFormat("0.00000000%");
                break;
            default:
                decimalFormat = new DecimalFormat("0.000%");
                break;
        }
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        decimalFormat.setDecimalFormatSymbols(symbols);
        return decimalFormat.format(number);
    }

    public static String conversionPercentage(double number, int digit) {
        NumberFormat nf = NumberFormat.getPercentInstance();
        nf.setMaximumFractionDigits(digit);

        return nf.format(number);
    }


    private final static char[][] LEADING_DECIMALS = new char[][]{
            "0.".toCharArray(), "0.0".toCharArray(),
            "0.00".toCharArray(), "0.000".toCharArray(), "0.0000".toCharArray(),
            "0.00000".toCharArray(),
            "0.000000".toCharArray(), "0.0000000".toCharArray(), "0.00000000".toCharArray(),
            "0.000000000".toCharArray(), "0.0000000000".toCharArray(), "0.00000000000".toCharArray(),
            "0.000000000000".toCharArray(), "0.0000000000000".toCharArray(),
            "0.00000000000000".toCharArray(),
            "0.000000000000000".toCharArray()
    };


    /**
     * format a double value quickly, will remove the suffix:0
     */
    public static String fastFormat(double d, int precision) {
        int posPrecision = Math.abs(precision);
        double roundUpVal = Math.abs(d) * Math.pow(10d, posPrecision) + 0.5d;
        if (roundUpVal > 999999999999999d || posPrecision > 16) {// double has max 16 precisions
            return bigDecFormat(d, posPrecision);
        }
        long longPart = (long) Math.nextUp(roundUpVal);
        if (longPart < 1) {
            return "0";
        }
        char[] longPartChars = Long.toString(longPart).toCharArray();
        char[] formatChars;
        if (longPartChars.length > posPrecision) {
            int end = longPartChars.length - 1;
            int decIndex = longPartChars.length - posPrecision;
            while (end >= decIndex && longPartChars[end] == '0') {
                end--;
            }
            if (end >= decIndex) {
                formatChars = new char[end + 2];
                System.arraycopy(longPartChars, 0, formatChars, 0, decIndex);
                formatChars[decIndex] = '.';
                System.arraycopy(longPartChars, decIndex, formatChars,
                        decIndex + 1, end - decIndex + 1);
            } else {
                formatChars = new char[decIndex];
                System.arraycopy(longPartChars, 0, formatChars, 0, decIndex);
            }
        } else {
            int end = longPartChars.length - 1;
            while (end >= 0 && longPartChars[end] == '0') {
                end--;
            }
            char[] leadings = LEADING_DECIMALS[posPrecision - longPartChars.length];
            formatChars = Arrays.copyOf(leadings, leadings.length + end + 1);
            System.arraycopy(longPartChars, 0, formatChars, leadings.length, end + 1);
        }
        return Math.signum(d) > 0 ? new String(formatChars) : "-" + new String(formatChars);
    }

    private static String bigDecFormat(double d, int precision) {
        String formatStr = new BigDecimal(Double.toString(d)).setScale(Math.abs(precision), RoundingMode.HALF_UP)
                .toString();
        if (precision == 0) {
            return formatStr;
        }
        int end = formatStr.length() - 1;
        while (end >= 0 && formatStr.charAt(end) == '0') {
            end--;
        }
        formatStr = formatStr.substring(0, end + 1);
        if (formatStr.charAt(formatStr.length() - 1) == '.') {
            formatStr = formatStr.substring(0, formatStr.length() - 1);
        }
        return formatStr;
    }


}
