import 'dart:io';
import 'dart:convert';
import 'storage.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'admin.dart';
import 'package:sembast/utils/value_utils.dart';

class Server {
  late String name;
  late List<String> chan_list;
  late List<String> mem_list;
  // List<String> moderator;
  Server(this.name, this.chan_list, this.mem_list);
  Server.constructor();

  create_server(Database db2, StoreRef<String, Map> server_store,
      C_user c_user1, var server_record) async {
    if (c_user1.username == "0") {
      print("No user has logged in you crazy fool");
      return;
    } else {
      //if server already exist

      //user has given create server
      stdout.write("Name of the server: ");
      final s_name = stdin.readLineSync() as String;
      this.name = s_name;
      for (var rec in server_record) {
        if (rec.key == s_name) {
          print("Server already exists. Please choose a different servername.");
          return;
        }
      }
      Map<String, List<String>> s_map = {
        'chan_list': [],
        'mem_list': [c_user1.username],
      };
      this.chan_list = s_map['chan_list'] as List<String>;
      this.mem_list = s_map['mem_list'] as List<String>;
      await server_store.record(s_name).put(db2, s_map);
      print("Server created successfully");
    }
  }

  join_server(Database db2, StoreRef<String, Map> server_store, C_user c_user1,
      var server_record) async {
    if (c_user1.username == "0") {
      print("No user has logged in you crazy fool");
      return;
    } else {
      var server_record = await server_store.find(db2);
      stdout.write("Name of the server: ");
      final s_name = stdin.readLineSync() as String;
      this.name = s_name;
      bool flag = false;
      for (var rec in server_record) {
        if (rec.key == s_name) {
          flag = true;
        }
      }
      if (!flag) {
        print("No server with such name exists");
        return;
      }
      Map pr = await server_store.record(s_name).get(db2) as Map;
      pr = cloneMap(pr); // Create a copy of the map
      pr['mem_list'].add(c_user1.username);
      print("error");
      await server_store.record(s_name).delete(db2);
      await server_store.record(s_name).put(db2,pr);
      //do we need to check the user has already not joined channel
    }
  }
}

class Channel {
  late String name;
  late String type;
  late String server;
  late List<String> mem_list;
  Channel.constructor();
  Channel(this.name, this.type, this.server, this.mem_list);

  add_channel(
      Database db2,
      Database db3,
      StoreRef<String, Map> channel_store,
      StoreRef<String, Map> server_store,
      C_user c_user1,
      var channel_record,
      var server_record) async {
    if (c_user1.username == "0") {
      print("No user has logged in you crazy fool");
      return;
    } else {
      stdout.write("Server in which u want to add channel: ");
      final s_name = stdin.readLineSync() as String;
      bool flag = false;
      //keep care of record these are of time when connection function was called
      var s_record = await server_store.find(db2);
      for (var rec in s_record) {
        if (rec.key == s_name) {
          flag = true;
        }
      }
      if (!flag) {
        print("No server with such name exists");
        return;
      }

      stdout.write("Channel Name: ");
      final c_name = stdin.readLineSync() as String;
      this.name = c_name;

      stdout.write("Channel Type: ");
      final c_type = stdin.readLineSync();
      //ctype must be of particular types only
      var a = 0;
      for (var rec in channel_record) {
        if (rec.key == c_name) {
          print(
              "Channel already exists. Please choose a different channelname.");
          a++;
          break;
        }
      }
      if (a == 0) {
        Map<String, dynamic> s_map = {
          'server_name': s_name,
          'mem_list': [c_user1.username],
          'type': c_type,
        };

        this.server = s_map['server_name'] as String;
        this.type = s_map['type'] as String;
        this.mem_list = s_map['mem_list'] as List<String>;
        await channel_store.record(c_name).put(db3, s_map);
      } else {
        Map po = await channel_store.record(c_name).get(db3) as Map;
        po['mem_list'].add(c_name);
        await channel_store.record(c_name).delete(db3);
        await channel_store.record(c_name).put(db3, po);
      }

      //updated server file record
      Map pr = await server_store.record(s_name).get(db2) as Map;
      pr = cloneMap(pr); // Create a copy of the map
      pr['chan_list'].add(c_name);
      await server_store.record(s_name).delete(db2);
      await server_store.record(s_name).put(db2, pr);
      //update not working

      print("Channel added successfully");
    }
  }
}
