import 'package:flutter/material.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late IconData _selectedIcon;

  // Lista de ícones disponíveis para escolha.
  final List<IconData> _icons = [
    Icons.medical_services,
    Icons.healing,
    Icons.local_hospital,
    Icons.alarm,
    Icons.fitness_center,
    // Adicione mais ícones conforme necessário.
  ];

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Aqui você pode processar as informações do item e o ícone selecionado
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Lembrete'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Título'),
              onSaved: (value) {
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira um título';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Descrição'),
              onSaved: (value) {
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira uma descrição';
                }
                return null;
              },
            ),
            Wrap(
              spacing: 8.0,
              children: _icons.map((icon) {
                return IconButton(
                  icon: Icon(icon),
                  onPressed: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  color: _selectedIcon == icon ? Colors.blue : Colors.black,
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Salvar Lembrete'),
            ),
          ],
        ),
      ),
    );
  }
}
