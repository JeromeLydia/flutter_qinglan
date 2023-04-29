import 'package:get/get.dart';
import 'package:intl/intl.dart';

///关于时间工具
class DateUtil {
  static const String PARAM_FORMAT = "yyyy/MM/dd";
  static const String PARAM_TIME_FORMAT = 'yyyy/MM/dd';
  static const String PARAM_TIME_FORMAT_H = 'yyyy/MM/dd HH';
  static const String PARAM_TIME_FORMAT_H_M_S = 'yyyy/MM/dd HH:mm:ss';
  static const String FORMAT_D_M_H_M_S = 'dd-MM HH:mm:ss';
  static const String FORMAT_H_M_S = 'HH:mm:ss';

  ///将时间日期格式转化为时间戳
  ///2018年12月11日
  ///2019-12-11
  ///2018年11月15 11:14分89
  ///结果是毫秒
  static int getTimeStap({formatData: String}) {
    var result = formatData.substring(0, 4) +
        "-" +
        formatData.substring(5, 7) +
        "-" +
        formatData.substring(8, 10);
    if (formatData.toString().length >= 13 &&
        formatData.substring(10, 13) != null) {
      result += "" + formatData.substring(10, 13);
    }
    if (formatData.toString().length >= 17 &&
        formatData.toString().substring(14, 16) != null) {
      result += ":" + formatData.substring(14, 16);
    }
    if (formatData.toString().length >= 19 &&
        formatData.substring(17, 19) != null) {
      result += ":" + formatData.substring(17, 19);
    }
    var dataTime = DateTime.parse(result);
    print(dataTime.millisecondsSinceEpoch);
    return dataTime.millisecondsSinceEpoch;
  }

  ///获取当前日期返回DateTime
  static DateTime getNowDateTime() {
    return DateTime.now();
  }

  ///获取昨天日期返回DateTime
  static DateTime getYesterday() {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch - 24 * 60 * 60 * 1000);
    return dateTime;
  }

  ///获取当前日期返回DateTime
  static DateTime getNowUtcDateTime() {
    return DateTime.now().toUtc();
  }

  ///获取当前日期，返回指定格式
  static String getNowDateTimeFormat(String outFormat) {
    var format = DateFormat(outFormat);
    DateTime date = DateTime.now();
    format.format(date);
    String formatResult = format.format(date);
    return formatResult;
  }

  ///获取当前日期，返回指定格式
  static String getUtcDateTimeFormat(String outFormat) {
    var format = DateFormat(outFormat);
    DateTime date = DateTime.now().toUtc();
    format.format(date);
    String formatResult = format.format(date);
    return formatResult;
  }

  ///格式化时间戳
  ///timeSamp:毫秒值
  ///format:"yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"......
  ///结果： 2019?08?04  02?08?02
  static getFormatData({timeSamp: int, format: String}) {
    var dataFormat = DateFormat(format);
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timeSamp);
    String formatResult = dataFormat.format(dateTime);
    return formatResult;
  }

  ///格式化
  ///timeSamp:毫秒值
  ///format:"yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"......
  ///结果： 2019?08?04  02?08?02
  static getFormatStrToStr(String date, String intFormat, String outFormat) {
    var formatInt = DateFormat(intFormat);
    var formatOut = DateFormat(outFormat);
    DateTime dateTime = formatInt.parse(date);
    String formatResult = formatOut.format(dateTime);
    return formatResult;
  }

  ///格式化 国际时区转为本地
  ///timeSamp:毫秒值
  ///format:"yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"......
  ///结果： 2019?08?04  02?08?02
  static getFormatUtcToLocal(String date, String intFormat, String outFormat) {
    var formatInt = DateFormat(intFormat);
    var formatOut = DateFormat(outFormat);
    DateTime dateTime = formatInt.parse(date);
    var timezoneOffset = dateTime.timeZoneOffset.inHours;
    String formatResult =
        formatOut.format(dateTime.add(Duration(hours: timezoneOffset)));
    return formatResult;
  }

  ///格式化时间戳
  ///timeSamp:毫秒值
  ///format:"yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"......
  ///结果： 2019?08?04  02?08?02
  static getFormatDataString(DateTime date, String outFormat) {
    var format = DateFormat(outFormat);
    String formatResult = format.format(date);
    return formatResult;
  }

  ///格式化时间戳
  ///timeSamp:毫秒值
  ///format:"yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"......
  ///结果： 2019?08?04  02?08?02
  static getFormatUtcToLocalStr(DateTime date, String outFormat) {
    var format = DateFormat(outFormat);
    var timezoneOffset = date.timeZoneOffset.inHours;
    String formatResult =
        format.format(date.add(Duration(hours: timezoneOffset)));
    return formatResult;
  }

  ///1.获取从某一天开始到某一天结束的所有的中间日期，例如输入 startTime:2019:07:31  endTime:2019:08:31  就会返回所有的中间天数。
  ///startTime和endTime格式如下都可以
  ///使用:    List<String> mdata=DateUtils.instance.getTimeBettwenStartTimeAndEnd(startTime:"2019-07-11",endTime:"2019-08-29",format:"yyyy年MM月dd");
  ///结果:[2019年07月11, 2019年07月12, 2019年07月13, 2019年07月14, 2019年07月15, 2019年07月16, 2019年07月17, 2019年07月18, 2019年07月19, 2019年07月20, 2019年07月21, 2019年07月22, 2019年07月23, 2019年07月24, 2019年07月25, 2019年07月26, 2019年07月27, 2019年07月28, 2019年07月29, 2019年07月30, 2019年07月31, 2019年08月01, 2019年08月02, 2019年08月03, 2019年08月04, 2019年08月05, 2019年08月06, 2019年08月07, 2019年08月08, 2019年08月09, 2019年08月10, 2019年08月11, 2019年08月12, 2019年08月13, 2019年08月14, 2019年08月15, 2019年08月16, 2019年08月17, 2019年08月18, 2019年08月19, 2019年08月20, 2019年08月21, 2019年08月22, 2019年08月23, 2019年08月24, 2019年08月25, 2019年08月26, 2019年08月27, 2019年08月28, 2019年08月29]
  static List<String> getTimeBetweenStartTimeAndEnd(
      String startTime, String endTime, String format) {
    var mDataList = <String>[];
    //记录往后每一天的时间搓，用来和最后一天到做对比。这样就能知道什么时候停止了。
    int allTimeEnd = 0;
    //记录当前到个数(相当于天数)
    int currentFlag = 0;
    DateTime startData = DateTime.parse(startTime);
    DateTime endData = DateTime.parse(endTime);
    var mothFormatFlag = DateFormat(format);
    while (endData.millisecondsSinceEpoch > allTimeEnd) {
      allTimeEnd =
          startData.millisecondsSinceEpoch + currentFlag * 24 * 60 * 60 * 1000;
      var dateTime = DateTime.fromMillisecondsSinceEpoch(
          startData.millisecondsSinceEpoch + currentFlag * 24 * 60 * 60 * 1000);
      String nowMoth = mothFormatFlag.format(dateTime);
      mDataList.add("'$nowMoth'");
      currentFlag++;
    }
    return mDataList;
  }

  ///1.获取从某一天开始到某一天结束的所有的中间日期，例如输入 startTime:2019:07:31  endTime:2019:08:31  就会返回所有的中间天数。
  ///startTime和endTime格式如下都可以
  ///使用:    List<String> mdata=DateUtils.instance.getTimeBettwenStartTimeAndEnd(startTime:"2019-07-11",endTime:"2019-08-29",format:"yyyy年MM月dd");
  ///结果:[2019年07月11, 2019年07月12, 2019年07月13, 2019年07月14, 2019年07月15, 2019年07月16, 2019年07月17, 2019年07月18, 2019年07月19, 2019年07月20, 2019年07月21, 2019年07月22, 2019年07月23, 2019年07月24, 2019年07月25, 2019年07月26, 2019年07月27, 2019年07月28, 2019年07月29, 2019年07月30, 2019年07月31, 2019年08月01, 2019年08月02, 2019年08月03, 2019年08月04, 2019年08月05, 2019年08月06, 2019年08月07, 2019年08月08, 2019年08月09, 2019年08月10, 2019年08月11, 2019年08月12, 2019年08月13, 2019年08月14, 2019年08月15, 2019年08月16, 2019年08月17, 2019年08月18, 2019年08月19, 2019年08月20, 2019年08月21, 2019年08月22, 2019年08月23, 2019年08月24, 2019年08月25, 2019年08月26, 2019年08月27, 2019年08月28, 2019年08月29]
  static List<String> getRangeTime(
      DateTime startData, DateTime endData, String format) {
    var mDataList = <String>[];
    //记录往后每一天的时间搓，用来和最后一天到做对比。这样就能知道什么时候停止了。
    int allTimeEnd = 0;
    //记录当前到个数(相当于天数)
    int currentFlag = 0;
    var mothFormatFlag = DateFormat(format);
    while (endData.millisecondsSinceEpoch > allTimeEnd) {
      allTimeEnd =
          startData.millisecondsSinceEpoch + currentFlag * 24 * 60 * 60 * 1000;
      var dateTime = DateTime.fromMillisecondsSinceEpoch(
          startData.millisecondsSinceEpoch + currentFlag * 24 * 60 * 60 * 1000);
      String nowMoth = mothFormatFlag.format(dateTime);
      mDataList.add("'$nowMoth'");
      currentFlag++;
    }
    return mDataList;
  }

  ///获取两个日期之间间隔天数
  static int getRangeDayNumber(DateTime startData, DateTime endData) {
    return startData.difference(endData).inDays;
  }

  ///传入starTime格式 2012-02-27 13:27:00 或者 "2012-02-27等....
  ///dayNumber：从startTime往后面多少天你需要输出
  ///format:获取到的日期格式。"yyyy年MM月dd" "yyyy-MM-dd" "yyyy年" "yyyy年MM月" "yyyy年\nMM月dd"  等等
  ///使用：DateUtils.instance.getTimeStartTimeAndEnd(startTime:"2019-07-11",dayNumber:10,format:"yyyy年MM月dd");
  ///结果:[2019年07月11, 2019年07月12, 2019年07月13, 2019年07月14, 2019年07月15, 2019年07月16, 2019年07月17, 2019年07月18, 2019年07月19, 2019年07月20, 2019年07月21]
  static List<String> getTimeStartTimeAndEnd(
      {startTime: String, dayNumber: int, format: String}) {
    var mDataList = <String>[];
    //记录往后每一天的时间搓，用来和最后一天到做对比。这样就能知道什么时候停止了。
    int allTimeEnd = 0;
    //记录当前到个数(相当于天数)
    int currentFlag = 0;
    DateTime startData = DateTime.parse(startTime);
    var mothFormatFlag = DateFormat(format);
    while (dayNumber >= currentFlag) {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(
          startData.millisecondsSinceEpoch + currentFlag * 24 * 60 * 60 * 1000);
      String nowMoth = mothFormatFlag.format(dateTime);
      mDataList.add(nowMoth);
      currentFlag++;
    }
    return mDataList;
  }

  ///获取前n天日期、后n天日期
  ///传入starTime格式 2012-02-27 13:27:00 或者 "2012-02-27等....
  ///dayNumber：从startTime往后面多少天你需要输出
  ///format:获取到的日期格式。"yyyy年MM月dd" "yyyy-MM-dd" "yyyy年" "yyyy年MM月" "yyyy年\nMM月dd"  等等
  ///使用：DateUtils.instance.getOldDate(startTime:"2019-07-11",dayNumber:10,format:"yyyy年MM月dd");
  ///结果:2019年07月21
  static String getOldDateToStr(
      DateTime startData, int dayNumber, String format) {
    //记录往后每一天的时间搓，用来和最后一天到做对比。这样就能知道什么时候停止了。
    var mothFormatFlag = DateFormat(format);
    var dateTime = DateTime.fromMillisecondsSinceEpoch(
        startData.millisecondsSinceEpoch + dayNumber * 24 * 60 * 60 * 1000);
    String nowMoth = mothFormatFlag.format(dateTime);
    return nowMoth;
  }

  ///获取前n天日期、后n天日期
  ///传入starTime格式 2012-02-27 13:27:00 或者 "2012-02-27等....
  ///dayNumber：从startTime往后面多少天你需要输出
  ///format:获取到的日期格式。"yyyy年MM月dd" "yyyy-MM-dd" "yyyy年" "yyyy年MM月" "yyyy年\nMM月dd"  等等
  ///使用：DateUtils.instance.getOldDate(startTime:"2019-07-11",dayNumber:10,format:"yyyy年MM月dd");
  ///结果:2019年07月21
  static DateTime getOldDate(DateTime startTime, int dayNumber) {
    //记录往后每一天的时间搓，用来和最后一天到做对比。这样就能知道什么时候停止了。
    var dateTime = DateTime.fromMillisecondsSinceEpoch(
        startTime.millisecondsSinceEpoch + dayNumber * 24 * 60 * 60 * 1000);
    return dateTime;
  }

  ///startTime:输入其实时间的时间戳也可以。
  ///dayNumber:时间段
  ///输入时间格式
  static List<TimeData> getTimeStartTimeAndEndTime(
      {startTime = int, dayNumber: int, format: String}) {
    var mDataList = <TimeData>[];
    //记录往后每一天的时间搓，用来和最后一天到做对比。这样就能知道什么时候停止了。
    //记录当前到个数(相当于天数)
    int currentFlag = 0;
    var mothFormatFlag = DateFormat(format);
    while (dayNumber >= currentFlag) {
      TimeData timeData = TimeData();
      var dateTime = DateTime.fromMillisecondsSinceEpoch(
          startTime + currentFlag * 24 * 60 * 60 * 1000);
      String nowMoth = mothFormatFlag.format(dateTime);
      timeData.dataTime = nowMoth;
      timeData.week = dateTime.weekday;
      mDataList.add(timeData);
      currentFlag++;
    }
    return mDataList;
  }

  ///获取当前月的最后一天。
  ///我们能提供和知道的条件有:(当天的时间,)
  ///timeSamp:时间戳 单位（毫秒）
  ///format:想要的格式  "yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"
  static getEndNowMoth({format = String}) {
    var dataFormat = DateFormat(format);
    var dateTime = DateTime.now();
    var dataNextMonthData = DateTime(dateTime.year, dateTime.month + 1, 1);
    int nextTimeSamp =
        dataNextMonthData.millisecondsSinceEpoch - 24 * 60 * 60 * 1000;
    //取得了下一个月1号码时间戳
    var dateTimeeee = DateTime.fromMillisecondsSinceEpoch(nextTimeSamp);
    String formatResult = dataFormat.format(dateTimeeee);
    return formatResult;
  }

  ///获取当前月的第一天。
  ///我们能提供和知道的条件有:(当天的时间,)
  ///timeSamp:时间戳 单位（毫秒）
  ///format:想要的格式  "yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"
  static getStartNowMoth({format = String}) {
    var dataFormat = DateFormat(format);
    var dateTime = DateTime.now();
    var dataNextMonthData = DateTime(dateTime.year, dateTime.month, 1);
    String formatResult = dataFormat.format(dataNextMonthData);
    return formatResult;
  }

  ///获取下个月的第一天。
  ///format:想要的格式  "yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"
  static getStartNextMoth({format = String}) {
    var dataFormat = DateFormat(format);
    var dateTime = DateTime.now();
    var dataNextMonthData = DateTime(dateTime.year, dateTime.month + 1, 1);
    String formatResult = dataFormat.format(dataNextMonthData);
    return formatResult;
  }

  ///获取某一个月的最后一天。
  ///我们能提供和知道的条件有:(当天的时间,)
  ///timeSamp:时间戳 单位（毫秒）
  ///format:想要的格式  "yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"
  static getEndMoth({timeSamp = int, format = String}) {
    var dataFormat = DateFormat(format);
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timeSamp);
    var dataNextMonthData = DateTime(dateTime.year, dateTime.month + 1, 1);
    int nextTimeSamp =
        dataNextMonthData.millisecondsSinceEpoch - 24 * 60 * 60 * 1000;
    //取得了下一个月1号码时间戳
    var dateTimeeee = DateTime.fromMillisecondsSinceEpoch(nextTimeSamp);
    String formatResult = dataFormat.format(dateTimeeee);
    return formatResult;
  }

  ///获取某一个月的最后一天。
  ///我们能提供和知道的条件有:(当天的时间,)
  ///timeSamp:时间戳 单位（毫秒）
  ///format:想要的格式  "yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"
  static DateTime getEndMonthDate(int year, int month) {
    var dataFormat = DateFormat();
    var dateTime = DateTime.fromMillisecondsSinceEpoch(month);
    var dataNextMonthData = DateTime(year, month + 1, 1);
    int nextTimeSamp =
        dataNextMonthData.millisecondsSinceEpoch - 24 * 60 * 60 * 1000;
    //取得了下一个月1号码时间戳
    var dateTimeeee = DateTime.fromMillisecondsSinceEpoch(nextTimeSamp);
    String formatResult = dataFormat.format(dateTimeeee);
    return dateTimeeee;
  }

  ///获取某一个月的最后一天。
  ///我们能提供和知道的条件有:(当天的时间,)
  ///timeSamp:传入的是时间格式
  ///format:想要的格式  "yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"
  static getEndMothFor({mothFormat = String, format = String}) {
    DateTime startData = DateTime.parse(mothFormat);
    var dataFormat = DateFormat(format);
    var dateTime =
        DateTime.fromMillisecondsSinceEpoch(startData.millisecondsSinceEpoch);
    var dataNextMonthData = DateTime(dateTime.year, dateTime.month + 1, 1);
    int nextTimeSamp =
        dataNextMonthData.millisecondsSinceEpoch - 24 * 60 * 60 * 1000;
    //取得了下一个月1号码时间戳
    var dateTimeeee = DateTime.fromMillisecondsSinceEpoch(nextTimeSamp);
    String formatResult = dataFormat.format(dateTimeeee);
    return formatResult;
  }

  // 获取星期
  static String getWeek(DateTime date) {
    var week = date.weekday;
    String w = '';
    switch (week.toString()) {
      case '1':
        w = '一';
        break;
      case '2':
        w = '二';
        break;
      case '3':
        w = '三';
        break;
      case '4':
        w = '四';
        break;
      case '5':
        w = '五';
        break;
      case '6':
        w = '六';
        break;
      case '7':
        w = '日';
        break;
    }
    return '周$w';
  }

  ///获取本期起始和终止日期，上期起始和终止日期
  ///返回时间由上期开始时间到本期结束时间，正序排列
  ///传入lastDay Date:2021-02-20,period:7
  ///返回[''2021/02/07 00:00:00',2021/02/13 23:59:59','2021/02/14 00:00:00','2021/02/20 23:59:59]
  ///选择上期开始时间	[param1]
  ///选择上期结束时间	[param2]
  ///选择本期开始时间[param3]
  ///选择本期结束时间[param4]
  static List<String> getParamStartAndEndData(
      DateTime lastLocalDay, int period) {
    DateTime lastDay = lastLocalDay;
    List<String> dataList = [];

    ///选择上期开始时间
    String priorStartTime =
        "${getOldDateToStr(lastDay, -period * 2 + 1, PARAM_FORMAT)} 00:00:00";
    dataList.add(priorStartTime);

    ///上期结束时间
    String priorEndTime =
        "${getOldDateToStr(lastDay, -period, PARAM_FORMAT)} 23:59:59";
    // String _firstNowStr = getOldDateToStr(lastDay, -period, PARAM_FORMAT);
    dataList.add(priorEndTime);

    ///本期开始日期
    String _currentStartTime =
        "${getOldDateToStr(lastDay, -period + 1, PARAM_FORMAT)} 00:00:00";
    dataList.add(_currentStartTime);

    ///本期结束时间
    // String _currentEndTime = getOldDateToStr(lastDay, -1, PARAM_FORMAT);
    String currentEndTime =
        "${DateFormat(PARAM_FORMAT).format(lastDay)} 23:59:59";
    dataList.add(currentEndTime);
    return dataList;
  }

  /// 返回当前时间的前一小时和前一天
  static List<String> getBeforeDayAndBeforeHour() {
    List<String> time = [];

    DateTime now = DateTime.now();

    /// 更改当前时间的时间格式
    time.add(DateUtil.getFormatDataString(now, 'yyyy-MM-dd'));

    /// 当前时间的前一天
    String theDayBefore = DateUtil.getFormatDataString(
        now.add(const Duration(days: -1)), 'yyyy-MM-dd');
    time.add(theDayBefore);

    /// 当前时间的前一小时
    String theHourBefore =
        DateUtil.getFormatDataString(now.add(const Duration(hours: -1)), 'HH');
    time.add(theHourBefore);

    /// 当前时间的小时
    String _hour = DateUtil.getFormatDataString(now, "HH");
    time.add(_hour);

    return time;
  }

  static String getCustomTimeZone() {
    int hour = DateTime.now().timeZoneOffset.inHours;
    if (hour.abs() < 10) {
      if (hour < 0) {
        return "-0${hour.abs()}:00";
      } else {
        return "+0$hour:00";
      }
    } else {
      if (hour < 0) {
        return "$hour:00";
      } else {
        return "+$hour:00";
      }
    }
  }
}

class TimeData {
  late String dataTime;
  late int week;
}
