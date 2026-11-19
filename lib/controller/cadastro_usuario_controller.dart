import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CadastroUsuarioController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool validarNome(String nome) => nome.trim().length >= 3;

  bool validarEmail(String email) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email.trim());
  }

  bool validarSenha(String senha) => senha.length >= 6;

  bool senhasConferem(String senha, String confirmarSenha) {
    return senha == confirmarSenha;
  }

  bool validarCadastro({
    required String nome,
    required String email,
    required String senha,
    required String confirmarSenha,
  }) {
    return validarNome(nome) &&
        validarEmail(email) &&
        validarSenha(senha) &&
        senhasConferem(senha, confirmarSenha);
  }

  Future<String?> cadastrar({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    UserCredential? credencial;

    try {
      final emailNormalizado = email.trim().toLowerCase();
      credencial = await _auth.createUserWithEmailAndPassword(
        email: emailNormalizado,
        password: senha,
      );

      final usuario = credencial.user;
      if (usuario == null) {
        return 'Não foi possível criar a conta. Tente novamente.';
      }

      await usuario.updateDisplayName(nome.trim());
      await _db.collection('usuarios').doc(usuario.uid).set({
        'uid': usuario.uid,
        'nome': nome.trim(),
        'email': emailNormalizado,
        'telefone': telefone.trim(),
        'criadoEm': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Este e-mail já está cadastrado.';
        case 'invalid-email':
          return 'O endereço de e-mail é inválido.';
        case 'weak-password':
          return 'A senha é fraca. Utilize pelo menos 6 caracteres.';
        case 'operation-not-allowed':
          return 'O cadastro por e-mail e senha não está ativado no Firebase.';
        case 'network-request-failed':
          return 'Falha de conexão. Verifique sua internet.';
        default:
          return e.message ?? 'Não foi possível concluir o cadastro.';
      }
    } catch (_) {
      try {
        await credencial?.user?.delete();
      } catch (_) {}
      return 'A conta não pôde ser concluída porque houve um erro ao salvar os dados. Tente novamente.';
    }
  }
}
