class PerfilController {
  bool validarNome(String nome) {
    return nome.trim().length >= 3;
  }

  String obterEmailDemonstracao() {
    return 'visitante@exemplo.com';
  }

  bool salvarPerfil(String nome) {
    return validarNome(nome);
  }
}
