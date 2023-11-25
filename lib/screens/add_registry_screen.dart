import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medlembre/models/registries_model.dart';
import 'package:medlembre/services/registro_service.dart';
import 'package:medlembre/models/reminder.dart';
import 'package:provider/provider.dart';

class AddRegistryScreen extends StatefulWidget {
  final Reminder? existingRegistry;

  AddRegistryScreen({this.existingRegistry});

  @override
  _AddRegistryScreenState createState() => _AddRegistryScreenState();
}

class _AddRegistryScreenState extends State<AddRegistryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.existingRegistry != null) {
      _titleController.text = widget.existingRegistry!.titulo;
      _selectedDate = widget.existingRegistry!.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.existingRegistry!.dateTime);
    } else {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _saveOrUpdateRegistry() async {
    var registriesModel = Provider.of<RegistriesModel>(context, listen: false);
    final registro = Registro(
        null,
        _titleController.text,
        DateFormat('yyyy-MM-dd').format(_selectedDate),
        _observationController.text);
    await criarRegistro(registro).then((value) {
      registriesModel.loadRegistries();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingRegistry == null
            ? 'Adicionar Registro'
            : 'Editar Registro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título do Registro',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                  'Data de Início: ${DateFormat.yMd().format(_selectedDate)}'),
              subtitle:
                  Text('Hora de Início: ${_selectedTime.format(context)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                await _selectDate(context);
                await _selectTime(context);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _observationController,
              decoration: const InputDecoration(
                labelText: 'Observações',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveOrUpdateRegistry,
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: Text(
                  widget.existingRegistry == null ? 'Adicionar' : 'Editar'),
            ),
          ],
        ),
      ),
    );
  }
}
