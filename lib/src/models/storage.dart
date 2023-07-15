import 'dart:io';
import 'dart:convert';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';


class Storage{
  late final db;
  late final user_store;
  late final records;
  late final c_user;
  Storage.constructor1();
  Storage(this.db, this.user_store, this.c_user, this.records){
    print("constructor called");
  }

  Future<List> connection() async {
  print("working");
  // setting up db connection
  const dbPath = 'lib/src/db/database.db';
  // const dbPath1 = 'lib/src/db/c_user.db';
  final DatabaseFactory db_factory=databaseFactoryIo;
  print("ooof");
  Database db1 =await  db_factory.openDatabase(dbPath);
  print("fuck");

  StoreRef<String, String> user_store1 = StoreRef<String, String>.main();
  StoreRef<String, String> c_user = StoreRef<String, String>.main();

  var records = await user_store1.find(db1); 

  // this.user_store = User;
  print("yoyo1");
  Storage storage = Storage(db1, user_store1, c_user, records);
  Database db2 = storage.db;
  print("yoyo");

 
   return [storage.db,storage.user_store, storage.c_user, storage.records];
  }


}
