import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class DatabaseProvider {
  static const String TABLE_USERS = "users";
  //static const String TABLE_DESKS = "desks";
  static const String COLUMN_OID = "oid";
  static const String COLUMN_DISPLAY_NAME = "displayName";
  //static const String COLUMN_CITY = "city";
  static const String COLUMN_COUNTRY = "country";
  static const String COLUMN_PHONE = "extension_PhoneNo";
  static const String COLUMN_EMAILS = "emails";
  //static const String COLUMN_STATE = "state";
  static const String COLUMN_ZIPCODE = "postalCode";
  static const String COLUMN_FAMILY = "family";
  static const String COLUMN_TYPE = "type";
  static const String COLUMN_STATUS = "status";
  static const String TABLE_LOGS = "logs";
  static const String COLUMN_DAILY_LOG = "dailyLog";
  static const String COLUMN_DATE = "date";
  static const String COLUMN_UPLOADED = "uploadStatus";
  static const String TABLE_BLE_GEN = "ble1";
  static const String COLUMN_UUID_DATE = "uuid";
  static const String COLUMN_OID_OTHER = "other";
  static const String TABLE_BLE_SCAN = "ble2";
  //static const String COLUMN_LOCATION = "location";
  //static const String COLUMN_TFP = "tfp";
  static const columns = [
    COLUMN_OID,
    COLUMN_DISPLAY_NAME,
    /* COLUMN_CITY,*/ COLUMN_COUNTRY,
    COLUMN_PHONE,
    COLUMN_EMAILS,
    /*COLUMN_STATE,*/ COLUMN_ZIPCODE,
    COLUMN_FAMILY,
    COLUMN_TYPE,
    COLUMN_STATUS
  ];
  //var user={'$COLUMN_OID':, '$COLUMN_DISPLAY_NAME':, '$COLUMN_COUNTRY':, '$COLUMN_PHONE':, '$COLUMN_EMAILS':, '$COLUMN_ZIPCODE':, '$COLUMN_FAMILY':, '$COLUMN_TYPE':, '$COLUMN_STATUS':};

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("Lazarus database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'lazarusDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating users table");

        await database.execute(
          "CREATE TABLE $TABLE_USERS ("
          "$COLUMN_OID TEXT PRIMARY KEY,"
          "$COLUMN_DISPLAY_NAME TEXT,"
          //"$COLUMN_CITY TEXT,"
          "$COLUMN_COUNTRY TEXT,"
          "$COLUMN_PHONE TEXT,"
          "$COLUMN_EMAILS TEXT,"
          //"$COLUMN_STATE TEXT,"
          "$COLUMN_ZIPCODE TEXT,"
          "$COLUMN_FAMILY TEXT,"
          "$COLUMN_TYPE TEXT,"
          "$COLUMN_STATUS TEXT"
          ")",
        );
        await database.execute(
          "CREATE TABLE $TABLE_LOGS ("
          "$COLUMN_OID TEXT,"
          "$COLUMN_DAILY_LOG TEXT,"
          "$COLUMN_DATE TEXT,"
          "$COLUMN_UPLOADED TEXT"
          ")",
        );
        await database.execute(
          "CREATE TABLE $TABLE_BLE_GEN ("
          "$COLUMN_OID TEXT,"
          "$COLUMN_UUID_DATE TEXT"
          ")",
        );
        await database.execute(
          "CREATE TABLE $TABLE_BLE_SCAN ("
          "$COLUMN_OID TEXT,"
          "$COLUMN_UUID_DATE TEXT,"
          "$COLUMN_OID_OTHER TEXT,"
          "$COLUMN_UPLOADED TEXT"
          ")",
        );
      },
    );
  }

  Future<List> getUsers() async {
    final db = await database;
    var users;
    try {
      users = await db.query(TABLE_USERS, columns: [
        COLUMN_OID,
        COLUMN_DISPLAY_NAME,
        /* COLUMN_CITY,*/ COLUMN_COUNTRY,
        COLUMN_PHONE,
        COLUMN_EMAILS,
        /*COLUMN_STATE,*/ COLUMN_ZIPCODE,
        COLUMN_FAMILY,
        COLUMN_TYPE,
        COLUMN_STATUS
      ]);
    } catch (e) {
      print(e.toString());
    }
    print("Users got");
    print(users.toList());
    if ((users == null || users.isEmpty)) {
      return null;
    } else {
      return users.toList();
    }
  }

  Future getUser(String oid) async {
    final db = await database;
    var user;
    try {
      user = await db.query(
        TABLE_USERS,
        columns: [
          COLUMN_OID,
          COLUMN_DISPLAY_NAME,
          /* COLUMN_CITY,*/ COLUMN_COUNTRY,
          COLUMN_PHONE,
          COLUMN_EMAILS,
          /*COLUMN_STATE,*/ COLUMN_ZIPCODE,
          COLUMN_FAMILY,
          COLUMN_TYPE,
          COLUMN_STATUS
        ],
        where: '$COLUMN_OID = ?',
        whereArgs: [oid],
      );
    } catch (e) {
      print(e.toString());
    }
    print("User got");
    print(user.toList().first);
    if ((user == null || user.isEmpty)) {
      return null;
    } else {
      return user.toList().first;
    }
  }

  Future getNullDisplayName() async {
    final db = await database;
    var user;
    try {
      user = await db.query(
        TABLE_USERS,
        columns: columns,
        where: '$COLUMN_DISPLAY_NAME = ?',
        whereArgs: [''],
      );
    } catch (e) {
      print(e.toString());
    }
    print("NullDisaplayName got");
    print(user.toList().first);
    if ((user == null || user.isEmpty)) {
      return null;
    } else {
      return user.toList().first;
    }
  }

  Future<void> insertUser(Map<String, String> user) async {
    final db = await database;
    try {
      await db.insert(TABLE_USERS, user);
      print("Inserted");
    } catch (e) {
      print(e.toString());
    }
    /*var temp = (await db.query(
      TABLE_USERS,
      columns: [
        COLUMN_OID,
        COLUMN_DISPLAY_NAME,
        /* COLUMN_CITY,*/ COLUMN_COUNTRY,
        COLUMN_PHONE,
        COLUMN_EMAILS,
        /*COLUMN_STATE,*/ COLUMN_ZIPCODE,
        COLUMN_FAMILY,
        COLUMN_TYPE,
        COLUMN_STATUS
      ],
    ));
    print("ins_user==$temp");
    Map tempMap = temp.first;
    print("ins_user.first==$tempMap");*/
    //await registerFamily();
  }

  Future<void> setupDatabase(
      Map<String, dynamic> payloadMap, String type) async {
    Map<String, String> user = {
      COLUMN_OID: payloadMap[COLUMN_OID].toString(),
      COLUMN_DISPLAY_NAME: payloadMap[COLUMN_DISPLAY_NAME] == null
          ? ''
          : payloadMap[COLUMN_DISPLAY_NAME].toString(),
      COLUMN_COUNTRY: type != 'FB' ? payloadMap[COLUMN_COUNTRY].toString() : '',
      COLUMN_PHONE: type != 'FB' ? payloadMap[COLUMN_PHONE].toString() : '',
      COLUMN_EMAILS: type != 'FB' ? payloadMap[COLUMN_EMAILS].join(',') : '',
      COLUMN_ZIPCODE: type != 'FB' ? payloadMap[COLUMN_ZIPCODE].toString() : '',
      COLUMN_FAMILY: '',
      COLUMN_TYPE: type == 'P'
          ? 'Parent'
          : (type == 'F' ? 'Family' : (type == 'FB' ? 'FamilyB' : 'Desk')),
      COLUMN_STATUS: 'SAFE'
    };
    print("SetupDatabaseUser0==$user");
    try {
      await DatabaseProvider.db.insertUser(user);
      print("SetupDatabaseUser2==$user");
    } catch (e) {
      String error = e.toString();
      print("SetupDatabase error:$error");
    }
  }

  Future<void> deleteOid(String oid) async {
    final db = await database;
    try {
      await db.delete(
        TABLE_USERS,
        where: "$COLUMN_OID = ?",
        whereArgs: [oid],
      );
    } catch (e) {
      String error = e.toString();
      print("delete error: $error");
    }
    //await registerFamily();
    print("Deleted");
  }

  Future<void> updateUser(Map<String, String> user) async {
    final db = await database;
    try {
      await db.update(
        TABLE_USERS,
        user,
        where: "$COLUMN_OID = ?",
        whereArgs: [user[COLUMN_OID]],
      );
      print("User updated");
    } catch (e) {
      print(e.toString());
    }
  }

  Future getParent() async {
    final db = await database;
    var parent;
    try {
      var temp = await db.query(
        TABLE_USERS,
        columns: [
          COLUMN_OID,
          COLUMN_DISPLAY_NAME,
          /* COLUMN_CITY,*/ COLUMN_COUNTRY,
          COLUMN_PHONE,
          COLUMN_EMAILS,
          /*COLUMN_STATE,*/ COLUMN_ZIPCODE,
          COLUMN_FAMILY,
          COLUMN_TYPE,
          COLUMN_STATUS
        ],
        where: '$COLUMN_TYPE = ?',
        whereArgs: [
          'Parent',
        ],
      );
      parent = temp.toList().first;
      print("getParentfromtemp:$parent");
    } catch (e) {
      print(e.toString());
      print("NOTgetParentfromtemp:$parent");
    }
    return parent;
  }

  Future<List> getFamily() async {
    final db = await database;
    var family = await db.query(
      TABLE_USERS,
      columns: [
        COLUMN_OID,
        COLUMN_DISPLAY_NAME,
        /* COLUMN_CITY,*/ COLUMN_COUNTRY,
        COLUMN_PHONE,
        COLUMN_EMAILS,
        /*COLUMN_STATE,*/ COLUMN_ZIPCODE,
        COLUMN_FAMILY,
        COLUMN_TYPE,
        COLUMN_STATUS
      ],
      where: '$COLUMN_TYPE IN (?,?,?)',
      whereArgs: ['Family', 'FamilyB', 'Parent'],
    );
    print("Family got");
    print(family.toList());
    return family.toList();
  }

  Future<void> registerFamily() async {
    List family = await getFamily();
    List<String> familyOid = [];
    List<String> rest = [];
    family.forEach((currentUser) {
      familyOid.add(currentUser[COLUMN_OID].toString());
      rest.add(currentUser[COLUMN_OID].toString());
    });
    print("familyOid=$familyOid");
    for (final currentUser in familyOid) {
      print("Current:$currentUser");
      // ignore: unused_local_variable
      bool t = rest.remove(currentUser);
      List temp = rest;
      Map<String, String> user = {
        COLUMN_FAMILY: temp.join(','),
        COLUMN_OID: currentUser
      };
      print("temp:$temp");
      rest.add(currentUser);
      await updateUser(user);
      print("Update:$user");
    }
  }

  Future<List> getLog(String oid) async {
    final db = await database;
    var log;
    try {
      log = await db.query(
        TABLE_LOGS,
        columns: [COLUMN_OID, COLUMN_DAILY_LOG, COLUMN_DATE, COLUMN_UPLOADED],
        where: '$COLUMN_OID = ?',
        whereArgs: [oid],
      );
    } catch (e) {
      print(e.toString());
    }
    print("Log got");
    print(log.toList());
    if ((log == null || log.isEmpty)) {
      return null;
    } else {
      return log.toList();
    }
  }

  Future getLogAtDate(String oid, DateTime dateTime) async {
    final db = await database;
    var log;
    String date = dateTime.toUtc().toIso8601String().substring(0, 10);
    try {
      log = await db.query(
        TABLE_LOGS,
        columns: [COLUMN_OID, COLUMN_DAILY_LOG, COLUMN_DATE, COLUMN_UPLOADED],
        where: '$COLUMN_OID = ? and $COLUMN_DATE=?',
        whereArgs: [oid, date],
      );
    } catch (e) {
      print(e.toString());
    }
    print("Log got");
    if (log == null || log.isEmpty) {
      print(log);
      return '';
    } else {
      print(log.toList().first);
      return log.toList().first;
    }
  }

  Future<void> insertLog(Map<String, String> logMap) async {
    final db = await database;
    try {
      await db.insert(TABLE_LOGS, logMap);
      print("LogInserted");
      print("LogMap: $logMap");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateLog(String oid, String log, DateTime dateTime) async {
    var t = await getLogAtDate(oid, dateTime);
    if (t != '') {
      Map<String, String> logMap = {
        COLUMN_OID: oid,
        COLUMN_DAILY_LOG: t[COLUMN_DAILY_LOG] + ',' + log,
        COLUMN_DATE: t[COLUMN_DATE],
        COLUMN_UPLOADED: t[COLUMN_UPLOADED]
      };
      final db = await database;
      await db.update(
        TABLE_LOGS,
        logMap,
        where: "$COLUMN_OID = ?",
        whereArgs: [logMap[COLUMN_OID]],
      );
      print("Log updated");
      print("LogMap: $logMap");
    } else {
      Map<String, String> logMap = {
        COLUMN_OID: oid,
        COLUMN_DAILY_LOG: log,
        COLUMN_DATE: dateTime.toUtc().toIso8601String().substring(0, 10),
        COLUMN_UPLOADED: 'N'
      };
      await insertLog(logMap);
    }
  }

  Future<String> getUUIDAtDate(String oid) async {
    final db = await database;
    var log;
    DateTime dateTime = DateTime.now().toUtc();
    print('getUUIDAtDate : ${dateTime.toIso8601String()}');
    String min =
        ((dateTime.hour * 60 + dateTime.minute) / 10).floor().toString();
    String date = dateTime.toIso8601String().substring(0, 10) +
        ('0' * (3 - min.length)) +
        min;
    try {
      log = await db.query(
        TABLE_BLE_GEN,
        columns: [COLUMN_OID, COLUMN_UUID_DATE],
        where: "$COLUMN_OID = ? and $COLUMN_UUID_DATE LIKE ?",
        whereArgs: [oid, '%$date'],
      );
    } catch (e) {
      print(e.toString());
    }
    print("UUID got");
    if (log == null || log.isEmpty) {
      var uuid = Uuid();
      String uuid1 = uuid.v4().toString();
      uuid1 =
          uuid1.substring(0, 9) + '0786' + uuid1.substring(13, uuid1.length);
      print('UUID: $uuid1');
      Map<String, String> logMap = {
        COLUMN_OID: oid,
        COLUMN_UUID_DATE: (uuid1 + date)
      };
      await db.insert(TABLE_BLE_GEN, logMap);
      print('UUIDlog $logMap inserted');
      return uuid1;
    } else {
      print('UUIDlog already present');
      String uuid2 = log.toList().first[COLUMN_UUID_DATE];
      uuid2 = uuid2.substring(0, (uuid2.length - date.length));
      print('UUID: $uuid2');
      return uuid2;
    }
  }

  Future<String> getUUIDDate(String oid, DateTime dateTime) async {
    final db = await database;
    var log;
    dateTime = dateTime.toUtc();
    String min =
        ((dateTime.hour * 60 + dateTime.minute) / 10).floor().toString();
    String date = dateTime.toIso8601String().substring(0, 10) +
        ('0' * (3 - min.length)) +
        min;
    try {
      log = await db.query(
        TABLE_BLE_GEN,
        columns: [COLUMN_OID, COLUMN_UUID_DATE],
        where: "$COLUMN_OID = ? and $COLUMN_UUID_DATE LIKE ?",
        whereArgs: [oid, '%$date'],
      );
    } catch (e) {
      print(e.toString());
    }
    print("UUID got");
    if (log == null || log.isEmpty) {
      var uuid = Uuid();
      String uuid1 = uuid.v4().toString();
      uuid1 =
          uuid1.substring(0, 9) + '0786' + uuid1.substring(13, uuid1.length);
      print('UUID: $uuid1');
      Map<String, String> logMap = {
        COLUMN_OID: oid,
        COLUMN_UUID_DATE: (uuid1 + date)
      };
      await db.insert(TABLE_BLE_GEN, logMap);
      print('UUIDlog $logMap inserted');
      return uuid1 + date;
    } else {
      print('UUIDlog already present');
      String uuid2 = log.toList().first[COLUMN_UUID_DATE];
      print('UUID: $uuid2');
      return uuid2;
    }
  }

  Future<void> logAttendance(Map contact, String oid) async {
    final db = await database;
    String uuid = await getUUIDDate(oid, DateTime.now().toUtc());
    Map<String, String> logMap = {
      COLUMN_OID: oid,
      COLUMN_UUID_DATE: uuid,
      COLUMN_OID_OTHER: contact[COLUMN_OID].toString(),
      COLUMN_UPLOADED: 'N'
    };
    await db.insert(TABLE_BLE_SCAN, logMap);
    print('logMap inserted: $logMap');
  }

  String getDate(DateTime dateTime) {
    dateTime = dateTime.toUtc();
    String min =
        ((dateTime.hour * 60 + dateTime.minute) / 10).floor().toString();
    String date = dateTime.toIso8601String().substring(0, 10) +
        ('0' * (3 - min.length)) +
        min;
    return date;
  }

  Future<void> logUUID(String oid, String uuid, DateTime dateTime) async {
    String uuid1 = uuid + getDate(dateTime.toUtc());
    final db = await database;
    Map<String, String> logMap = {
      COLUMN_OID: oid,
      COLUMN_UUID_DATE: uuid1,
      COLUMN_OID_OTHER: '',
      COLUMN_UPLOADED: 'N'
    };
    await db.insert(TABLE_BLE_SCAN, logMap);
    print('logMap inserted: $logMap');
  }
}
