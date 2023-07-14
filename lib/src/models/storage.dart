import 'dart:io';
import 'dart:convert';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

 
 

  //setting up db connection
  const dbPath = '../db';
  final DatabaseFactory db_factory=databaseFactoryIo;
  Database db =db_factory.openDatabase(dbPath) as Database;
  StoreRef<String, String>  store1 =
      StoreRef<String, String>.main();
  
