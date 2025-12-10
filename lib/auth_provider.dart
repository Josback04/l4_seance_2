import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //  États
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  //  Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuth => _user != null; // Raccourci pratique

  // Actions
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _user = cred.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
