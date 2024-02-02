//main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/provider/provider.dart';
import 'package:firebase_project/screen/auth.dart';
import 'package:firebase_project/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => ChatProvider(),
    child: App(),
  ));
  // runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // var app = Provider.of<App>(context);

    return ChangeNotifierProvider<ChatProvider>(
        create: (context) => ChatProvider(),
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) => MaterialApp(
            title: 'Chat App Firebase',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home:
                Consumer<ChatProvider>(builder: (context, chatProvider, child) {
              if (chatProvider.user != null) {
                return ChatScreen();
              } else {
                return AuthScreen();
              }
            }),
          ),
        ));
  }
}
