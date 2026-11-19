import 'package:firebase_auth/firebase_auth.dart';

class RecuperarSenhaController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool validarEmail(String email) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email.trim());
  }

  Future<String?> recuperarSenha(String email) async {
    final emailNormalizado = email.trim().toLowerCase();

    if (!validarEmail(emailNormalizado)) {
      return 'Informe um endereço de e-mail válido.';
    }

    try {
      await _auth.sendPasswordResetEmail(email: emailNormalizado);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Não encontramos uma conta cadastrada com esse e-mail.';
        case 'invalid-email':
          return 'O endereço de e-mail é inválido.';
        case 'too-many-requests':
          return 'Muitas tentativas. Aguarde antes de solicitar outro e-mail.';
        case 'network-request-failed':
          return 'Falha de conexão. Verifique sua internet e tente novamente.';
        default:
          return e.message ?? 'Não foi possível enviar o e-mail de recuperação.';
      }
    } catch (_) {
      return 'Não foi possível enviar o e-mail de recuperação. Tente novamente.';
    }
  }
}
