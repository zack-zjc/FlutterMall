import 'package:path/path.dart';
import 'package:shppingmall/model/database_bean.dart';
import 'package:shppingmall/utils/log.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseUtil {
  /// 插入数据
  static Future<int> insertItem<T extends DatabaseBean>(Database database, List<T> t) async {
    if (null == database || !database.isOpen) return 0;
    if (t == null || t.isEmpty) return 0;
    var batch = DatabaseUnion.commonDatabase.batch();
    t.forEach((element) {
      // 插入操作
      batch.insert(
        element.getTableName(),
        element.convertToDatabaseJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    batch.commit(noResult: true);
    return t.length;
  }

  /// 插入数据
  static Future<int> insertCommonDatabaseItem(List<DatabaseBean> t) async {
    if (null == DatabaseUnion.commonDatabase || !DatabaseUnion.commonDatabase.isOpen) return 0;
    if (t == null || t.isEmpty) return 0;
    LogUtil.debug("开始插入数据：${t[0].getTableName()}");
    var batch = DatabaseUnion.commonDatabase.batch();
    t.forEach((element) {
      // 插入操作
      batch.insert(
        element.getTableName(),
        element.convertToDatabaseJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    batch.commit(noResult: true);
    return t.length;
  }

  /// 删除数据
  static Future<void> deleteItem<T extends DatabaseBean>(Database database, T t, {String key, value}) async {
    if (null == database || !database.isOpen) return null;
    if (key.isEmpty) {
      await database.delete(t.getTableName());
    } else {
      await database.delete(t.getTableName(), where: (key + " = ?"), whereArgs: [value]);
    }
  }

  /// 删除数据
  static Future<void> deleteCommonDatabaseItem<T extends DatabaseBean>(T t, {String key, value}) async {
    if (null == DatabaseUnion.commonDatabase || !DatabaseUnion.commonDatabase.isOpen) return null;
    if (key.isEmpty) {
      await DatabaseUnion.commonDatabase.delete(t.getTableName());
    } else {
      await DatabaseUnion.commonDatabase.delete(t.getTableName(), where: (key + " = ?"), whereArgs: [value]);
    }
  }

  /// 更新数据
  static Future<void> updateItem<T extends DatabaseBean>(Database database, T t, String key, value) async {
    if (null == database || !database.isOpen) return null;
    await database.update(t.getTableName(), t.convertToDatabaseJson(), where: (key + " = ?"), whereArgs: [value]);
  }

  /// 更新数据
  static Future<void> updateCommonDatabaseItem<T extends DatabaseBean>(T t, String key, value) async {
    if (null == DatabaseUnion.commonDatabase || !DatabaseUnion.commonDatabase.isOpen) return null;
    await DatabaseUnion.commonDatabase.update(t.getTableName(), t.convertToDatabaseJson(), where: (key + " = ?"), whereArgs: [value]);
  }

  /// 查询数据
  static Future<List<Map<String, dynamic>>> queryItems(Database database, String tableName, {String key = "", value}) async {
    if (null == database || !database.isOpen) return null;
    List<Map<String, dynamic>> maps = List();
    if (key.isEmpty) {
      maps = await database.query(tableName);
    } else {
      maps = await database.query(tableName, where: (key + " = ?"), whereArgs: [value]);
    }
    return maps;
  }

  /// 查询数据
  static Future<List<Map<String, dynamic>>> queryCommonDatabaseItems(String tableName, {String key = "", value}) async {
    if (null == DatabaseUnion.commonDatabase || !DatabaseUnion.commonDatabase.isOpen) return null;
    List<Map<String, dynamic>> maps = List();
    if (key.isEmpty) {
      maps = await DatabaseUnion.commonDatabase.query(tableName);
    } else {
      maps = await DatabaseUnion.commonDatabase.query(tableName, where: (key + " = ?"), whereArgs: [value]);
    }
    return maps;
  }
}

class DatabaseUnion {
  //数据库helper
  static DatabaseHelper _helper = DatabaseHelper();
  //通用数据库对象
  static Database commonDatabase;
  //私有数据库对象
  static Database individualDatabase;

  ///初始化私人数据库实例
  static Future<Database> createIndividualDatabase(String name) async {
    String databaseDir = await getDatabasesPath();
    String databasePath = join(databaseDir, name);
    if (individualDatabase == null) {
      individualDatabase = await _helper.getIndividualDatabase(databasePath, version: DatabaseConstants.individualVersion);
    }
    return individualDatabase;
  }

  ///初始化公用数据库实例
  static Future<Database> createCommonDatabase() async {
    String databaseDir = await getDatabasesPath();
    String databasePath = join(databaseDir, "commonUsage.db");
    if (commonDatabase == null) {
      commonDatabase = await _helper.getCommonDatabase(databasePath, version: DatabaseConstants.commonVersion);
    }
    return commonDatabase;
  }
}

class DatabaseHelper {
  Database _individualDb;

  Database _commonDb;

  String _commonPath;

  String _individualPath;

  final _lock = new Lock();

  ///获取通用数据库实例
  Future<Database> getCommonDatabase(String path, {int version = 1, bool forceOpenNew = false, bool readOnly = false, bool singleInstance = true}) async {
    if (!forceOpenNew && _commonPath != path) {
      if (_commonDb != null) {
        _commonDb.close();
        _commonDb = null;
      }
    }
    if (_commonDb == null) {
      await _lock.synchronized(() async {
        if (_commonDb == null) {
          _commonDb = await openDatabase(path,
              onConfigure: onConfigure,
              version: version,
              onCreate: onCommonCreate,
              onUpgrade: onCommonUpgrade,
              onDowngrade: onDatabaseDowngradeDelete,
              onOpen: onOpen,
              readOnly: readOnly,
              singleInstance: singleInstance);
        }
      });
    }
    return _commonDb;
  }

  ///获取私人数据库实例
  Future<Database> getIndividualDatabase(String path, {int version = 1, bool forceOpenNew = false, bool readOnly = false, bool singleInstance = true}) async {
    if (!forceOpenNew && _individualPath != path) {
      if (_individualDb != null) {
        _individualDb.close();
        _individualDb = null;
      }
    }
    if (_individualDb == null) {
      await _lock.synchronized(() async {
        if (_individualDb == null) {
          _individualDb = await openDatabase(path,
              onConfigure: onConfigure,
              version: version,
              onCreate: onIndividualCreate,
              onUpgrade: onIndividualUpgrade,
              onDowngrade: onDatabaseDowngradeDelete,
              onOpen: onOpen,
              readOnly: readOnly,
              singleInstance: singleInstance);
        }
      });
    }
    return _individualDb;
  }

  ///the first optional callback called
  Future<void> onConfigure(Database database) {
    return database.execute('PRAGMA foreign_keys = ON');
  }

  ///打开后的回调
  Future<void> onOpen(Database database) async {
    var version = await database.getVersion();
    LogUtil.debug("db-version:$version");
    return null;
  }

  ///初始化放啊
  Future<void> onIndividualCreate(Database database, int version) async {
    var commandList = DatabaseConstants.getIndividualCreateCommandList();
    if (commandList.isNotEmpty) {
      var batch = database.batch();
      commandList.forEach((command) {
        if (command != null && command.isNotEmpty) {
          batch.execute(command);
        }
      });
      await batch.commit();
    }
    return null;
  }

  ///升级版本操作
  Future<void> onIndividualUpgrade(Database database, int oldVersion, int newVersion) async {
    var commandList = DatabaseConstants.getIndividualUpgradeCommandList(oldVersion, newVersion);
    if (commandList.isNotEmpty) {
      var batch = database.batch();
      commandList.forEach((command) {
        if (command != null && command.isNotEmpty) {
          batch.execute(command);
        }
      });
      await batch.commit();
    }
    return null;
  }

  ///初始化放啊
  Future<void> onCommonCreate(Database database, int version) async {
    var commandList = DatabaseConstants.getCommonCreateCommandList();
    if (commandList.isNotEmpty) {
      var batch = database.batch();
      commandList.forEach((command) {
        if (command != null && command.isNotEmpty) {
          batch.execute(command);
        }
      });
      await batch.commit();
    }
    return null;
  }

  ///升级版本操作
  Future<void> onCommonUpgrade(Database database, int oldVersion, int newVersion) async {
    var commandList = DatabaseConstants.getCommonUpgradeCommandList(oldVersion, newVersion);
    if (commandList.isNotEmpty) {
      var batch = database.batch();
      commandList.forEach((command) {
        if (command != null && command.isNotEmpty) {
          batch.execute(command);
        }
      });
      await batch.commit();
    }
    return null;
  }
}

class DatabaseConstants {
  //公共数据库版本
  static const int commonVersion = 1;

  //私人数据库版本
  static const int individualVersion = 1;

  ///私人初始化数据库命令集合
  static List<String> getIndividualCreateCommandList() {
    return List<String>();
  }

  ///私人升级数据库命令集合
  static List<String> getIndividualUpgradeCommandList(int oldVersion, int newVersion) {
    return List<String>();
  }

  ///公用初始化数据库命令集合
  static List<String> getCommonCreateCommandList() {
    return [];
  }

  ///公共升级数据库命令集合
  static List<String> getCommonUpgradeCommandList(int oldVersion, int newVersion) {
    return [];
  }
}
