import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProviderr extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //  États
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  //  Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Actions
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _user = cred.user;
// sauvegarde de la clé dans SharedPrefs, avec notre clé "is_logged_in" bool
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_logged_in", true);

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

  Future<void> logout() async {
    await _auth.signOut();

    _user = null;
// suppression de la clé dans SharedPrefs
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("is_logged_in");

    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn) {
      // Si SharedPrefs dit oui, on vérifie encore si  Firebase a toujours l'user en cache
      _user = _auth.currentUser;
      if (_user != null) {
        return true;
      }
    }
    return false;
  }
}
