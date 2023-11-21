import 'package:flutter/material.dart';
import 'package:medlembre/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Substitua com suas variáveis de usuário (usuário, senha, e-mail)
    String username = "SeuNomeDeUsuário"; 
    String password = "SuaSenha";
    String? email = "SeuEmail@example.com"; // Pode ser nulo

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50, // Tamanho do avatar
              backgroundImage: AssetImage('images/profile.jpg'), // Substitua pelo caminho da sua logo
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showUserData(context, username, password, email),
              child: Text('Visualizar Dados'),
            ),
            ElevatedButton(
              onPressed: () => _confirmLogout(context),
              child: Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserData(BuildContext context, String username, String password, String? email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dados do Usuário'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Usuário: $username'),
                Text('Senha: $password'),
                if (email != null) Text('Email: $email'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmação'),
        content: Text('Tem certeza que deseja sair?'),
        actions: <Widget>[
          TextButton(
            child: Text('Sim'),
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              ); // Redireciona para a tela de login e remove todas as outras telas da pilha
            },
          ),
          TextButton(
            child: Text('Não'),
            onPressed: () => Navigator.of(context).pop(), // Fecha o diálogo
          ),
        ],
      );
    },
  );
  }
}