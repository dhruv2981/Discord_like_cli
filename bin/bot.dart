import 'dart:io';
import 'dart:convert';
import 'package:bot/src/models/message.dart';
import 'package:sembast/sembast.dart';
import 'package:bot/src/models/storage.dart';
import 'package:bot/src/models/admin.dart';
// import 'package:bot/src/models/admin.dart';
import 'package:bot/src/models/server.dart';
// import 'package:bot/src/models/exceptions.dart';
import 'package:args/args.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

Future<void> main(List<String> arguments) async {
  var st = Storage.constructor1();
  // await st.connection();
  print("why");
  List<dynamic> myList = await st.connection();
  Database db1 = myList[0];
  Database db2 = myList[1];
  Database db3 = myList[2];
  Database db5 = myList[3];
  StoreRef<String, String> user_store = myList[4];
  StoreRef<String, Map> server_store = myList[5];
  print("check5");
  StoreRef<String, Map> channel_store = myList[6];
  StoreRef<Map, String> p_dm_store = myList[7];
  var records = myList[8];
  var server_record = myList[9];
  var channel_record = myList[10];

  print("check6");
  C_user c_user_c = new C_user("0",
      "0"); //the name is c_user_c because c_user is already something so to avoid confusion

  Future<void> initial() async {
    stdout.write('Register or Login (r/l) ');
    final input = stdin.readLineSync();
    switch (input) {
      case 'r':
        await Admin.register(db1, user_store, records, c_user_c);
        break;
      case 'l':
        await Admin.login(db1, user_store, records, c_user_c);
        break;
      default:
        print('Invalid Input');
    }
  }

//Asking for initial login or register
  await initial();
  var c_server = Server.constructor();
  var c_channel = Channel.constructor();
  Personal_dm c_msg = Personal_dm();

  // await c_server.create_server(db2, server_store, c_user_c, server_record);
  // await c_server.create_server(db2, server_store, c_user_c, server_record);
  // await c_channel.add_channel(db2,db3,channel_store, server_store, c_user_c, channel_record ,server_record);
  await c_msg.personal_dm(db5, db1, p_dm_store, user_store, c_user_c);
  await c_msg.open_personal_dm(db5, p_dm_store, c_user_c);

  await db1.close();
  await db2.close();
  await db3.close();
  await db5.close();
}
