import 'dart:io';
import 'package:sembast/sembast.dart';
import 'admin.dart';
import 'package:sembast/utils/value_utils.dart';

enum RoleType { admin, mod, newbie }

class Server {
  late String name;
  late List<Map<String, dynamic>> mem_list;
  late RoleType role;
  late List<dynamic> cat_list;
  late List<String> chan_list;

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

      stdout.write("Type password with which users can access mod role: ");
      final String s_pwd = stdin.readLineSync() as String;
      Map user_role = {
        'name': c_user1.username,
        'role': "admin",
      };

      List<Map> role_list = [user_role];

      Map<String, dynamic> s_map = {
        'cat_list': [],
        'mem_list': role_list,
        's_pwd': Admin.hashPwd(s_pwd),
      };

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
