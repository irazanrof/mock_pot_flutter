import 'package:flutter/material.dart';
import '../../controller/receitas_controller.dart';
import '../../model/receita.dart';

class ListarReceitasView extends StatelessWidget {
  const ListarReceitasView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReceitasController.instancia;

    return Scaffold(
      appBar: AppBar(title: const Text('Receitas')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.receitas.length,
            itemBuilder: (context, index) {
              final receita = controller.receitas[index];

              return _cartaoReceita(context, receita, controller);
            },
          );
        },
      ),
    );
  }

  Widget _cartaoReceita(
    BuildContext context,
    Receita receita,
    ReceitasController controller,
  ) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFEAE8E1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: receita.cor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            receita.icone,
            size: 30,
            color: const Color(0xFF718873),
          ),
        ),
        title: Text(
          receita.nome,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${receita.categoria} • ${receita.tempoMinutos} min',
        ),
        trailing: IconButton(
          onPressed: () => controller.alternarFavorito(receita),
          icon: Icon(
            receita.favorita ? Icons.favorite : Icons.favorite_border,
            color: receita.favorita
                ? const Color(0xFFB66B68)
                : Colors.grey,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            'detalhes_receita',
            arguments: receita,
          );
        },
      ),
    );
  }
}
