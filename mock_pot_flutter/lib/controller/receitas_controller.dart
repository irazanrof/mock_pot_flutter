import 'dart:math';
import 'package:flutter/material.dart';
import '../model/receita.dart';

class ReceitasController extends ChangeNotifier {
  ReceitasController._();

  static final ReceitasController instancia = ReceitasController._();

  final List<Receita> _receitas = [
    Receita(
      nome: 'Panquecas de banana',
      categoria: 'Café da manhã',
      tempoMinutos: 15,
      icone: Icons.breakfast_dining,
      cor: const Color(0xFFF1E4CE),
      ingredientes: [
        '1 banana madura',
        '1 ovo',
        '2 colheres de aveia',
        'Canela a gosto',
      ],
      preparo: [
        'Amasse a banana em um recipiente.',
        'Misture o ovo, a aveia e a canela.',
        'Coloque pequenas porções em uma frigideira untada.',
        'Doure dos dois lados e sirva.',
      ],
      favorita: true,
    ),
    Receita(
      nome: 'Macarrão ao molho pesto',
      categoria: 'Almoço',
      tempoMinutos: 25,
      icone: Icons.dinner_dining,
      cor: const Color(0xFFDCE8D8),
      ingredientes: [
        '200 g de macarrão',
        'Manjericão',
        'Azeite',
        'Queijo parmesão',
        'Castanhas',
      ],
      preparo: [
        'Cozinhe o macarrão conforme a embalagem.',
        'Bata o manjericão, o azeite, as castanhas e o queijo.',
        'Misture o molho ao macarrão cozido.',
        'Sirva em seguida.',
      ],
    ),
    Receita(
      nome: 'Bolo de cenoura',
      categoria: 'Sobremesa',
      tempoMinutos: 50,
      icone: Icons.cake_outlined,
      cor: const Color(0xFFF0DFD5),
      ingredientes: [
        '2 cenouras',
        '2 ovos',
        '1 xícara de açúcar',
        '2 xícaras de farinha',
        '1 colher de fermento',
      ],
      preparo: [
        'Bata as cenouras, os ovos e o açúcar.',
        'Misture a farinha e o fermento.',
        'Despeje em uma forma untada.',
        'Asse até que o bolo esteja cozido.',
      ],
    ),
    Receita(
      nome: 'Sanduíche natural',
      categoria: 'Lanche',
      tempoMinutos: 10,
      icone: Icons.lunch_dining,
      cor: const Color(0xFFE8E8D5),
      ingredientes: [
        '2 fatias de pão',
        'Frango desfiado',
        'Cenoura ralada',
        'Alface',
        'Requeijão',
      ],
      preparo: [
        'Misture o frango, a cenoura e o requeijão.',
        'Coloque o recheio sobre o pão.',
        'Adicione a alface e feche o sanduíche.',
      ],
    ),
    Receita(
      nome: 'Salada colorida',
      categoria: 'Almoço',
      tempoMinutos: 20,
      icone: Icons.eco_outlined,
      cor: const Color(0xFFDCE9DD),
      ingredientes: [
        'Alface',
        'Tomate',
        'Pepino',
        'Cenoura',
        'Azeite e limão',
      ],
      preparo: [
        'Lave os vegetais.',
        'Corte os ingredientes em pedaços.',
        'Misture tudo em uma tigela.',
        'Tempere com azeite e limão.',
      ],
    ),
  ];

  List<Receita> get receitas => List.unmodifiable(_receitas);

  List<Receita> get favoritas =>
      _receitas.where((receita) => receita.favorita).toList();

  List<Receita> pesquisar(String texto) {
    return _receitas.where((receita) {
      return receita.nome.toLowerCase().contains(texto.toLowerCase());
    }).toList();
  }

  List<Receita> porCategoria(String categoria) {
    if (categoria == 'Todas') {
      return receitas;
    }

    return _receitas
        .where((receita) => receita.categoria == categoria)
        .toList();
  }

  Receita surpreender() {
    return _receitas[Random().nextInt(_receitas.length)];
  }

  void alternarFavorito(Receita receita) {
    receita.favorita = !receita.favorita;
    notifyListeners();
  }

  void adicionar(Receita receita) {
    _receitas.add(receita);
    notifyListeners();
  }

  void atualizar(Receita antiga, Receita nova) {
    final indice = _receitas.indexOf(antiga);

    if (indice >= 0) {
      _receitas[indice] = nova;
      notifyListeners();
    }
  }

  void excluir(Receita receita) {
    _receitas.remove(receita);
    notifyListeners();
  }
}
