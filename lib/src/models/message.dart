import 'dart:io';
import 'dart:convert';
import 'storage.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'admin.dart';
import 'package:sembast/utils/value_utils.dart';

class Personal_dm {
  late final sender;
  late final receiver;
  late final msg;
  // Personal_dm(this.receiver);

  personal_dm(Database db5, Database db1, StoreRef<Map, String> p_dm_store,
      StoreRef<String, String> user_store, C_user c_user1) async {
    if (c_user1.username == "0") {
      print("No user has logged in you crazy fool");
      return;
    } else {
      stdout.write("Name of the person whom you want to send msg: ");
      final receiver = stdin.readLineSync();
      this.receiver = receiver;

      //check receiver is a registered user
      var record = await user_store.find(db1);
      bool flag = false;
      for (var rec in record) {
        if (rec.key == receiver) {
          flag = true;
        }
      }
      if (!flag) {
        print("No user with such name exists");
        return;
      }

      this.sender = c_user1.username;
      stdout.write("Message: ");
      this.msg = stdin.readLineSync();

      Map pr = {
        'sender': this.sender,
        'receiver': this.receiver,
      };

      await p_dm_store.record(pr).put(db5, this.msg);
      print("Message sent successfully");
    }
  }

  open_personal_dm(
      Database db5, StoreRef<Map, String> p_dm_store, C_user c_user1) async {
    if (c_user1.username == "0") {
      print("No user has logged in you crazy fool");
      return;
    } else {
      print("Messages");
      print("Sender: Message\n");
      var record = await p_dm_store.find(db5);
      var a = 0;
      for (var rec in record) {
        if (rec.key['receiver'] == c_user1.username) {
          print("${rec.key['sender']}: ${rec.value} ");
          a++;
        }
      }
      if (a == 0) {
        print("Tere ko kisi ne msg nhi kiya");
      }
    }
  }
}
