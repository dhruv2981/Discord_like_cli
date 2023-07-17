import 'dart:io';
import 'admin.dart';
import 'server.dart';
import 'storage.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/utils/value_utils.dart';


Future<void> channel_message(
    Database db2,
    Database db3,
    Database db4,
    StoreRef<String, Map> server_store,
    StoreRef<String, Map> channel_store, 
    StoreRef<Map, Map> message_store,
    C_user c_user1,
    var server_record,
    var channel_record,
    var message_record
  ) async {
    //Taking inputs of the server and channel in which user wants to message
    stdout.write("In which server do you want to message: ");
    String s_name = stdin.readLineSync() as String;


    server_record =await server_store.find(db2);
    channel_record=await channel_store.find(db3);
    message_record=await message_store.find(db4);


    final String username = c_user1.username;


    //checking validity of server
    Map? pr = await server_store.record(s_name).get(db2) as Map?; // -->the corresponding server to the server name

    //if the channel does not exist
    if(pr == null){
            print("Server does not exist");
            return;
        
        }
    //if the user is not in the channel
    bool flag1 = false;
    for (var user_name in pr['mem_list']) {
        if (user_name == username) {
            flag1 = true;
        }
    }
    if (!flag1) {
        print("The user is not in the given server");
        return;
    }else{//means user is in the server

        stdout.write("In which channel do you want to message: ");
        String c_name = stdin.readLineSync() as String;

        //checking validity of channel
        Map? po = await channel_store.record(c_name).get(db3) as Map?; // -->the corresponding channel to the channel name
        //if the channel does not exist
        if(po == null){
            print("Channel does not exist");
            return;
        }
        //if the user is not in the channel
        bool flag2 = false;
        for (var user_name in po['mem_list']) {
            if (user_name == username && po['server_name'] == s_name) {
                flag2 = true;
            }
        }
        if (!flag2) {
            print("The user is not in the given channel");
            return;
        }else{
            //Assuming that the user is in the selected server and in the selected channel

            // message_record=await message_store.find(db4);
            stdout.write("Enter the message you want to send: ");
            String message = stdin.readLineSync() as String;

            //Making the key and value maps and putting in message store
            Map message_key = {
                'channel_name': c_name,
                'server_name': s_name
            };
            Map message_value = {
                'user' : username,
                'message' : message
            };
            await message_store.record(message_key).put(db4, message_value);
            print("Message sent successfully.");
            
        }
    }
  }

  Future<void> show_channel_message(
    Database db2,
    Database db3,
    Database db4,
    StoreRef<String, Map> server_store,
    StoreRef<String, Map> channel_store, 
    StoreRef<Map, Map> message_store,
    C_user c_user1,
    var server_record,
    var channel_record,
    var message_record,
  ) async {
    //Taking inputs of the server and channel in which user wants to message
    stdout.write("In which server do you want to see all messages: ");
    String s_name = stdin.readLineSync() as String;


    server_record =await server_store.find(db2);
    channel_record=await channel_store.find(db3);
    message_record=await message_store.find(db4);


    final String username = c_user1.username;


    //checking validity of server
    Map? pr = await server_store.record(s_name).get(db2) as Map?; // -->the corresponding server to the server name

    //if the channel does not exist
    if(pr == null){
            print("Server does not exist");
            return;
        
        }
    //if the user is not in the channel
    bool flag1 = false;
    for (var user_name in pr['mem_list']) {
        if (user_name == username) {
            flag1 = true;
        }
    }
    if (!flag1) {
        print("The user is not in the given server");
        return;
    }else{//means user is in the server

        stdout.write("In which channel do you want to see all messages: ");
        String c_name = stdin.readLineSync() as String;

        //checking validity of channel
        Map? po = await channel_store.record(c_name).get(db3) as Map?; // -->the corresponding channel to the channel name
        //if the channel does not exist
        if(po == null){
            print("Channel does not exist");
            return;
        }
        //if the user is not in the channel
        bool flag2 = false;
        for (var user_name in po['mem_list']) {
            if (user_name == username && po['server_name'] == s_name) {
                flag2 = true;
            }
        }
        if (!flag2) {
            print("The user is not in the given channel");
            return;
        }else{
            //Assuming that the user is in the selected server and in the selected channel            
            message_record = await message_store.find(db4);
            for(var rec in message_record){
                print(rec.value);
            }
        }
    }
  }