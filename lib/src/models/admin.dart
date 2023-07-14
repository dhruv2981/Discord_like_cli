import 'dart:io';
import 'dart:convert';
import 'storage.dart';

import 'package:sembast/sembast.dart';
 import 'package:sembast/sembast_io.dart';

class Admin {

   late String username;
   late String password;
   Admin(this.username,this.password);
   


  static initial() {
    stdout.write('Register or Login (r/l) ');
    final input = stdin.readLineSync();

    switch (input) {
      case 'r':
        register();
        break;
      case 'l':
        login();
        break;
      default:
        print('Invalid Input');
    }
  }



  static register() {
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
    }
    Admin user =Admin(username,pass);
    var json_user=jsonEncode(user);
    store1.record(username).put(db, json_user);
    print('User registered successfully');

    




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
