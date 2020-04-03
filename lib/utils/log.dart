

class LogUtil {

  //是否处于生产环境
  static bool inProduct = const bool.fromEnvironment("dart.vm.product");

  ///通用打印
  static void verbose(dynamic message){
    if (!inProduct){
      print("verbose:$message");
    }
  }

  ///info打印
  static void info(dynamic message){
    if (!inProduct){
      print("info:$message");
    }
  }

  ///debug打印
  static void debug(dynamic message){
    if (!inProduct){
      print("debug:$message");
    }
  }

  ///warn打印
  static void warn(dynamic message){
    if (!inProduct){
      print("warn:$message");
    }
  }

  ///error打印
  static void error(dynamic message){
    if (!inProduct){
      print("error:$message");
    }
  }

}