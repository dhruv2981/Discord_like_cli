import 'dart:io';
import 'admin.dart';
import 'package:sembast/sembast.dart';

show_channels(
    Database db2, StoreRef<String, Map> server_store, C_user c_user1) async {
  stdout.write("Which server's channels? ");
  String s_name = stdin.readLineSync() as String;
  var server;

  //checking if the user is in the channel
  var server_record = await server_store.find(db2);
  bool flag = false;
  for (var rec in server_record) {
    if (rec.key == s_name) {
      flag = true;
      server = rec.value;
    }
  }
  if (!flag) {
    print("The user is not in the given channel");
    return;
  }

  //Assuming that the user is in the server
  print("Channels in the server are: ");
  if (server['chan_list'] == []) {
    print("No channel added");
    return;
  }
  for (var chan_name in server['chan_list']) {
    print(chan_name);
  }
}

// Method to print mod users in a server
Future<void> printModUsers(
    Database db2, StoreRef<String, Map> server_store, C_user c_user1) async {
  stdout.write("Enter the server name: ");
  final s_name = stdin.readLineSync() as String;

  //user has logged in
  if (c_user1.username == "0") {
    print("No user has logged in you crazy fool");
    return;
  } else {
    //check server exist
    bool flag = false;
    var server_record = await server_store.find(db2);
    for (var rec in server_record) {
      if (rec.key == s_name) {
        flag = true;
      }
    }
    if (!flag) {
      print("No server with such name exists");
      return;
    }

    Map po = await server_store.record(s_name).get(db2) as Map;
    for (var rec in po['mem_list']) {
      if (rec['role'] == "mod") {
        print("-" + rec['name']);
      }
    }
  }
}

show_server_structure(
    Database db2, StoreRef<String, Map> server_store, C_user c_user1) async {
  stdout.write('Show structure of which server: ');
  String s_name = stdin.readLineSync() as String;
  var server_record = await server_store.find(db2);

  for (var rec in server_record) {
    if (rec.key == s_name) {
      //such a server exists
      //hence printing the server
      print("Server name: " + rec.key);
      Map pr = await server_store.record(s_name).get(db2) as Map;
      print("Members in channel: ");
      // print(pr['mem_list']);
      for (Map member in pr['mem_list']) {
        print(member['name']);
      }
      print('Categories in channel: ');
      for (var category in pr['cat_list']) {
        print('Category name: ' + category['name']);
        print('Channels: ');
        for (String channel in category['chan_list']) {
          print(channel);
        }
        // stdout.write(object)
      }
      print("Independant channels: ");
      for (String channel in pr['chan_list']) {
        print(channel);
      }
      return;
    }
    print("Server does not exist");
    return;
  }
}

demoteUser(Database db2, Database db3, StoreRef<String, Map> server_store,
    StoreRef<String, Map> channel_store, C_user c_user1) {
  //user has logged in
  if (c_user1.username == "0") {
    print("No user has logged in you crazy fool");
    return;
  }
  
}
