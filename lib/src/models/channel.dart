import 'dart:io';
import 'package:sembast/sembast.dart';
import 'admin.dart';
import 'package:sembast/utils/value_utils.dart';

enum ChannelType {
  text,
  voice,
  stage,
}

class Channel {
  late String name;
  late ChannelType type;
  late String server;
  late List<String> mem_list;


  add_channel(
    Database db2,
    Database db3,
    StoreRef<String, Map> channel_store,
    StoreRef<String, Map> server_store,
    C_user c_user1,
    var channel_record,
    var server_record,
  ) async {
    //if no user is logged in
    if (c_user1.username == "0") {
      print("No user has logged in you crazy fool");
      return;
    } else {
      stdout.write("Server in which u want to add channel: ");
      final s_name = stdin.readLineSync() as String;

      //keep care of record these are of time when connection function was called
      var s_record = await server_store.find(db2);

      //checking if such a sever exist and if the server is in that server
      bool user_in_server = false;
      // bool server_exist = false; //for future use
      for (var rec in s_record) {
        if (rec.key == s_name) {
          // server_exist = true;
          for (String user in rec.value['mem_list']) {
            if (user == c_user1.username) {
              user_in_server = true;
            }
          }
        }
      }
      //if user not in this server or if the user does not exist
      if (!user_in_server) {
        print("User is not in this server");
        return;
      }
      //user is in such a server
      stdout.write("Channel Name: ");
      final c_name = stdin.readLineSync() as String;
      this.name = c_name;

      stdout.write("Channel Type: ");
      final c_type = stdin.readLineSync() as String;

      //ctype must be of particular types only
      switch (c_type) {
        case 'text':
          this.type = ChannelType.text;
          break;
        case 'voice':
          this.type = ChannelType.voice;
          break;
        case 'stage':
          this.type = ChannelType.stage;
          break;
        default:
          print("Invalid input");
          return;
      }

      //checking if such a channel exists
      // bool channel_exist = false;
      for (var rec in channel_record) {
        //checking if this is the channel of the correct type and in the correct server  (shannel name making unique in a server)
        if (rec.key == c_name &&
            // rec.value['type'] == c_type &&
            rec.value['server_name'] == s_name) {
          // channel_exist = true;

          //hence checking if the current user is already in the channel
          for (var user in rec.value['mem_list']) {
            if (user == c_user1.username) {
              print("User is already in the channel");
              return;
            }
          }
          //channel exists but the user is not in it

          Map po = await channel_store.record(c_name).get(db3) as Map;
          po = cloneMap(po); //Create a copy of the map
          po['mem_list'].add(c_user1.username);
          await channel_store.record(c_name).delete(db3);
          await channel_store.record(c_name).put(db3, po);

          Map pr = await server_store.record(s_name).get(db2) as Map;
          pr = cloneMap(pr); // Create a copy of the map
          pr['chan_list'].add(c_name);
          await server_store.record(s_name).delete(db2);
          await server_store.record(s_name).put(db2, pr);
          print('User added to the channel successfully');
          return;
        }
      }
      //if false => channel does not exist
      //hence creating a new channel and adding the current user as a member to the channel
      Map<String, dynamic> s_map = {
        'server_name': s_name,
        'mem_list': [c_user1.username],
        'type': c_type,
      };

      await channel_store.record(c_name).put(db3, s_map);
      print("Channel added successfully");
    }
  }
}
