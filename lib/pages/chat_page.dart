import "package:flutter/material.dart";

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipientUserEmail)
      ),
    );
  }
}