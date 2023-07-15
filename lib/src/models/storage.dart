import 'dart:io';
import 'dart:convert';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';


class Storage{
  late final db;
  late final user_store;
  Storage.constructor1();
  Storage(this.db, this.user_store ){
    print("constructor called");
  }

  Future<List> connection() async {
  print("working");
  // setting up db connection
  const dbPath = 'lib/src/db/database.db';
  final DatabaseFactory db_factory=databaseFactoryIo;
  print("ooof");
  Database db1 =await  db_factory.openDatabase(dbPath); ///this is the problem
  print("fuck");

  StoreRef<String, String> user_store1 = StoreRef<String, String>.main();
  // this.user_store = User;
  print("yoyo1");
  Storage storage = Storage(db1, user_store1);
  Database db2 = storage.db;
  print("yoyo");

 
   return [storage.db,storage.user_store];
  }



}
