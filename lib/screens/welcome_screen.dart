import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 100), // Substitua com seu logo
              SizedBox(height: 48.0),
              Text('Bem vindo!', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen())),
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
