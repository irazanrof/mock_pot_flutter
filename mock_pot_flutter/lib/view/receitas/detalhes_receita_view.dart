import 'package:flutter/material.dart';
import '../../controller/receitas_controller.dart';
import '../../model/receita.dart';

class DetalhesReceitaView extends StatelessWidget {
  final Receita receita;

  const DetalhesReceitaView({
    super.key,
    required this.receita,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ReceitasController.instancia;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da receita'),
        actions: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return IconButton(
                onPressed: () => controller.alternarFavorito(receita),
                icon: Icon(
                  receita.favorita
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: receita.favorita
                      ? const Color(0xFFB66B68)
                      : Colors.grey,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: receita.cor,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              receita.icone,
              size: 90,
              color: const Color(0xFF718873),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            receita.categoria.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF718873),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            receita.nome,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text('Por ${receita.autor}', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.schedule, color: Color(0xFF718873)),
              const SizedBox(width: 8),
              Text('${receita.tempoMinutos} minutos'),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Ingredientes',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...receita.ingredientes.map(
            (ingrediente) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF718873),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(ingrediente)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Modo de preparo',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...receita.preparo.asMap().entries.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xFFE8EDE6),
                    child: Text(
                      '${item.key + 1}',
                      style: const TextStyle(
                        color: Color(0xFF718873),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item.value)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
