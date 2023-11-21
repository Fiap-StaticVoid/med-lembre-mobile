import 'package:flutter/material.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 8.0),
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Usuário')),
            SizedBox(height: 8.0),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Senha'), obscureText: true),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Aqui você pode adicionar a lógica de registro se necessário
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Registro realizado com sucesso!'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
