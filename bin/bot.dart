import 'dart:io';
import 'package:sembast/sembast.dart';
import 'package:bot/src/models/storage.dart';
import 'package:bot/src/models/admin.dart';
import 'package:bot/src/models/message.dart';
import 'package:bot/src/models/direct_message.dart';
import 'package:bot/src/models/server.dart';
import 'package:bot/src/models/others.dart';


Future<void> main(List<String> arguments) async {
  var st = Storage.constructor1();
  // await st.connection();
  print("why");
  List<dynamic> myList = await st.connection();
  Database db1 = myList[0];
  Database db2 = myList[1];
  Database db3 = myList[2];
  Database db4 = myList[3];
  Database db5 = myList[4];

  StoreRef<String, String> user_store = myList[5];
  StoreRef<String, Map> server_store = myList[6];
  StoreRef<String, Map> channel_store = myList[7];
  StoreRef<Map, Map> message_store = myList[8];
  StoreRef<Map, String> p_dm_store = myList[9];

  print("check5");
  var records = myList[10];
  var server_record = myList[11];
  var channel_record = myList[12];
  var message_record = myList[13];
  var p_dm_record = myList[14];

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
  // await c_server.join_server(db2, server_store, c_user_c, server_record);
  // await c_channel.add_channel(db2,db3,channel_store, server_store, c_user_c, channel_record ,server_record);
  // await channel_message(db2, db3, db4, server_store, channel_store,
  //     message_store, c_user_c, server_record, channel_record, message_record);
  // await show_channel_message(db2, db3, db4, server_store, channel_store,
  //     message_store, c_user_c, server_record, channel_record, message_record);
  // await c_msg.open_personal_dm(db5, p_dm_store, c_user_c);
  show_channels(db2, server_store, c_user_c);

  await db1.close();
  await db2.close();
  await db3.close();
  await db4.close();
  await db5.close();
}
