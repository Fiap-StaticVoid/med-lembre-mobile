import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medlembre/screens/home_screen.dart';
import 'package:medlembre/services/perfil_service.dart';
import 'package:medlembre/services/requestController.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  final PerfilService perfilService =
      PerfilService(RequestController("127.0.0.1:8000"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _birthDateController,
              decoration: InputDecoration(
                labelText: 'Data de Nascimento',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _allergiesController,
              decoration:
                  InputDecoration(labelText: 'Alergias e/ou Restrições'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _bloodTypeController,
              decoration: InputDecoration(labelText: 'Tipo Sanguíneo'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gênero'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                await _registerUser(context);
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser(BuildContext context) async {
    DateTime birthDate =
        DateTime.tryParse(_birthDateController.text) ?? DateTime.now();

    Perfil perfil = Perfil(
      nome: _usernameController.text,
      dataNascimento: birthDate,
      tipoSanguineo: _bloodTypeController.text,
      genero: _genderController.text,
      alergiasERestricoes:
          _allergiesController.text.split(',').map((e) => e.trim()).toList(),
    );

    await perfilService.criarPerfil(perfil);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != initialDate) {
      _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
}
