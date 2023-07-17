import 'dart:io';
import 'dart:convert';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class Storage {
  late final db1;
  late final db2;
  late final db3;
  late final db5;

  late final records;
  late final server_record;
  late final channel_record;
  late final p_dm_record;

  late final user_store;
  late final server_store;
  late final channel_store;
  late final p_dm_store;

  Storage.constructor1();
  Storage(
      this.db1,
      this.db2,
      this.db3,
      this.db5,
      this.user_store,
      this.server_store,
      this.channel_store,
      this.p_dm_store,
      this.records,
      this.server_record,
      this.channel_record,
      this.p_dm_record) {
    print("constructor called");
  }

  Future<List> connection() async {
    print("working");
    // setting up db connection
    const Path_User = 'lib/src/db/database.db';
    const Path_Server = 'lib/src/db/server.db';
    const Path_Channel = 'lib/src/db/channel.db';
    const Path_Personal_Dm = 'lib/src/db/personal_dm.db';

    final DatabaseFactory db_factory = databaseFactoryIo;
    print("ooof");
    Database db1 = await db_factory.openDatabase(Path_User);
    Database db2 = await db_factory.openDatabase(Path_Server);
    Database db3 = await db_factory.openDatabase(Path_Channel);
    Database db5 = await db_factory.openDatabase(Path_Personal_Dm);

    print("fuck");

    StoreRef<String, String> user_store1 = StoreRef<String, String>.main();
    print("check3");
    StoreRef<String, Map> server_store = StoreRef<String, Map>.main();
    print("check4");
    StoreRef<String, Map> channel_store = StoreRef<String, Map>.main();
    StoreRef<Map, String> p_dm_store = StoreRef<Map,String>.main();
    print("check5");

    var records = await user_store1.find(db1);
    var server_record = await server_store.find(db2);
    var channel_record = await channel_store.find(db3);
    var p_dm_record = await p_dm_store.find(db5);

    // this.user_store = User;
    print("yoyo1");
    Storage storage = Storage(
        db1,
        db2,
        db3,
        db5,
        user_store1,
        server_store,
        channel_store,
        p_dm_store,
        records,
        server_record,
        channel_record,
        p_dm_record);

    print("yoyo");

    return [
      storage.db1,
      storage.db2,
      storage.db3,
      storage.db5,
      storage.user_store,
      storage.server_store,
      storage.channel_store,
      storage.p_dm_store,
      storage.records,
      storage.server_record,
      storage.channel_record,
      storage.p_dm_record,
    ];
  }
}
