import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get usuarioAtual => _auth.currentUser;

  Future<Map<String, String>?> obterUsuarioAtual() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('usuarios').doc(user.uid).get();
    final data = doc.data() ?? <String, dynamic>{};

    return {
      'nome': '${data['nome'] ?? user.displayName ?? ''}',
      'email': user.email ?? '',
      'telefone': '${data['telefone'] ?? ''}',
    };
  }

  Future<bool> salvarPerfil({
    required String nome,
    required String telefone,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      await _db.collection('usuarios').doc(user.uid).set({
        'nome': nome.trim(),
        'telefone': telefone.trim(),
        'email': user.email,
        'uid': user.uid,
      }, SetOptions(merge: true));
      await user.updateDisplayName(nome.trim());
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> sair() => _auth.signOut();
}
