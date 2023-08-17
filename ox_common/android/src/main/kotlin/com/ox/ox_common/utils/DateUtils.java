package com.ox.ox_common.utils;

import android.util.Log;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/**
 * Date processing utility
 * BASE_DATE_FORMAT     yyyy-MM-dd HH:mm:ss
 * NORMAL_DATE_FORMAT   yyyy-MM-dd
 * SHORT_DATE_FORMAT    yyyyMMdd
 * FULL_DATE_FORMAT     yyyyMMddHHmmss
 */

public class DateUtils extends android.text.format.DateUtils{
    private static final String TAG = "DateUtils";

    /**
     * yyyy-MM-dd HH:mm:ss
     */
    public static SimpleDateFormat BASE_DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());

    /**
     * yyyy-MM-dd HH:mm:ss
     */
    public static SimpleDateFormat ACCURATE_DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.getDefault());


    /**
     * yyyy-MM-dd HH:mm:ss
     */
    public static SimpleDateFormat ENTRUST_DATE_FORMAT = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss", Locale.getDefault());

    /**
     * yyyy-MM-dd
     */
    public static SimpleDateFormat NORMAL_DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
    /**
     * yyyyMMdd
     */
    public static SimpleDateFormat SHORT_DATE_FORMAT = new SimpleDateFormat("yyyyMMdd", Locale.getDefault());
    /**
     * yyyyMMddHHmmss
     */
    public static SimpleDateFormat FULL_DATE_FORMAT = new SimpleDateFormat("yyyyMMddHHmmss", Locale.getDefault());
    /**
     * HH:mm:ss
     */
    public static final String DEFAULT_FORMAT_TIME = "HH:mm:ss";
    public static final String HHmm = "HH:mm";
    public static final String MMdd = "MM-dd";

    public static String getHHmm(Date date){
        return dateSimpleFormat(date, new SimpleDateFormat(HHmm));
    }
public static String getMMdd(Date date){
        return dateSimpleFormat(date, new SimpleDateFormat(MMdd));
    }

    /**
     * Get the date before or after the current time (year, month, day, hour, minute, second)
     *
     * @param date     Current time
     * @param dateType Year(0), Month(1), Day(2), Hour(3), Minute(4), Second(5)
     * @param number   Number of units before or after
     * @return
     */
    public static Date getBeforeOrAfter(Date date, int dateType, int number) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        switch (dateType) {
            case 0:
                calendar.add(Calendar.YEAR, number);
                break;
            case 1:
                calendar.add(Calendar.MONTH, number);
                break;
            case 2:
                calendar.add(Calendar.DAY_OF_YEAR, number);
                break;
            case 3:
                calendar.add(Calendar.HOUR, number);
                break;
            case 4:
                calendar.add(Calendar.MINUTE, number);
                break;
            case 5:
                calendar.add(Calendar.SECOND, number);
                break;
        }
//        String dateStr = SHORT_DATE_FORMAT.format(calendar.getTime());
        return calendar.getTime();
    }

    /**
     * Get the date of one month ago.
     *
     * @param date     Input date
     * @param monthSum Number of months before or after
     * @return
     */
    public static String getMonthBeforeOrAfter(Date date, int monthSum) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.MONTH, monthSum);
        String monthAgo = simpleDateFormat.format(calendar.getTime());
        return monthAgo;
    }

    public static String getMonthBeforeOrAfter(int monthSum) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.MONTH, monthSum);
        String monthAgo = simpleDateFormat.format(calendar.getTime());
        return monthAgo;
    }

    /**
     * Determine if a date is today.
     *
     * @param dateString Date string in the format: yyyy-MM-dd HH:mm:ss
     * @return Returns true if it is the same day, otherwise returns false
     */
    public static boolean isToday(String dateString) {
        try {
            Date date = BASE_DATE_FORMAT.parse(dateString);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            Calendar calendar1 = Calendar.getInstance();
            return (calendar.get(Calendar.YEAR) == calendar1.get(Calendar.YEAR))
                    && (calendar.get(Calendar.DAY_OF_YEAR) == calendar1.get(Calendar.DAY_OF_YEAR));
        } catch (ParseException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean isToday(long timeInMills) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(timeInMills);
        Calendar calendar1 = Calendar.getInstance();
        return (calendar.get(Calendar.YEAR) == calendar1.get(Calendar.YEAR))
                && (calendar.get(Calendar.DAY_OF_YEAR) == calendar1.get(Calendar.DAY_OF_YEAR));
    }

    /**
     * Determine if a date is before the current time.
     *
     * @param dateString Date string in the format: yyyy-MM-dd HH:mm:ss
     * @return Returns true if the date is before the current time, otherwise returns false
     */
    public static boolean isBeforeNow(String dateString) {
        try {
            Date date = BASE_DATE_FORMAT.parse(dateString);
            return System.currentTimeMillis() > date.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Determine if a date is after the current time.
     *
     * @param dateString Date string in the format: yyyy-MM-dd HH:mm:ss
     * @return Returns true if the date is after the current time, otherwise returns false
     */
    public static boolean isAfterNow(String dateString) {
        try {
            Date date = BASE_DATE_FORMAT.parse(dateString);
            return System.currentTimeMillis() < date.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static String getDateString(long timestamp) {
        return BASE_DATE_FORMAT.format(new Date(timestamp));
    }


    public static String getEntrustDateString(long timestamp) {
        return ENTRUST_DATE_FORMAT.format(new Date(timestamp));
    }
    public static String getNormalDateString(long timestamp) {
        return NORMAL_DATE_FORMAT.format(new Date(timestamp));
    }

    public static String getShortDateString(long timestamp) {
        return SHORT_DATE_FORMAT.format(new Date(timestamp));
    }

    public static String getFullDateString(long timestamp) {
        return FULL_DATE_FORMAT.format(new Date(timestamp));
    }

    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * Method to calculate time duration.
     *
     * @param beginDayStr Start time
     * @param endDayStr   End time
     * @return The calculated duration
     */
    public static long subDay(String beginDayStr, String endDayStr) {
        Date beginDate = null;
        Date endDate = null;

        long day = 0;
        try {
            beginDate = sdf.parse(beginDayStr);
            endDate = sdf.parse(endDayStr);

            day = (endDate.getTime() - beginDate.getTime()) / (24 * 60 * 60 * 1000);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        if (day == 0) {
            day = 1;
        }

        return day;
    }

    public static String getTodayStr() {
        SimpleDateFormat format4 = new SimpleDateFormat("yyyyMMddhhmmss");

        Calendar c = Calendar.getInstance();
        Date today = c.getTime();
        String todayStr = format4.format(today);
        return todayStr;
    }

    public static String getToday(SimpleDateFormat format) {

        Calendar c = Calendar.getInstance();
        Date today = c.getTime();
        String todayStr = format.format(today);
        return todayStr;
    }

    public static String getToday(String pattern) {
        SimpleDateFormat format = new SimpleDateFormat(pattern);

        Calendar c = Calendar.getInstance();
        Date today = c.getTime();
        String todayStr = format.format(today);
        return todayStr;
    }

    public static String getTodayDate() {
        SimpleDateFormat format4 = new SimpleDateFormat("yyyyMMdd");

        Calendar c = Calendar.getInstance();
        Date today = c.getTime();
        String todayStr = format4.format(today);
        return todayStr;
    }

    public static String getTodayF() {
        SimpleDateFormat format4 = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

        Calendar c = Calendar.getInstance();
        Date today = c.getTime();
        String todayStr = format4.format(today);
        return todayStr;
    }

    public static Map<String, String> getDatetimes() {
        SimpleDateFormat f_yyyy = new SimpleDateFormat("yyyy");
        SimpleDateFormat f_MM = new SimpleDateFormat("MM");
        SimpleDateFormat f_dd = new SimpleDateFormat("dd");
        SimpleDateFormat f_HH = new SimpleDateFormat("HH");
        SimpleDateFormat f_mm = new SimpleDateFormat("mm");
        SimpleDateFormat f_ss = new SimpleDateFormat("ss");
        Calendar c = Calendar.getInstance();
        Date today = c.getTime();
        String d_yyyy = f_yyyy.format(today);
        String d_MM = f_MM.format(today);
        String d_dd = f_dd.format(today);
        String t_HH = f_HH.format(today);
        String t_mm = f_mm.format(today);
        String t_ss = f_ss.format(today);
        Map<String, String> datetimes = new HashMap<String, String>();
        datetimes.put("yyyy", d_yyyy);
        datetimes.put("MM", d_MM);
        datetimes.put("dd", d_dd);
        datetimes.put("HH", t_HH);
        datetimes.put("mm", t_mm);
        datetimes.put("ss", t_ss);

        return datetimes;
    }

    public static Map<String, String> getDateMapByStringValue(String strData) {
        SimpleDateFormat f_yyyy = new SimpleDateFormat("yyyy");
        SimpleDateFormat f_MM = new SimpleDateFormat("MM");
        SimpleDateFormat f_dd = new SimpleDateFormat("dd");
        SimpleDateFormat f_HH = new SimpleDateFormat("HH");
        SimpleDateFormat f_mm = new SimpleDateFormat("mm");
        SimpleDateFormat f_ss = new SimpleDateFormat("ss");


        Date today = strToDate(strData);
        String d_yyyy = f_yyyy.format(today);
        String d_MM = f_MM.format(today);
        String d_dd = f_dd.format(today);
        String t_HH = f_HH.format(today);
        String t_mm = f_mm.format(today);
        String t_ss = f_ss.format(today);
        Map<String, String> datetimes = new HashMap<String, String>();
        datetimes.put("yyyy", d_yyyy);
        datetimes.put("MM", d_MM);
        datetimes.put("dd", d_dd);
        datetimes.put("HH", t_HH);
        datetimes.put("mm", t_mm);
        datetimes.put("ss", t_ss);

        return datetimes;
    }

    public static String getCurrentTime() {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm");
        return dateFormat.format(calendar.getTime());
    }

    public static Date strToDate(String str) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;
        try {
            date = format.parse(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return date;
    }

    public static Date strToDateAll(String str) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = null;
        try {
            date = format.parse(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return date;
    }

    public static Date strToDate(String str, SimpleDateFormat format) {
//        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;
        try {
            date = format.parse(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return date;
    }

    public static String str2Format(String str, SimpleDateFormat format) {
//        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;
        try {
            date = format.parse(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return format.format(date);
    }

    public static String getDay(Date date, int iDaydiff) {
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(date);
        calendar.add(Calendar.DATE, iDaydiff);
        date = calendar.getTime();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        return formatter.format(date);
    }


    public static Date getToday() {
        Calendar c = Calendar.getInstance();
        Date today = c.getTime();
        return today;
    }


    public static Date getDate(int year, int month, int day) {
        Calendar mCalendar = Calendar.getInstance();
        mCalendar.set(year, month - 1, day);
        return mCalendar.getTime();
    }

    public static long getIntervalDays(String strat, String end) {
        try {
            return (BASE_DATE_FORMAT.parse(end).getTime() - BASE_DATE_FORMAT.parse(strat).getTime()) / (3600 * 24 * 1000);
        } catch (ParseException e) {
            e.printStackTrace();
            return 999;
        }
    }

    public static String getIntervalMillSecond(String start, String end) {
        try {
            return String.valueOf((BASE_DATE_FORMAT.parse(end).getTime() - BASE_DATE_FORMAT.parse(start).getTime()));
        } catch (Exception e) {
            e.printStackTrace();
            return "999";
        }
    }

    public static String getIntervalMill(String start, String end) {
        if(start == null || end == null){
            return "1";
        }
        try {
            return String.valueOf((ACCURATE_DATE_FORMAT.parse(end).getTime() - ACCURATE_DATE_FORMAT.parse(start).getTime()));
        } catch (Exception e) {
            Log.e(TAG, "getIntervalMill-e:" + e.getMessage());
            e.printStackTrace();
            return "9999";
        }
    }

    public static String getCurrentTimeAccurate() {
        try {
            Date currentTime = new Date(System.currentTimeMillis());
            SimpleDateFormat formatter = ACCURATE_DATE_FORMAT;
            return formatter.format(currentTime);
        } catch (Exception e) {
            Log.e(TAG, "getCurrentTimeAccurate-e:" + e.getMessage());
            return null;
        }
    }

    public static int getCurrentYear() {
        Calendar mCalendar = Calendar.getInstance();
        return mCalendar.get(Calendar.YEAR);
    }

    public static int getCurrentMonth() {
        Calendar mCalendar = Calendar.getInstance();
        return mCalendar.get(Calendar.MONTH) + 1;
    }

    public static int getDayOfMonth() {
        Calendar mCalendar = Calendar.getInstance();
        return mCalendar.get(Calendar.DAY_OF_MONTH);
    }

    public static String getYesterday() {
        Calendar mCalendar = Calendar.getInstance();
        mCalendar.add(Calendar.DATE, -1);
        return getDateFormat(mCalendar.getTime());
    }

    public static String getBeforeYesterday() {
        Calendar mCalendar = Calendar.getInstance();
        mCalendar.add(Calendar.DATE, -2);
        return getDateFormat(mCalendar.getTime());
    }

    public static String getOtherDay(int diff) {
        Calendar mCalendar = Calendar.getInstance();
        mCalendar.add(Calendar.DATE, diff);
        return getDateFormat(mCalendar.getTime());
    }

    public static Date getOtherFormat(int diff) {
        Calendar mCalendar = Calendar.getInstance();
        mCalendar.add(Calendar.DATE, diff);
        return mCalendar.getTime();
    }

    public static String getOtherHour(int diff) {
        Calendar mCalendar = Calendar.getInstance();
        mCalendar.add(Calendar.HOUR_OF_DAY, diff);
        return dateSimpleFormat(mCalendar.getTime(), BASE_DATE_FORMAT);
    }

    public static String getCalcDateFormat(String sDate, int amount) {
        Date date = getCalcDate(getDateByDateFormat(sDate), amount);
        return getDateFormat(date);
    }

    public static Date getDateByDateFormat(String strDate) {
        return getDateByFormat(strDate, NORMAL_DATE_FORMAT);
    }

    public static Date getDateByFormat(String strDate, SimpleDateFormat format) {
        return getDateByFormat(strDate, format);
    }

    public static Date getCalcDate(Date date, int amount) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.DATE, amount);
        return cal.getTime();
    }


    public static Date getCalcTime(Date date, int hOffset, int mOffset, int sOffset) {
        Calendar cal = Calendar.getInstance();
        if (date != null)
            cal.setTime(date);
        cal.add(Calendar.HOUR_OF_DAY, hOffset);
        cal.add(Calendar.MINUTE, mOffset);
        cal.add(Calendar.SECOND, sOffset);
        return cal.getTime();
    }


    public static Date getDate(int year, int month, int date, int hourOfDay,
                               int minute, int second) {
        Calendar cal = Calendar.getInstance();
        cal.set(year, month, date, hourOfDay, minute, second);
        return cal.getTime();
    }


    public static int[] getYearMonthAndDayFrom(String sDate) {
        return getYearMonthAndDayFromDate(getDateByDateFormat(sDate));
    }


    public static int[] getYearMonthAndDayFromDate(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        int[] arr = new int[3];
        arr[0] = calendar.get(Calendar.YEAR);
        arr[1] = calendar.get(Calendar.MONTH);
        arr[2] = calendar.get(Calendar.DAY_OF_MONTH);
        return arr;
    }


    public static String getDateFormat(int year, int month, int day) {
        return getDateFormat(getDate(year, month, day));
    }


    public static String getDateFormat(Date date) {
        return dateSimpleFormat(date, NORMAL_DATE_FORMAT);
    }


    public static String dateSimpleFormat(Date date, SimpleDateFormat format) {
        if (format == null)
            format = BASE_DATE_FORMAT;
        return (date == null ? "" : format.format(date));
    }

    public static int dateFormat(String date) {
        if (date == null && ("".equals(date) || "null".equals(date)))
            return 0;
        return Integer.valueOf(date.replace(":", ""));
    }

}
