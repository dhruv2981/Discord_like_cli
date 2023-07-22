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
  late List<Map<String, dynamic>> cat_list;
  // late List<String> chan_list;

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

      Map<String, dynamic> s_map = {
        'chan_list': [],
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

  addCategory(Database db2, StoreRef<String, Map> server_store, C_user c_user1,
      var server_record) async {
    if (c_user1.username == "0") {
      // print("No user has logged in you crazy fool");
      return;
    }
    //some user is logged in
    stdout.write('In which server do you want to add category: ');
    final String s_name = stdin.readLineSync() as String;

    var server_record = await server_store.find(db2);
    for (var rec in server_record) {
      // print(rec.key);
      // print(rec.value);
      // server with such name exists
      if (rec.key == s_name) {
        // print("Passed rec.key: " + rec.key);
        // print(rec.value);

        //means server of such name exist
        //checking if the user is in the server
        for (var member in rec.value['mem_list']) {
          // print("Member: " + member);

          if (member['name'] == c_user1.username &&
              (member['role'] == 'mod' || member['role'] == 'admin')) {
            //means the user is a mod/admin in the given server
            stdout.write('Enter category name: ');
            final String name = stdin.readLineSync() as String;

            //catgory DNE
            if (rec.value['cat_list'].isEmpty) {
              //no category exists
              //creating the category
              // print("No category in server...hence creating category");
              Map<String, dynamic> cat = {'name': name, 'chan_list': []};
              // List<Map<String, dynamic>> cat_list = [];
              // cat_list.add(cat);
              Map<String, dynamic> pr = await server_store
                  .record(s_name)
                  .get(db2) as Map<String, dynamic>;
              pr = cloneMap(
                  pr); // Create a copy of the map //this might not work because of null error
              pr['cat_list'].add(cat);
              await server_store.record(s_name).delete(db2);
              await server_store.record(s_name).put(db2, pr);
              // print('Category created successfully 1');
              return;
            } else {
              //the category list is not empty ....hence looking if the entered category is present
              // print('Category list is not empty');
              // print(rec.value['cat_list']);
              // print(rec.value['cat_list']['name']);
              for (var category in rec.value['cat_list']) {
                if (category['name'] == name) {
                  //category already present
                  print('Category already exists');
                  return;
                }
              }
              //category not present in the list..but some other cateegories are present
              // print(
              //     "category not present in the list..but some other cateegories are present..hence adding category to list ");
              Map<String, dynamic> cat = {'name': name, 'chan_list': []};
              Map pr = await server_store.record(s_name).get(db2)
                  as Map<String, dynamic>;
              pr = cloneMap(pr);
              pr['cat_list'].add(cat);
              await server_store.record(s_name).delete(db2);
              await server_store.record(s_name).put(db2, pr);
              print('Category created successfully 2');
              return;
            }
          } else if (member['name'] == c_user1.username &&
              member['role'] == 'newbie') {
            print('User does not have access rights');
            return;
          }
        }
        //means the user is not in the server
        print("User is not in the server");
        return;
      }
      //means such a server does not exist
      print("Server does not exist");
      return;
    }
  }

  putChanInCat(
      Database db2,
      Database db3,
      StoreRef<String, Map> server_store,
      StoreRef<String, Map> channel_store,
      C_user c_user1,
      var server_record,
      var channel_record) async {
    if (c_user1.username == "0") {
      // print("No user has logged in you crazy fool");
      return;
    }
    //some user is logged in
    stdout.write('In which server do you want to add category: ');
    final String s_name = stdin.readLineSync() as String;

    server_record = await server_store.find(db2);
    for (var rec in server_record) {
      // print(rec.key);
      // print(rec.value);
      // server with such name exists
      if (rec.key == s_name) {
        // print("Passed rec.key: " + rec.key);
        // print(rec.value);

        //means server of such name exist
        //checking if the user is in the server
        for (var member in rec.value['mem_list']) {
          // print("Member: " + member);

          if (member['name'] == c_user1.username &&
              (member['role'] == 'mod' || member['role'] == 'admin')) {
            //means the user is a mod/admin in the given server

            stdout.write('Which channel do you want to move: ');
            String c_name = stdin.readLineSync() as String;
            // print(c_name);
            // print(rec.value['chan_list']);
            for (String channel in rec.value['chan_list']) {
              // print(channel);

              if (channel == c_name) {
                //the indep channel exists
                //asking which channel to put into
                stdout.write(
                    'In which category do you want to write the channel: ');
                String in_cat = stdin.readLineSync() as String;
                for (var cat in rec.value['cat_list']) {
                  if (cat['name'] == in_cat) {
                    //means that the category to put into also exits..putting the indep channel into the category
                    Map<String, dynamic> po = await server_store
                        .record(s_name)
                        .get(db2) as Map<String, dynamic>;
                    po = cloneMap(po);
                    //remove the channel from chan_list
                    po['chan_list'].remove(c_name);
                    //add the channel in the given category's list
                    for (var category in po['cat_list']) {
                      if (category['name'] == in_cat) {
                        category['chan_list'].add(c_name);
                        await server_store.record(s_name).delete(db2);
                        await server_store.record(s_name).put(db2, po);

                        //changes in channel.db
                        channel_record = await channel_store.find(db3);
                        for (var rec in channel_record) {
                          if (rec.key == c_name &&
                              rec.value['server_name'] == s_name) {
                            //this is the channel in the given server
                            //changing its category from null to given category
                            Map po = await channel_store.record(c_name).get(db3) as Map;
                            po = cloneMap(po);
                            po['category_name'] = in_cat;
                            await server_store.record(c_name).delete(db3);
                            await server_store.record(c_name).put(db3, po);
                            print('Channel added to category successfully');
                            return;
                          }
                        }
                      }
                    }
                  }
                }
                print("Category does not exist");
                return;
              }
            }
            print('Given independant channel does not exist');
            return;
          }
        }
        print('User does not have appropriate access rights');
        return;
      }
    }
    print('Server does not exist');
    return;
  }
}
