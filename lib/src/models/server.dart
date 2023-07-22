import 'dart:io';
import 'package:bot/src/models/common_function.dart';
import 'package:sembast/sembast.dart';
import 'admin.dart';
import 'package:sembast/utils/value_utils.dart';
// import 'common_function.dart';

enum RoleType { admin, mod, newbie }

class Server extends comm_function {
  late String name;
  late List<Map<String, dynamic>> mem_list;
  late RoleType role;
  late List<dynamic> cat_list;
  late List<String> chan_list;

  // List<String> moderator;

  create_server(Database db2, StoreRef<String, Map> server_store,
      C_user c_user1, var server_record) async {
    if (await super.user_logged_in(c_user1)) {
      return;
    } else {
      //if server already exist

      //user has given create server
      stdout.write("Name of the server: ");
      final s_name = stdin.readLineSync() as String;
      this.name = s_name;

      if (await super.server_already_exist(s_name, db2, server_store)) {
        return;
      }
      stdout.write("Type password with which users can access mod role: ");
      final String s_pwd = stdin.readLineSync() as String;
      Map user_role = {
        'name': c_user1.username,
        'role': "admin",
      };

      List<Map> role_list = [user_role];
      List<Map> chan_cat_list = [];

      Map<String, dynamic> s_map = {
        'chan_list': [],
        'cat_list': chan_cat_list,
        'mem_list': role_list,
        's_pwd': Admin.hashPwd(s_pwd),
      };

      await server_store.record(s_name).put(db2, s_map);
      print("Server created successfully");
    }
  }

  join_server(Database db2, StoreRef<String, Map> server_store, C_user c_user1,
      var server_record) async {
   if (await super.user_logged_in(c_user1)) {
      return;
    } else {
      
      stdout.write("Name of the server: ");
      final s_name = stdin.readLineSync() as String;
      this.name = s_name;

       if (await super.no_any_server_exist(s_name, db2, server_store)) {
        return;
      }
     
     

      Map<String, dynamic> pr =
          await server_store.record(s_name).get(db2) as Map<String, dynamic>;
      //if the user is already in the server
      // if (pr['mem_list'][] == null) {
      //   return;
      // }
      List b = pr['mem_list'];
      for (var use in b) {
        if (use['name'] == c_user1.username) {
          print("The user is already in the given server");
          return;
        }
      }
      //the user is not in the server, hence adding it
      stdout.write("Role [mod/newbie]: ");
      final role_type = stdin.readLineSync() as String;
      var user_role;
      switch (role_type) {
        case 'mod':
          stdout.write("Enter password for mod access: ");
          String s_pass = stdin.readLineSync() as String;
          // s_pass = Admin.hashPwd(s_pass);

          if (Admin.comparePwd(s_pass, pr['s_pwd'])) {
            user_role = RoleType.mod;
            break;
          } else {
            print("Invalid password ");
            return;
          }

        case 'newbie':
          user_role = RoleType.newbie;

          break;
        default:
          print("Please enter a valid role");
          return;
      }
      Map aa = {
        'name': c_user1.username,
        'role': role_type,
      };
      pr = cloneMap(pr); // Create a copy of the map
      pr['mem_list'].add(aa);
      await server_store.record(s_name).delete(db2);
      await server_store.record(s_name).put(db2, pr);
      print("User successfully added to the server");
    }
    //do we need to check the user has already not joined channel
  }
}
