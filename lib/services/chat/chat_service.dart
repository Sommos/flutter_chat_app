import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../../model/message.dart";

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String recipientUserID, String message) async {
    final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final String currentUserEmail = FirebaseAuth.instance.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      recipientID: recipientUserID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserID, recipientUserID];
    ids.sort();
    String chatRoomID = ids.join("_");

    await _firebaseFirestore
      .collection("chat_rooms")
      .doc(chatRoomID)
      .collection("messages")
      .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String userID, String recipientID) {
    List<String> ids = [userID, recipientID];
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firebaseFirestore
      .collection("chat_rooms")
      .doc(chatRoomID)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .snapshots();
  }
}