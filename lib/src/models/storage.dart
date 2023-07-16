import 'dart:io';
import 'dart:convert';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class Storage {
  late final db1;
  late final db2;
  late final db3;

  late final user_store;
  late final records;
  late final server_record;
  late final channel_record;

  late final server_store;
  late final channel_store;

  Storage.constructor1();
  Storage(this.db1,this.db2,this.db3, this.user_store, this.server_store, this.channel_store,
      this.records,this.server_record,this.channel_record) {
    print("constructor called");
  }

  Future<List> connection() async {
    print("working");
    // setting up db connection
    const Path_User = 'lib/src/db/database.db';
    const Path_Server = 'lib/src/db/server.db';
    const Path_Channel='lib/src/db/channel.db';
    // const dbPath1 = 'lib/src/db/c_user.db';
    final DatabaseFactory db_factory = databaseFactoryIo;
    print("ooof");
    Database db1 = await db_factory.openDatabase(Path_User);
    Database db2 = await db_factory.openDatabase(Path_Server);
    Database db3 = await db_factory.openDatabase(Path_Channel);
    
    print("fuck");

    StoreRef<String, String> user_store1 = StoreRef<String, String>.main();
    print("check3");
    StoreRef<String, Map> server_store = StoreRef<String, Map>.main();
    print("check4");
    StoreRef<String, Map> channel_store = StoreRef<String, Map>.main();
    print("check5");

    var records = await user_store1.find(db1);
    var server_record =await server_store.find(db2);
    var channel_record=await server_store.find(db3);
    

    // this.user_store = User;
    print("yoyo1");
    Storage storage =
        Storage(db1,db2,db3, user_store1, server_store, channel_store, records,server_record,channel_record);
    
    print("yoyo");

    return [
      storage.db1,
      storage.db2,
      storage.db3,
      storage.user_store,
      storage.server_store,
      storage.channel_store,
      storage.records,storage.server_record,storage.channel_record
    ];
  }
}
