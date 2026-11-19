import 'package:flutter/material.dart';

class Receita {
  Receita({
    required this.nome,
    required this.categoria,
    required this.tempoMinutos,
    required this.icone,
    required this.cor,
    required this.ingredientes,
    required this.preparo,
    this.favorita = false,
    this.autor = 'Mock-pot',
  });

  factory Receita.fromMap(Map<String, dynamic> dados) {
    return Receita(
      nome: dados['nome']?.toString() ?? 'Receita',
      categoria: dados['categoria']?.toString() ?? 'Sem categoria',
      tempoMinutos: (dados['tempoMinutos'] as num?)?.toInt() ?? 0,
      icone: Icons.restaurant,
      cor: const Color(0xFFE8EDE6),
      ingredientes: (dados['ingredientes'] as List<dynamic>? ?? [])
          .map((item) => item.toString()).toList(),
      preparo: (dados['preparo'] as List<dynamic>? ?? [])
          .map((item) => item.toString()).toList(),
      favorita: dados['favorita'] == true,
      autor: dados['autor']?.toString() ?? 'Mock-pot',
    );
  }

  String nome;
  String categoria;
  int tempoMinutos;
  IconData icone;
  Color cor;
  List<String> ingredientes;
  List<String> preparo;
  bool favorita;
  String autor;
}
