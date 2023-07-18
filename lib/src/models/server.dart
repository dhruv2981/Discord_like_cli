import 'dart:io';
import 'package:sembast/sembast.dart';
import 'admin.dart';
import 'package:sembast/utils/value_utils.dart';

class Server {
  late String name;
  late List<String> chan_list;
  late List<String> mem_list;
  // List<String> moderator;
  
  

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
      var server_record = await server_store.find(db2);
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
      //if the user is already in the server
      bool user_in_server = false;
      for (var user in pr['mem_list']) {
        if (user == c_user1.username) {
          user_in_server = true;
        }
      }
      if (user_in_server) {
        print("The user is already in the given server");
        return;
      } else {
        //the user is not in the server, hence adding it
        pr = cloneMap(pr); // Create a copy of the map
        pr['mem_list'].add(c_user1.username);
        await server_store.record(s_name).delete(db2);
        await server_store.record(s_name).put(db2, pr);
        print("User successfully added to the server");
      }
    }
  }
}


