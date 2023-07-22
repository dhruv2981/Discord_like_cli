import 'dart:io';
import 'package:sembast/sembast.dart';
import 'admin.dart';
import 'storage.dart';

class comm_function {
//for checking user is in server
  Future<bool> user_in_server(String s_name, Database db2,
      StoreRef<String, Map> server_store, C_user c_user1) async {
    var s_record = await server_store.find(db2);
    bool user_in_server = false;
    for (var rec in s_record) {
      if (rec.key == s_name) {
        for (var user in rec.value['mem_list']) {
          if (user['name'] == c_user1.username) {
            user_in_server = true;
          }
        }
      }
    }
    if (!user_in_server) {
      print("\x1B[31mUser is not in this server\x1B[0m");
      return false;
    }
    return true;
    //user is in server
  }

//if the server already exist
  Future<bool> server_already_exist(
      String s_name, Database db2, StoreRef<String, Map> server_store) async {
    var server_record = await server_store.find(db2);
    for (var rec in server_record) {
      if (rec.key == s_name) {
        print(
            "\x1B[31mServer already exists. Please choose a different servername.\x1B[0m");
        return true;
      }
    }
    return false;
  }

  Future<bool> no_any_server_exist(
      String s_name, Database db2, StoreRef<String, Map> server_store) async {
    bool flag = false;
    var server_record = await server_store.find(db2);
    for (var rec in server_record) {
      if (rec.key == s_name) {
        flag = true;
      }
    }
    if (!flag) {
      print("\x1B[31mNo server with such name exists\x1B[0m");
      return true;
    }
    return false;
  }

  Future<bool> cat_exist_in_server(String cat_name, String s_name, Database db2,
      StoreRef<String, Map> server_store) async {
    bool cat_exist = false;

    Map rec = await server_store.record(s_name).get(db2) as Map;
    for (var r in rec['cat_list']) {
      if (r['name'] == cat_name) {
        cat_exist = true;
        break;
      }
    }
    if (!cat_exist) {
      print("\x1B[31mCategory dont exist in server\x1B[0m");
      return false;
    }
    return true;
  }

  Future<bool> user_logged_in(C_user c_user1) async {
    if (c_user1.username == "0") {
      print("\x1B[31mNo user has logged in you crazy fool\x1B[0m");
      return true;
    }
    return false;
  }

  Future<bool> is_registered(String receiver, Database db1,
      StoreRef<String, String> user_store, C_user c_user1) async {
    var record = await user_store.find(db1);
    bool flag = false;
    for (var rec in record) {
      if (rec.key == receiver) {
        flag = true;
      }
    }
    if (!flag) {
      return false;
    }

    return true;
  }
}
