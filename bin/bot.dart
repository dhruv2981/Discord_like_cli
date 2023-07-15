 import 'dart:io';
import 'dart:convert';
import 'package:sembast/sembast.dart';
import 'package:bot/src/models/storage.dart';
import 'package:bot/src/models/admin.dart';
import 'package:args/args.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'admin1.dart';



void main(List<String> arguments)async {
  
  var st=  Storage.constructor1();
  await st.connection();

  
  print("checking");
  List<dynamic> myList= await st.connection();
  Database db=myList[0];
  print("working 1");

  StoreRef<String, String> user_store =myList[1]; 

  
  print("working 2");
  void initial() {
    stdout.write('Register or Login (r/l) ');
    final input = stdin.readLineSync();

    switch (input) {
      case 'r':
        Admin.register(db, user_store);
        break;
      case 'l':
        Admin.login();
        break;
      default:
        print('Invalid Input');
    }
  }

//Asking for initial login or register
  initial();

  
  await db.close();
}