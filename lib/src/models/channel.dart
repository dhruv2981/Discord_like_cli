import 'dart:io';
import 'package:bot/src/models/common_function.dart';
import 'package:sembast/sembast.dart';
import 'admin.dart';
import 'package:sembast/utils/value_utils.dart';

enum ChannelType { text, voice, stage, rules, announcement }

class Channel extends comm_function{
  late String name;
  late ChannelType type;
  late String server;
  late List<String> mem_list;
  late String category;

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
    if (await super.user_logged_in(c_user1)) {
      return;
    } else {
      stdout.write("Server in which u want to add channel: ");
      final s_name = stdin.readLineSync() as String;

      //keep care of record these are of time when connection function was called
      var s_record = await server_store.find(db2);

      //checking if such a sever exist and if the user is in that server
      bool user_in_server = false;
      bool server_exist = false;
      for (var rec in s_record) {
        if (rec.key == s_name) {
          server_exist = true;
          for (var user in rec.value['mem_list']) {
            if (user['name'] == c_user1.username) {
              user_in_server = true;
            }
          }
        }
      }
      //if user not in this server or if the server does not exist
      if (!server_exist) {
        print("Server with this name does not exist");
        return;
      }
      if (!user_in_server) {
        print("User is not in this server");
        return;
      }
      //user is in such a server
      var cat_name;
      stdout.write(
          'Add channel in category or as direct channel in server[c/s]: ');
      final input = stdin.readLineSync();
      switch (input) {
        case "c":
          stdout.write('Category in which u want to add channel: ');
          cat_name = stdin.readLineSync();
          break;
        case "s":
          break;
        default:
          print("Inavlid Input");
          return;
      }
      //check that category exist in server
      bool cat_exist = false;
      if (input == "c") {
        Map rec = await server_store.record(s_name).get(db2) as Map;

        for (var r in rec['cat_list']) {
          if (r['name'] == cat_name) {
            cat_exist = true;
            break;
          }
        }
        if (!cat_exist) {
          print("Category dont exist");
          return;
        }
      }

      stdout.write("Channel Name: ");
      final c_name = stdin.readLineSync() as String;
      this.name = c_name;

      var c_record1 = await channel_store.find(db3);
      if (input == "c") {
        for (var a in c_record1) {
          if (a.key == c_name &&
              a.value['server_name'] == s_name &&
              a.value['cat_name'] == null) {
            print("This name is taken by any direct channel in server");
            return;
          }
        }
      }
      if (input == "s") {
        for (var a in c_record1) {
          if (a.key == c_name &&
              a.value['server_name'] == s_name &&
              a.value['cat_name'] != null) {
            print("This name is taken by any  channel in some category");
            return;
          }
        }
      }

//   checking if category is in server and checking channel is in category typed

      //checking if such a channel exists
      var c_record = await server_store.find(db3);
      for (var rec in c_record) {
        //checking if this is the channel of the correct type and in the correct server  (shannel name making unique in a server)
        if (rec.key == c_name && rec.value['server_name'] == s_name) {
          //hence checking if the current user is already in the channel
          for (var user in rec.value['mem_list']) {
            if (user == c_user1.username) {
              print("User is already in the channel");
              return;
            }
          }

//for adding a user in existing channel in channel.db
          Map po = await channel_store.record(c_name).get(db3) as Map;
          po = cloneMap(po); //Create a copy of the map
          po['mem_list'].add(c_user1.username);
          await channel_store.record(c_name).delete(db3);
          await channel_store.record(c_name).put(db3, po);
          print("Channel added successfully");
          return;
        }
      }
      //if false => channel does not exist
      //hence creating a new channel and adding the current user as a member to the channel

      stdout.write("Channel Type:[text/voice/stage/announcement/rules]: ");
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
        case 'rules':
          this.type = ChannelType.rules;
        case 'announcement':
          this.type = ChannelType.announcement;
        default:
          print("Invalid input");
          return;
      }
      var c_user_role;
      Map s_record1 = await server_store.record(s_name).get(db2) as Map;
      for (var a in s_record1['mem_list']) {
        if (a['name'] == c_user1.username) {
          c_user_role = a['role'];
        }
      }
      if (c_user_role == "newbie") {
        print("Only admin and mod users can create new channel");
        return;
      }

      Map<String, dynamic> s_map = {
        'server_name': s_name,
        'category_name': cat_name,
        'mem_list': [c_user1.username],
        'type': c_type,
      };
      await channel_store.record(c_name).put(db3, s_map);

      //for adding channel in server.db if category is null
      if (input == "s") {
        Map pr = await server_store.record(s_name).get(db2) as Map;
        pr = cloneMap(pr); // Create a copy of the map
        pr['chan_list'].add(c_name);
        await server_store.record(s_name).delete(db2);
        await server_store.record(s_name).put(db2, pr);
        print('User added to the channel successfully');
      }

// adding channel in category in server.db if category is not null
      if (input == "c") {
        Map aa = await server_store.record(s_name).get(db2) as Map;

        aa = cloneMap(aa);
        for (var a in aa['cat_list']) {
          if (a['name'] == cat_name) {
            a['chan_list'].add(c_name);
            break;
          }
        }
        await server_store.record(s_name).delete(db2);
        await server_store.record(s_name).put(db2, aa);
      }
    }
    print("Channel added successfully");
  }
}

//check channel is in category