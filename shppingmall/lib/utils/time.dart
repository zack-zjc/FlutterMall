

///时间相关的处理方法
class TimeUtil {

  ///转化时间年-月-日
  static String formatYearMonthDay(int time){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
    String month = date.month >= 10 ? date.month.toString() : "0${date.month}";
    String day = date.day >= 10 ? date.day.toString() : "0${date.day}";
    return "${date.year}-$month-$day";
  }

  ///获取时间的星期数
  static String getTimeWeekDay(int time){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
    switch (date.weekday) {
      case 2:
        return '星期二';
      case 3:
        return '星期三';
      case 4:
        return '星期四';
      case 5:
        return '星期五';
      case 6:
        return '星期六';
      case 7:
        return '星期日';
      default:
        return '星期一';
    }
  }

  ///参数时间是否超过当前时间
  static bool isTimeOverNow(int time){
    var now = DateTime.now();
    var input = DateTime.fromMillisecondsSinceEpoch(time);
    var diff = input.difference(now);
    return diff.inMilliseconds > 0;
  }

  ///获取当天0点 时间
  static int getTodayTime(){
    int timeOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    int millSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int days = millSeconds ~/ (60*60*24);
    int zeroTime = days * 60*60*24 * 1000 - timeOffset;
    return zeroTime;
  }



}