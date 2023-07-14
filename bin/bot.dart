import 'dart:io';
import 'package:bot/src/models/bot.dart' as bot;
import 'package:bot/src/models/storage.dart';
import 'package:bot/src/models/admin.dart';
import 'package:args/args.dart';
import 'package:sembast/sembast.dart';
// import 'dart:convert';
import 'package:sembast/sembast_io.dart';



void main(List<String> arguments)async {
  
  //setting up db connection
  const dbPath = '../lib/src/db/database.db';
  final DatabaseFactory db_factory=databaseFactoryIo;
  Database db = await db_factory.openDatabase(dbPath);
  StoreRef<String,String>  store1 =
      StoreRef<String, String>.main();

  

  
  
  
  
  //initial ask for login or register
  
  Admin.initial();


  
  

  
  await db.close();
}
