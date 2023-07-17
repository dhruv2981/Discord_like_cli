import 'dart:io';
import 'admin.dart';
import 'package:sembast/sembast.dart';

show_channels(Database db2, StoreRef<String, Map> server_store, C_user c_user1) async{
    stdout.write("Which server's channels? ");
    String s_name = stdin.readLineSync() as String;
    var server;

    //checking if the user is in the channel
    var server_record =await server_store.find(db2);
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
    for (var chan_name in server['chan_list']){
      print(chan_name);
    }
  }