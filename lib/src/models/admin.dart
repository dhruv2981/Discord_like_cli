import 'dart:io';
import 'dart:convert';
import 'storage.dart';


import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';


class Admin{

   String username;
   String password;
   Admin(this.username,this.password);
   

  static void register(Database db, StoreRef<String, String> user_store) async {
    stdout.write("Username: ");
    final username = stdin.readLineSync() as String;
    //check if already that user exist
    //if exist throw error

    stdout.write("Password :");
    final pass = stdin.readLineSync() as String;
    stdout.write("Confirm Password :");
    final con_pass = stdin.readLineSync() as String;

    if (pass != con_pass) {
      print("Password dont match");
      return;
    } else{
      print(pass);
    Admin new_user =new Admin(username,pass);
    //Now adding the newly registered user into the the user store
    await user_store.record(new_user.username).put(db, new_user.password);
    print('User registered successfully');
    }


  }


  static login() {
    stdout.write("Username: ");
    final username = stdin.readLineSync();

    //check user is in record otherwise register

    stdout.write("Password :");
    final pass = stdin.readLineSync();

    //if username correct and password dont match throw error

    //if both coorect login successfully
  }


  logout() {}
}