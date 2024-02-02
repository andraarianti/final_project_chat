import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late StreamSubscription<User?> _authStateSubscription;
  late Stream<User?> _authUserStream;
  late User? _user;

  bool _isLoggedin = false;
  bool _isAuth = false;
  bool get isAuth => _isAuth;

  void setAuth(bool value) {
    _isAuth = value;
    notifyListeners();
  }

  ChatProvider() {
    _authUserStream = _auth.authStateChanges();
    _authStateSubscription = _authUserStream.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  void signOut() async {
    try {
      await _auth.signOut();
      _isLoggedin = false;
      _isAuth = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }
}
