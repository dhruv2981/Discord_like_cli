import 'dart:io';
import 'package:sembast/sembast.dart';
import 'package:crypt/crypt.dart';
import 'common_function.dart';

class C_user {
  String username;
  String password;
  C_user(this.username, this.password);

  print_c_user(C_user c_user1) {
    if (c_user1.username == "0") {
      print("\x1B[31mNo user has logged in you crazy fool\x1B[0m");
      return;
    }
    print(this.username);
  }
}

class Admin extends comm_function {
  late String username;
  late String password;
  Admin(this.username, this.password);
  Admin.fun();

  static String hashPwd(String pass) {
    return Crypt.sha256(pass, rounds: 1000).toString();
  }

  static bool comparePwd(String passvalue, String hash_pwd) {
    final hashedPwd = Crypt(hash_pwd);
    return hashedPwd.match(passvalue);
  }

  Future<void> register(
      Database db1, StoreRef<String, String> user_store, C_user c_user1) async {
    if (c_user1.username != "0") {
      print("\x1B[31mPlease logout first\x1B[0m");
      return;
    }
    stdout.write("Username: ");
    final username = stdin.readLineSync() as String;
    //check if already that user exist and if exist throw error

    var record = await user_store.find(db1);
    for (var rec in record) {
      if (rec.key == username) {
        print(
            "\x1B[31mUsername already exists. Please choose a different username.\x1B[0m");
        return;
      }
    }

    stdout.write("Password :");
    stdin.echoMode = false;
    // var pass = stdin.readLineSync().toString();

    var pass = stdin.readLineSync() as String;
    stdin.echoMode = true;
    print('');
    stdout.write("Confirm Password :");
    stdin.echoMode = false;
    var con_pass = stdin.readLineSync() as String;
    stdin.echoMode = true;
    print('');

    if (pass != con_pass) {
      print("\x1B[31mPassword dont match\x1B[0m");
      return;
    }
    pass = hashPwd(pass);

    Admin new_user = new Admin(username, pass);
    await user_store.record(new_user.username).put(db1, new_user.password);
    c_user1.username = username;
    c_user1.password = pass;

    print('\x1B[32mUser registered successfully\x1B[0m');
    String coloreduser = '\x1B[32m$username\x1B[0m';
    print("\x1B[32mThe logged in user is: " + coloreduser);
  }

  Future<void> login(
      Database db1, StoreRef<String, String> user_store, C_user c_user1) async {
    if (c_user1.username != "0") {
      print("\x1B[31mPlease logout first\x1B[0m");
      return;
    }
   
    stdout.write("Username: ");
    final username = stdin.readLineSync();

    if (username == null) {
      return;
    }

    //check user is in record otherwise register
    if (!(await super.is_registered(username, db1, user_store, c_user1))) {
      print("\x1B[31mUser is not registered.Please register first\x1B[0m");
    }

    //if username correct and password dont match throw error  and if both coorect login successfully
    var actual_pwd = await user_store.record(username).get(db1);

    if (actual_pwd == null) {
      return;
    }
    stdout.write("Password :");
    stdin.echoMode = false;
    final pass = stdin.readLineSync();
    stdin.echoMode = true;
    print('');
    if (pass == null) {
      return;
    } else if (comparePwd(pass, actual_pwd)) {
      c_user1.username = username;
      c_user1.password = pass;
      print("\x1B[32mUser Logged in\x1B[0m");

      String coloreduser = '\x1B[32m$username \x1B[0m';
      print("\x1B[32mThe logged in user is: " + coloreduser);
    } else {
      print("\x1B[31mIncorrect password entered. Please try again\x1B[0m");
      return;
    }
  }

  logout(C_user c_user1) {
    if (c_user1.username == "0") {
      print("\x1B[31mNo user has logged in you crazy fool\x1B[0m");
      return;
    } else {
      c_user1.username = "0";
      c_user1.password = "0";
      print("\x1B[32muser successfully logged out\x1B[0m");
      return;
    }
  }
}
