import 'dart:io';
import 'package:bot/src/models/message.dart';
import 'package:sembast/sembast.dart';
import 'package:bot/src/models/storage.dart';
import 'package:bot/src/models/admin.dart';
import 'package:bot/src/models/direct_message.dart';
import 'package:bot/src/models/server.dart';


void main() async {
  var st = Storage.constructor1();
  C_user c_user_c = new C_user("0", "0");
  //the name is c_user_c because c_user is already something so to avoid confusion
  var c_server = Server.constructor();
  var c_channel = Channel.constructor();
  Personal_dm c_msg = Personal_dm();

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

  var records = myList[10];
  var server_record = myList[11];
  var channel_record = myList[12];
  var message_record = myList[13];
  var p_dm_record = myList[14];

  bool flag = true;
  while (flag) {
    stdout.write('\n>> ');
    var input = stdin.readLineSync() as String;

    // Process the input and perform desired operations
    // final output = processInput(input);
    switch (input) {
      case "register":
        await Admin.register(db1, user_store, records, c_user_c);
        break;
      case "login":
        await Admin.login(db1, user_store, records, c_user_c);
        break;
      case "join_server":
        await c_server.join_server(db2, server_store, c_user_c, server_record);
        break;
      case "create_server":
        await c_server.create_server(
            db2, server_store, c_user_c, server_record);
        break;
      case "add_channel":
        await c_channel.add_channel(db2, db3, channel_store, server_store,
            c_user_c, channel_record, server_record);
        break;
      case "send_c_message":
        await channel_message(
            db2,
            db3,
            db4,
            server_store,
            channel_store,
            message_store,
            c_user_c,
            server_record,
            channel_record,
            message_record);
        break;
      case "open_c_message":
        await show_channel_message(
            db2,
            db3,
            db4,
            server_store,
            channel_store,
            message_store,
            c_user_c,
            server_record,
            channel_record,
            message_record);
        break;
      case "open_chats":
        await c_msg.open_personal_dm(db5, p_dm_store, c_user_c);
        break;
      case "send_chat":
        await c_msg.personal_dm(db5, db1, p_dm_store, user_store, c_user_c);
        break;
      // case "help":

      case "logout":
        await Admin.logout(c_user_c);
        flag = false;
        break;
      default:
        print("Invalid input");
    }
  }
  await db1.close();
  await db2.close();
  await db3.close();
  await db4.close();
  await db5.close();
}
