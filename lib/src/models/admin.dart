import 'dart:io';
import 'dart:convert';
import 'storage.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class C_user {
  String username;
  String password;
  C_user(this.username, this.password);
}

class Admin {
  String username;
  String password;
  Admin(this.username, this.password);

  static Future<void> register(Database db1, StoreRef<String, String> user_store,
       var records, C_user c_user1) async {
    stdout.write("Username: ");
    final username = stdin.readLineSync() as String;
    //check if already that user exist
    //if exist throw error
    var record=await user_store.find(db1);
    for (var rec in records) {
      if (rec.key == username) {
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

    Admin new_user = new Admin(username, pass);
    //Now adding the newly registered user into the the user store
    await user_store.record(new_user.username).put(db1, new_user.password);
    c_user1.username = username;
    c_user1.password = pass;
    // var c_records = await c_user.find(db1);

    // if(c_records == null){
    //   await c_user.record(new_user.username).put(db1, new_user.password);
    // }else{
    //   await c_user.record().put(db1, new_user.password);
    // }
    print('User registered successfully');
    print("The logged in user is: " + c_user1.username);
    // print(c_records.key);
    // print(c_records.value);

    // return;
  }

  static Future<void> login(Database db1, StoreRef<String, String> user_store,
       var records, C_user c_user1) async {
    stdout.write("Username: ");
    final username = stdin.readLineSync();
    final record = await user_store.find(db1);
    if (username == null) {
      return;
    }
    
    //check user is in record otherwise register
    bool flag = false;
    for (var rec in record) {
      if (rec.key == username) {
        flag = true;
      }
    }
    if (!flag) {
      print("User is not registered.Please register first");
      return;
    }

    //if username correct and password dont match throw error
    //if both coorect login successfully

    var actual_pwd = await user_store.record(username).get(db1);
    if (actual_pwd == null) {
      return;
    }

    stdout.write("Password :");
    final pass = stdin.readLineSync();
    if (pass == null) {
      return;
    } else if (pass == actual_pwd) {
      c_user1.username = username;
      c_user1.password = pass;
      print("User Logged in");
      print("The logged in user is: " + c_user1.username);
    } else {
      print("Incorrect password entered. Please try again");
      return;
    }

    // print(c_user.username);
  }

  logout(C_user c_user1) {
    //still need a way to detect that the logout function needs to be implemeted(uske liye command line function banana padega...but this must work...so i wasnt able to test it)
    if (c_user1.username == "0") {
      print("No user has logged in you crazy fool");
      return;
    } else {
      c_user1.username = "0";
      c_user1.password = "0";
      print("user successfully logged out");
    }
  }
}
