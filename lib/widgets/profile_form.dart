import 'package:flutter/material.dart';

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String birthDate;
  late String bloodType;
  // Adicione outros campos necessários

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Nome'),
            validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            onSaved: (value) => name = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Data de Nascimento'),
            validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            onSaved: (value) => birthDate = value!,
          ),
          // Adicione outros TextFormField para os demais campos
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Salve os dados do perfil
              }
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
