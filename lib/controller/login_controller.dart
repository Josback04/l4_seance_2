import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> Register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // UNE FOIS QU'ON EST ICI ALORS C'EST UN SUCCÈS

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        return 'MOT DE PASSE COURT';
      } else {
        return 'UNE ERREUR S\'EST PRODUITE "ECHEC" $e';
      }
    }
  }
}
