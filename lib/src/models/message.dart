import 'dart:io';
import 'admin.dart';
import 'package:sembast/sembast.dart';
import 'common_function.dart';

class Chan_message extends comm_function {
  Future<void> channel_message(
      Database db2,Database db3,Database db4,StoreRef<String, Map> server_store,
      StoreRef<String, Map> channel_store,StoreRef<Map, Map> message_store,C_user c_user1) async {
    if (await super.user_logged_in(c_user1)) {
      return;
    } else {

      //Taking inputs of the server and channel in which user wants to message
      stdout.write("In which server do you want to message: ");
      String s_name = stdin.readLineSync() as String;

      final String username = c_user1.username;

      //checking validity of server
      Map? pr = await server_store.record(s_name).get(db2)
          as Map?; // -->the corresponding server to the server name

      //if the channel does not exist
      if (pr == null) {
        print("\x1B[31mServer does not exist\x1B[0m");
        return;
      }
      //if the user is not in the server
      bool flag1 = false;
      var user_role;
      for (var user_name in pr['mem_list']) {
        if (user_name['name'] == username) {
          flag1 = true;
          user_role = user_name['role'];
          break;
        }
      }
      if (!flag1) {
        print("\x1B[31mThe user is not in the given server\x1B[0m");
        return;
      } else {
        //means user is in the server

        stdout.write("In which channel do you want to message: ");
        String c_name = stdin.readLineSync() as String;

        //checking validity of channel
        Map? po = await channel_store.record(c_name).get(db3)
            as Map?; // -->the corresponding channel to the channel name
        //if the channel does not exist
        if (po == null) {
          print("\x1B[31mChannel does not exist\x1B[0m");
          return;
        }
        //if the user is not in the channel
        bool flag2 = false;
        var c_type;
        for (var user_name in po['mem_list']) {
          if (user_name == username && po['server_name'] == s_name) {
            flag2 = true;
            c_type = po['type'];
          }
        }
        if (!flag2) {
          print("\x1B[31mThe user is not in the given channel\x1B[0m");
          return;
        } else {
          //checking role of user and type of channel and send message

          if (c_type == "stage" || c_type == "voice" || c_type == "rules") {
            if (user_role == "newbie") {
              print("\x1B[31mU need to have admin or mod role\x1B[0m");
              return;
            }
          }

          //Assuming that the user is in the selected server and in the selected channel
          // message_record=await message_store.find(db4);
          stdout.write("Enter the message you want to send: ");
          String message = stdin.readLineSync() as String;

          //Making the key and value maps and putting in message store
          Map message_key = {'channel_name': c_name, 'server_name': s_name};
          Map message_value = {'user': username, 'message': message};
          await message_store.record(message_key).put(db4, message_value);
          print("\x1B[32mMessage sent successfully.\x1B[0m");
        }
      }
    }
  }

  Future<void> show_channel_message(
    Database db2, Database db3,Database db4,StoreRef<String, Map> server_store, 
    StoreRef<String, Map> channel_store,StoreRef<Map, Map> message_store,C_user c_user1
    
  ) async {
    if (await super.user_logged_in(c_user1)) {
      return;
    } else {

      //Taking inputs of the server and channel in which user wants to message
      stdout.write("In which server do you want to see all messages: ");
      String s_name = stdin.readLineSync() as String;

      final String username = c_user1.username;

      //checking validity of server
      Map? pr = await server_store.record(s_name).get(db2)
          as Map?; // -->the corresponding server to the server name

      //if the channel does not exist
      if (pr == null) {
        print("\x1B[31mServer does not exist\x1B[0m");
        return;
      }
      
      if (!(await super.user_in_server(s_name, db2, server_store, c_user1))) {
        return;
      } else {
        //means user is in the server

        stdout.write("In which channel do you want to see all messages: ");
        String c_name = stdin.readLineSync() as String;

        //checking validity of channel
        Map? po = await channel_store.record(c_name).get(db3)
            as Map?; // -->the corresponding channel to the channel name
        //if the channel does not exist
        if (po == null) {
          print("\x1B[31mChannel does not exist\x1B[0m");
          return;
        }
        //if the user is not in the channel
        var c_type;
        bool flag2 = false;
        for (var user_name in po['mem_list']) {
          if (user_name == username && po['server_name'] == s_name) {
            flag2 = true;
            c_type = po['type'];
          }
        }
        if (!flag2) {
          print("\x1B[31mThe user is not in the given channel\x1B[0m");
          return;
        } else {
          //Assuming that the user is in the selected server and in the selected channel
          var message_record = await message_store.find(db4);
          switch (c_type) {
            case 'text':
              print('Text messages in channel: ');
              break;
            case 'voice':
              print('Audio messages in channel: ');
              break;
            case 'stage':
              print('Messages in stage type channel: ');
              break;
          }
          for (var rec in message_record) {
            print("##" + rec.value['user'] + ": " + rec.value['message']);
          }
        }
      }
    }
  }
}
