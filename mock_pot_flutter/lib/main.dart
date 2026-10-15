import 'package:flutter/material.dart';
import 'package:device_preview_plus/device_preview_plus.dart';

import 'model/receita.dart';

import 'view/login_view.dart';
import 'view/cadastro_usuario_view.dart';
import 'view/recuperar_senha_view.dart';
import 'view/principal_view.dart';
import 'view/perfil_view.dart';
import 'view/sobre_view.dart';

import 'view/receitas/listar_receitas_view.dart';
import 'view/receitas/detalhes_receita_view.dart';
import 'view/receitas/buscar_receitas_view.dart';
import 'view/receitas/categorias_receitas_view.dart';
import 'view/receitas/favoritos_view.dart';
import 'view/receitas/criar_receita_view.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF718873);
    const fundo = Color(0xFFFAF9F6);
    const texto = Color(0xFF30352F);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mock-pot',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fundo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: verde,
          surface: fundo,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: fundo,
          foregroundColor: texto,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE5E3DC),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: verde,
              width: 1.5,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: verde,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginView(),
        'cadastro_usuario': (context) => const CadastroUsuarioView(),
        'recuperar_senha': (context) => const RecuperarSenhaView(),
        'principal': (context) => const PrincipalView(),
        'perfil': (context) => const PerfilView(),
        'sobre': (context) => const SobreView(),
        'listar_receitas': (context) => const ListarReceitasView(),
        'criar_receita': (context) => const CriarReceitaView(),
        'buscar_receitas': (context) => const BuscarReceitasView(),
        'categorias_receitas': (context) =>
            const CategoriasReceitasView(),
        'favoritos': (context) => const FavoritosView(),
        'detalhes_receita': (context) {
          final receita =
              ModalRoute.of(context)!.settings.arguments as Receita;
          return DetalhesReceitaView(receita: receita);
        },
      },
    );
  }
}
