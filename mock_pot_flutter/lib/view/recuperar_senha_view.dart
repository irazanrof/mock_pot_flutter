import 'package:flutter/material.dart';
import '../controller/recuperar_senha_controller.dart';

class RecuperarSenhaView extends StatefulWidget {
  const RecuperarSenhaView({super.key});
  @override
  State<RecuperarSenhaView> createState() => _RecuperarSenhaViewState();
}

class _RecuperarSenhaViewState extends State<RecuperarSenhaView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = RecuperarSenhaController();
  final _emailController = TextEditingController();
  final bool _carregando = false;
  @override
  void dispose() { _emailController.dispose(); super.dispose(); }

  Future<void> _recuperar() async {
    if (!_formKey.currentState!.validate() || _carregando) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperação de senha'),
        content: const Text(
          'A recuperação de senha por e-mail ainda não está disponível no Mock-pot.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF718873);
    return Scaffold(appBar: AppBar(title: const Text('Recuperar senha')), backgroundColor: const Color(0xFFFAF9F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 64,
                    color: verde,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Esqueceu sua senha?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Informe o e-mail associado à sua conta.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController, 
                    keyboardType: TextInputType.emailAddress, 
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) => v == null || !_controller.validarEmail(v) ? 'Informe um e-mail válido.' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _carregando ? null : _recuperar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: verde,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_carregando ? 'Verificando...' : 'Continuar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
