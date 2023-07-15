import 'dart:io';
import 'dart:convert';
import 'storage.dart';


import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class Admin{

   String username;
   String password;
   Admin(this.username,this.password);
   

  static Future<void> register(Database db, StoreRef<String, String> user_store, StoreRef<String, String> c_user, var records) async {
    stdout.write("Username: ");
    final username = stdin.readLineSync() as String;
    //check if already that user exist
    //if exist throw error
    for (var rec in records){
      if(rec.key==username){
       print("Username already exists. Please choose a different username.");
       return;
       }
      }

    stdout.write("Password :");
    final pass = stdin.readLineSync() as String;
    stdout.write("Confirm Password :");
    final con_pass = stdin.readLineSync() as String;

    if (pass != con_pass) {
      print("Password dont match");
      return;
    }
    // var foundRecord = records.firstWhere((record) => record.key == username, orElse: () => null);  //Error: Undefined name 'records'.

    // if (foundRecord != null) {
    //   print('Key found: ${foundRecord.key}, Value: ${foundRecord.value}');
    //   return;
    // } else {
    //   print('Key not found');
    
      Admin new_user =new Admin(username,pass);
      //Now adding the newly registered user into the the user store
      await user_store.record(new_user.username).put(db, new_user.password);
      // var c_records = await c_user.find(db); 

      // if(c_records == null){
      //   await c_user.record(new_user.username).put(db, new_user.password);
      // }else{
      //   await c_user.record().put(db, new_user.password);
      // }
      print('User registered successfully');
      // print(c_records.key);
      // print(c_records.value);

      // return;
    
  }
    


  static Future<void> login(Database db, StoreRef<String, String> user_store, StoreRef<String, String> c_user, var records) async {
    stdout.write("Username: ");
    final username = stdin.readLineSync();
    final record =await user_store.find(db);
    bool flag = false;
    for(var rec in record){
    if(rec.key == username){
      flag = true;
      } 
    }
    if(!flag){
       print("User is not registered.Please register first");
       return;
    }

    //check user is in record otherwise register

    stdout.write("Password :");
    final pass = stdin.readLineSync();
    print("User Logged in");
    // print(c_user.username);

    //if username correct and password dont match throw error


    //if both coorect login successfully
  }


  logout() {}
}