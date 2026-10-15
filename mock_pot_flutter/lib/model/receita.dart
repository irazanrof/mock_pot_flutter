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
