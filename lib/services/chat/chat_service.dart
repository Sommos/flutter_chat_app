import "package:flutter/material.dart";

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String recipientUserID, String message) async {
    try {
      _firebaseFirestore.collection("users").doc(recipientUserID).collection("messages").add({
        "message": message,
        "sender": FirebaseAuth.instance.currentUser!.uid,
        "timestamp": DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }
}