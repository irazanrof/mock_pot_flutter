class LoginController {
  bool validarEmail(String email) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email.trim());
  }

  bool validarSenha(String senha) {
    return senha.isNotEmpty;
  }

  bool validarLogin(String email, String senha) {
    return validarEmail(email) && validarSenha(senha);
  }
}
