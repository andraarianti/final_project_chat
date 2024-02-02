//chat.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/widgets/chat_message.dart';
import 'package:firebase_project/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        actions: [
          IconButton(onPressed: _handleLogout, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: const Column(
        children: const [
          Expanded(
              child: ChatMessages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}