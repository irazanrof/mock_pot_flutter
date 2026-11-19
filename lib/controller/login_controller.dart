import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool validarEmail(String email) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email.trim());
  }

  bool validarSenha(String senha) => senha.isNotEmpty;

  bool validarLogin(String email, String senha) {
    return validarEmail(email) && validarSenha(senha);
  }

  Future<String?> entrar(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'O endereço de e-mail é inválido.';
        case 'user-disabled':
          return 'Esta conta foi desativada.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'E-mail ou senha incorretos.';
        case 'too-many-requests':
          return 'Muitas tentativas. Aguarde e tente novamente.';
        case 'network-request-failed':
          return 'Falha de conexão. Verifique sua internet.';
        default:
          return e.message ?? 'Não foi possível entrar. Tente novamente.';
      }
    } catch (_) {
      return 'Não foi possível entrar. Verifique sua conexão e tente novamente.';
    }
  }
}
