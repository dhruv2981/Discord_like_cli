import 'dart:io';
import 'package:sembast/sembast.dart';
import 'admin.dart';
import 'common_function.dart';

//done
class Personal_dm extends comm_function {
  late final sender;
  late final receiver;
  late final msg;

  personal_dm(Database db5, Database db1, StoreRef<Map, String> p_dm_store,
      StoreRef<String, String> user_store, C_user c_user1) async {
    if (await super.user_logged_in(c_user1)) {
      return;
    } else {
      stdout.write("Name of the person whom you want to send msg: ");
      receiver = stdin.readLineSync();

      //check receiver is a registered user
      if (!(await super
          .is_registered(receiver, db1, user_store, c_user1))) {
        print("\x1B[31mNo user with such name exists\x1B[0m");
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
      print("\x1B[32mMessage sent successfully\x1B[0m");
    }
  }

  open_personal_dm(
      Database db5, StoreRef<Map, String> p_dm_store, C_user c_user1) async {
    if (await super.user_logged_in(c_user1)) {
      return;
    } else {
      print("Messages");
      print("Sender: Message");
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
