import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../services/chat/chat_service.dart";
import "../components/my_text_field.dart";

class ChatPage extends StatefulWidget {
  final String recipientUserEmail;
  final String recipientUserID;

  const ChatPage({
    super.key,
    required this.recipientUserEmail,
    required this.recipientUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if(_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.recipientUserID, 
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipientUserEmail)
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessage(
        widget.recipientUserID, 
        _firebaseAuth.currentUser!.uid,
        ),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Text("Server Error ${snapshot.error}");
        }

        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Server Loading...");
        }

        return ListView(
          children: snapshot.data!.docs
            .map<Widget>((document) => _buildMessageItem(document))
            .toList(),
        );
      }
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    var alignment = (data["senderID"] == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data["senderEmail"]),
          Text(data["message"]),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: MyTextField(
            controller: _messageController, 
            hintText: "Enter Message", 
            obscureText: false,
          ),
        ),
        IconButton(
          onPressed: sendMessage, 
          icon: const Icon(
            Icons.arrow_upward_outlined,
            size: 40.0,
          ),
        ),
      ],
    );
  }
}