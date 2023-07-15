import 'dart:io';
import 'dart:convert';
import 'package:sembast/sembast.dart';
import 'package:bot/src/models/storage.dart';
import 'package:bot/src/models/admin.dart';
import 'package:bot/src/models/exceptions.dart';
import 'package:args/args.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'admin1.dart';



Future<void> main(List<String> arguments)async {
  
  var st=  Storage.constructor1();
  await st.connection();

  
  print("checking");
  List<dynamic> myList= await st.connection();
  Database db=myList[0];
  print("working 1");

  StoreRef<String, String> user_store =myList[1]; 
  var records = myList[3];

  StoreRef<String, String> c_user =myList[2]; 
  

  
  print("working 2");
  Future<void> initial() async {
    stdout.write('Register or Login (r/l) ');
    final input = stdin.readLineSync();

    switch (input) {
      case 'r':
        await Admin.register(db, user_store, c_user, records);
        break;
      case 'l':
        await Admin.login(db, user_store, c_user, records);
        break;
      default:
        print('Invalid Input');
    }
  }

//Asking for initial login or register
  await initial();

  await db.close();
}