import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioController {
  static const _chaveUsuarios = 'usuarios_app_receitas';
  static const _chaveEmailAtual = 'email_usuario_atual';

  Future<List<Map<String, dynamic>>> _lerUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_chaveUsuarios);
    if (jsonString == null || jsonString.isEmpty) return [];
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<void> _salvarUsuarios(List<Map<String, dynamic>> usuarios) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveUsuarios, jsonEncode(usuarios));
  }

  Future<String?> cadastrar({required String nome, required String email, required String telefone, required String senha}) async {
    final usuarios = await _lerUsuarios();
    final emailNormalizado = email.trim().toLowerCase();
    if (usuarios.any((u) => (u['email'] as String).toLowerCase() == emailNormalizado)) {
      return 'Já existe uma conta cadastrada com esse e-mail.';
    }
    usuarios.add({'nome': nome.trim(), 'email': emailNormalizado, 'telefone': telefone.trim(), 'senha': senha});
    await _salvarUsuarios(usuarios);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveEmailAtual, emailNormalizado);
    return null;
  }

  Future<String?> entrar(String email, String senha) async {
    final usuarios = await _lerUsuarios();
    final emailNormalizado = email.trim().toLowerCase();
    final encontrado = usuarios.where((u) => (u['email'] as String).toLowerCase() == emailNormalizado && u['senha'] == senha);
    if (encontrado.isEmpty) return 'E-mail ou senha incorretos. Crie uma conta se ainda não tiver cadastro.';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveEmailAtual, emailNormalizado);
    return null;
  }

  Future<Map<String, String>?> obterUsuarioAtual() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_chaveEmailAtual);
    if (email == null) return null;
    final usuarios = await _lerUsuarios();
    for (final u in usuarios) {
      if ((u['email'] as String).toLowerCase() == email.toLowerCase()) {
        return {'nome': '${u['nome'] ?? ''}', 'email': '${u['email'] ?? ''}', 'telefone': '${u['telefone'] ?? ''}'};
      }
    }
    return null;
  }

  Future<bool> salvarPerfil({required String nome, required String telefone}) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_chaveEmailAtual);
    if (email == null) return false;
    final usuarios = await _lerUsuarios();
    final indice = usuarios.indexWhere((u) => (u['email'] as String).toLowerCase() == email.toLowerCase());
    if (indice < 0) return false;
    usuarios[indice]['nome'] = nome.trim();
    usuarios[indice]['telefone'] = telefone.trim();
    await _salvarUsuarios(usuarios);
    return true;
  }

  Future<bool> existeEmail(String email) async {
    final usuarios = await _lerUsuarios();
    return usuarios.any((u) => (u['email'] as String).toLowerCase() == email.trim().toLowerCase());
  }

  Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveEmailAtual);
  }
}
