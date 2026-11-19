import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/receita.dart';

class ReceitasController extends ChangeNotifier {
  ReceitasController._();
  static final ReceitasController instancia = ReceitasController._();
  final _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _receitas => _db.collection('usuarios').doc(_uid).collection('receitas');
  CollectionReference<Map<String, dynamic>> get _favoritos => _db.collection('usuarios').doc(_uid).collection('favoritos');
  Stream<QuerySnapshot<Map<String, dynamic>>> streamReceitas() => _receitas.orderBy('criadoEm', descending: true).snapshots();
  Stream<QuerySnapshot<Map<String, dynamic>>> streamFavoritos() => _favoritos.orderBy('favoritadoEm', descending: true).snapshots();

  Future<void> adicionar(Receita r) async {
    await _receitas.add({'nome': r.nome, 'categoria': r.categoria, 'tempoMinutos': r.tempoMinutos,
      'ingredientes': r.ingredientes, 'preparo': r.preparo, 'autor': r.autor,
      'favorita': false, 'criadoEm': FieldValue.serverTimestamp(), 'atualizadoEm': FieldValue.serverTimestamp()});
  }

  Future<void> alternarFavorito(String receitaId, Map<String, dynamic> dados, bool favorita) async {
    final ref = _favoritos.doc(receitaId);
    if (favorita) {
      await ref.delete();
      await _receitas.doc(receitaId).update({'favorita': false, 'atualizadoEm': FieldValue.serverTimestamp()});
    } else {
      await ref.set({...dados, 'receitaId': receitaId, 'favoritadoEm': FieldValue.serverTimestamp()});
      await _receitas.doc(receitaId).update({'favorita': true, 'atualizadoEm': FieldValue.serverTimestamp()});
    }
  }

  Future<void> excluir(String id) async {
    await _receitas.doc(id).delete();
    await _favoritos.doc(id).delete();
  }
}
