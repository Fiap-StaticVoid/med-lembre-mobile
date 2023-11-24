import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medlembre/services/lembrete_service.dart';
import 'package:provider/provider.dart';
import 'package:medlembre/models/reminder.dart';
import 'package:medlembre/models/reminders_model.dart';

class AddReminderScreen extends StatefulWidget {
  final Reminder? existingReminder;

  AddReminderScreen({this.existingReminder});

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  String _selectedEmoji = '💧';
  String _frequencyType = 'times_per_day';
  int _timesPerDay = 4;
  int _intervalInHours = 6;
  int _intervalInMinutes = 30;
  final List<String> _emojis = ['💧', '🏃‍♂️', '💊', '📅', '🍎'];

  @override
  void initState() {
    super.initState();
    if (widget.existingReminder != null) {
      _titleController.text = widget.existingReminder!.titulo;
      _selectedDate = widget.existingReminder!.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.existingReminder!.dateTime);
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

  void _saveOrUpdateReminder() async {
    final lembrete = Lembrete(
      null,
      _titleController.text,
      "${_selectedTime.hour}:${_selectedTime.minute}:00",
      2,
      Recorrencia.diario,
      5,
      Recorrencia.mensal,
      false,
    );
    await criarLembrete(lembrete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingReminder == null
            ? 'Adicionar Lembrete'
            : 'Editar Lembrete'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título do Lembrete',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                  'Data de Início: ${DateFormat.yMd().format(_selectedDate)}'),
              subtitle:
                  Text('Hora de Início: ${_selectedTime.format(context)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                await _selectDate(context);
                await _selectTime(context);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveOrUpdateReminder,
              child: Text(
                  widget.existingReminder == null ? 'Adicionar' : 'Editar'),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
