import 'package:flutter/material.dart';
import '../controller/sobre_controller.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SobreController();

    const verde = Color(0xFF718873);

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o aplicativo')),
      backgroundColor: const Color(0xFFFAF9F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  size: 80,
                  color: verde,
                ),
                const SizedBox(height: 20),
                Text(
                  controller.obterNomeAplicativo(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  controller.obterDescricao(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Card(
                  color: Colors.white,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sobre o projeto',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Projeto de aplicativo realizado por Eduardo Gabriel Fornazari e Layla Beatriz Damas Alves para a disciplina de Programação para Dispositivos Móveis da Fatec.',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tecnologia: Flutter',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Versão: ${controller.obterVersao()}',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
