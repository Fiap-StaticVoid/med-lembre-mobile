import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medlembre/models/reminders_model.dart';
import 'package:medlembre/services/lembrete_service.dart';
import 'package:medlembre/models/reminder.dart';
import 'package:provider/provider.dart';

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

  void _saveOrUpdateReminder() {
    var remindersModel = Provider.of<RemindersModel>(context, listen: false);
    var time =
        "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}:00";
    final lembrete = Lembrete(
      null,
      _titleController.text,
      time,
      2,
      Recorrencia.diario,
      5,
      Recorrencia.mensal,
      false,
    );
    criarLembrete(lembrete).then((value) {
      remindersModel.loadReminders();
      Navigator.of(context).pop();
    });
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título do Lembrete',
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
            ElevatedButton(
              onPressed: _saveOrUpdateReminder,
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: Text(
                  widget.existingReminder == null ? 'Adicionar' : 'Editar'),
            ),
          ],
        ),
      ),
    );
  }
}
