class CadastroUsuarioController {
  bool validarNome(String nome) {
    return nome.trim().length >= 3;
  }

  bool validarEmail(String email) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email.trim());
  }

  bool validarSenha(String senha) {
    return senha.length >= 6;
  }

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
}
