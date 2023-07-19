import 'dart:io';
import 'package:sembast/sembast.dart';
import 'dart:convert';
import 'package:crypt/crypt.dart';

class C_user {
  String username;
  String password;
  C_user(this.username, this.password);

  print_c_user(C_user c_user1) {
    if (c_user1.username == "0") {
      print("No user has logged in you crazy fool");
      return;
    }
    print(this.username);
  }
}

class Admin {
  String username;
  String password;
  Admin(this.username, this.password);

  static String hashPwd(String pass) {
    return Crypt.sha256(pass, rounds: 1000).toString();
  }

  static bool comparePwd(String passvalue,String hash_pwd) {
    final hashedPwd = Crypt(hash_pwd);
    return hashedPwd.match(passvalue);
  }

  static Future<void> register(Database db1,
      StoreRef<String, String> user_store, var records, C_user c_user1) async {
    stdout.write("Username: ");
    final username = stdin.readLineSync() as String;
    //check if already that user exist
    //if exist throw error
    var record = await user_store.find(db1);
    for (var rec in record) {
      if (rec.key == username) {
        print("Username already exists. Please choose a different username.");
        return;
      }
    }

    stdout.write("Password :");
    var pass = stdin.readLineSync() as String;
    stdout.write("Confirm Password :");
    var con_pass = stdin.readLineSync() as String;

    if (pass != con_pass) {
      print("Password dont match");
      return;
    }
    pass = hashPwd(pass);

    Admin new_user = new Admin(username, pass);
    //Now adding the newly registered user into the the user store
    await user_store.record(new_user.username).put(db1, new_user.password);
    c_user1.username = username;
    c_user1.password = pass;

    print('User registered successfully');
    print("The logged in user is: " + c_user1.username);
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
    } else if (comparePwd(pass, actual_pwd)) {
      c_user1.username = username;
      c_user1.password = pass;
      print("User Logged in");
      print("The logged in user is: " + c_user1.username);
    } else {
      print("Incorrect password entered. Please try again");
      return;
    }
  }

  static logout(C_user c_user1) {
    if (c_user1.username == "0") {
      print("No user has logged in you crazy fool");
      return;
    } else {
      c_user1.username = "0";
      c_user1.password = "0";
      print("user successfully logged out");
      return;
    }
  }
}
